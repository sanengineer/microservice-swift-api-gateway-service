import Vapor

struct ProductController: RouteCollection {
    
    let productServiceUrl:String
    
    init(productServiceHostName: String, productServicePort: String) {
        productServiceUrl = "http://\(productServiceHostName):\(productServicePort)"
    }
    
    
    func boot(routes: RoutesBuilder) throws {
        let productRouteGroup = routes.grouped("api", "v1", "product")
        
        productRouteGroup.get( use: getAllHandler)
        productRouteGroup.get( ":product_id", use: getOneHandler)
        productRouteGroup.get( "count", use: getCountHandler)
        productRouteGroup.get( "result", use: getSearchHandler)
        
        productRouteGroup.post( use: createHandler)
        productRouteGroup.put(":product_id", use: updateHandler)
        productRouteGroup.delete(":product_id", use: deleteHandler)
        
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
    
    
    func getSearchHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {

        guard let searchQuery = req.query[String.self, at: "search_query"] else { throw Abort(.badRequest) }

        return req.client.get("\(productServiceUrl)/product/result?search_query=\(searchQuery)")
    }
    
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(productServiceUrl)/product") { createRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            createRequest.headers.add(name: .authorization, value: authHeader)
            try createRequest.content.encode(req.content.decode(CreateProductData.self))
        }
    }
    
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let productId = try req.parameters.require("product_id", as: UUID.self)
        
        return req.client.put("\(productServiceUrl)/product/\(productId)") { updateReq in
            guard let authHeader = req.headers[.authorization].first else { throw Abort(.unauthorized ) }
            updateReq.headers.add(name: .authorization, value: authHeader)
            try updateReq.content.encode(req.content.decode(CreateProductData.self))
        }
    }
    
    
    func deleteHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let productId = try req.parameters.require("product_id", as: UUID.self)
        
        return req.client.delete("\(productServiceUrl)/product/\(productId)") { deleteReq in
            guard let authHeader = req.headers[.authorization].first else { throw Abort(.unauthorized) }
            deleteReq.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    
}

struct CreateProductData: Content {
    let name: String
    let descriptions: String
    let price: Int
    let image_featured: String
}

struct SearchData: Content {
    let value: String
}
