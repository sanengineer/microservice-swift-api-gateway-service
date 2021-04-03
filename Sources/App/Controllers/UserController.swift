import Vapor

struct UserController: RouteCollection {
    let userServiceUrl: String
    
    init(userServiceHostname: String) {
        userServiceUrl = "http://\(userServiceHostname):4568"
    }

    
    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("api", "v1", "user")
        
        routeGroup.get(use: getAllHandler)
        routeGroup.get(":user_id", use: getOneHandler)
        routeGroup.post("auth","register",use: createHandler)
        routeGroup.post("auth","login", use: loginHandler)
        
    }
    
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(userServiceUrl)/user")
    }
    
    
    func getOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let id = try req.parameters.require("user_id", as: UUID.self)
        return req.client.get("\(userServiceUrl)/user/\(id)")
    }
    
    
    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        
        return req.client.post("\(userServiceUrl)/user") {
            createRequest in
            try createRequest.content.encode(req.content.decode(CreateUserData.self))
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

struct CreateUserData: Content {
    let name: String
    let username: String
    let password: String
}
