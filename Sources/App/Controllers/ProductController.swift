import Vapor

struct ProductController: RouteCollection {
    
    let productServiceUrl:String
    
    init(_productServiceUrl: String) {
        productServiceUrl = "\(_productServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let productRouteGroup = routes.grouped("api", "v1", "product")
        
        productRouteGroup.get( use: getAllHandler)
        productRouteGroup.get( ":product_id", use: getOneHandler)
        productRouteGroup.get( "count", use: getCountHandler)
        productRouteGroup.get( "result", use: getSearchHandler)
        
    }
    
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(productServiceUrl)/product"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    
    func getOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("product_id", as: UUID.self)
        return req.client.get("\(productServiceUrl)/product/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    
    func getCountHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(productServiceUrl)/product/count"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    
    func getSearchHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {

        guard let searchQuery = req.query[String.self, at: "search_query"] else { throw Abort(.badRequest) }

        return req.client.get("\(productServiceUrl)/product/result?search_query=\(searchQuery)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
    
}
