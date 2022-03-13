import Vapor

struct ProductController: RouteCollection {
    
    let productServiceUrl:String
    
    init(_productServiceUrl: String) {
        productServiceUrl = "\(_productServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let productRouteGroup = routes.grouped("api", "v1", "product")
        
        productRouteGroup.post(use: createHandler)
        productRouteGroup.get(use: getAllHandler)
        productRouteGroup.get(":product_id", use: getOneHandler)
        // productRouteGroup.put(":product_id", use: updateCategoryId)
        productRouteGroup.put(":product_id", use: updateOneHandler)
        productRouteGroup.delete(":product_id", use: deleteOneHandler)
        productRouteGroup.get("count", use: getCountHandler)
        productRouteGroup.get("result", use: getSearchHandler)   
    }
    
    
    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(productServiceUrl)/product"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)

            try getRequest.content.encode(req.content.decode(CreateProductData.self))
        }
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

    func updateOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("product_id", as: UUID.self)

        return req.client.put("\(productServiceUrl)/product/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)

            try getRequest.content.encode(req.content.decode(CreateProductData.self))
        }
    }

    func deleteOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("product_id", as: UUID.self)

        return req.client.delete("\(productServiceUrl)/product/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
}
