import Vapor

struct UserController: RouteCollection {
    let userServiceUrl: String
    
    init(userServiceHostname: String, userServicePort: String) {
        userServiceUrl = "http://\(userServiceHostname):\(userServicePort)"
    }

    
    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("api", "v1", "user")
        
        routeGroup.get(use: getAllHandler)
        routeGroup.get("count", use: getUsersNumber)
        routeGroup.get(":user_id", use: getOneHandler)
        routeGroup.post("auth","register",use: createHandler)
        routeGroup.post("auth","login", use: loginHandler)
        routeGroup.put(":id", use: updateBioUser)
        
    }
    
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(userServiceUrl)/user")
    }
    
    func getUsersNumber(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(userServiceUrl)/user/count")
    }
    
    func getOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let id = try req.parameters.require("user_id", as: UUID.self)
        return req.client.get("\(userServiceUrl)/user/\(id)")
    }
    
    
    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        
        return req.client.post("\(userServiceUrl)/user/auth/register") {
            createRequest in
            try createRequest.content.encode(req.content.decode(CreateUserData.self))
        }
    }
    
    func updateBioUser(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("id", as: UUID.self)
        
        return req.client.put("\(userServiceUrl)/user/\(id)"){
            put in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            put.headers.add(name: .authorization, value: authHeader)
            
            try put.content.encode(req.content.decode(UpdateUserBio.self))
        }
    }
    
    
    func loginHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        
        return req.client.post("\(userServiceUrl)/user/auth/login") { loginRequst in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            loginRequst.headers.add(name: .authorization, value: authHeader)
        }
    }
}
