import Vapor

struct VarianController: RouteCollection {
    let varianServiceUrl: String
    
    init(_varianServiceUrl: String) {
        varianServiceUrl = "\(_varianServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let varianRouteGroup = routes.grouped("api", "v1", "varian")
        varianRouteGroup.get(use: getAllVarian)
    }
    
    func getAllVarian(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(varianServiceUrl)/varian"){
            get in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            get.headers.add(name: .authorization, value: authHeader)
            
        }
    }
}

