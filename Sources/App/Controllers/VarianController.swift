import Vapor

struct VarianController: RouteCollection {
    let varianServiceUrl: String
    
    init(varianServiceHostname: String, varianServicePort: String) {
        varianServiceUrl = "http://\(varianServiceHostname):\(varianServicePort)"
    }
    
    
    func boot(routes: RoutesBuilder) throws {
        let varianRouteGroup = routes.grouped("api", "v1", "varian")
        
        varianRouteGroup.get(use: getAllVarian)
        varianRouteGroup.post(use: createOneVarian)
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
    
    
    func createOneVarian(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(varianServiceUrl)/varian"){
            createRequest in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            createRequest.headers.add(name: .authorization, value: authHeader)
            
            try createRequest.content.encode(req.content.decode(CreateVarianData.self))
        }
    }
    
    
    
}

