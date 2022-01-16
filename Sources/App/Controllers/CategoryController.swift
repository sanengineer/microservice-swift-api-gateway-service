import Vapor

struct CategoryController: RouteCollection {
    let categoryServiceUrl: String
    
    init(categoryServicesHostname: String, categoryServicesPort: String) {
        categoryServiceUrl = "http://\(categoryServicesHostname):\(categoryServicesPort)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let categoryGroup = routes.grouped("api", "v1", "category")
     
        categoryGroup.get( use: getAllCategory)
        categoryGroup.get(":category_id", use: getOneCategory)
    }
    
    func getAllCategory(_ req: Request) -> EventLoopFuture<ClientResponse> {
        
        return req.client.get("\(categoryServiceUrl)/category/"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
  
    
    func getOneCategory(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let id = try req.parameters.require("category_id", as: UUID.self)
        
        return req.client.get("\(categoryServiceUrl)/category/\(id)"){
            getRequest in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
}
