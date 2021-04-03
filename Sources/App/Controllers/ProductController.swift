import Vapor

struct ProductController: RouteCollection {
    
    let productServiceUrl:String
    
    init(productServiceHostName: String) {
        productServiceUrl = "http://\(productServiceHostName):5689"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let productRouteGroup = routes.grouped("api", "v1", "product")
        
        productRouteGroup.get( use: getAllHandler)
        productRouteGroup.get( ":product_id", use: getOneHandler)
        productRouteGroup.get( "count", use: getCountHandler)
//        productRouteGroup.post( use: createHandler)
//        productRouteGroup.put(":product_id", use: createHandler)
//        productRouteGroup.delete(":product_id", use: createHandler)
    }
    
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(productServiceUrl)/product")
    }
    
    
    func getOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let id = try req.parameters.require("product_id", as: UUID.self)
        
        return req.client.get("\(productServiceUrl)/product/\(id)")
    }
    
    func getCountHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        
        return req.client.get("\(productServiceUrl)/product/count")
    }
    
//    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
//
//        let productId = try req.parameters.require("product_id", as: UUID.self)
//
//        return req.client.put("\(productServiceUrl)/") { createRequest in
//
//            guard let authHeader = req.headers[.authorization].first else {
//                throw Abort(.unauthorized)
//            }
//
//            createRequest.headers.add(name: .authorization, value: authHeader)
//            try createRequest.content.encode(req.content.decode(CreateProductData.self))
//        }
//    }
    
}

struct CreateProductData: Content {
    let name: String
    let descriptions: String
    let price: String
    let image_featured: String
}
