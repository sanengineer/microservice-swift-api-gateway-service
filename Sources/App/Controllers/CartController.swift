import Vapor

struct CartController: RouteCollection {
    let cartServiceUrl: String
    
    init(_cartServiceUrl: String) {
        cartServiceUrl = "\(_cartServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("api","v1", "cart")
    
        routeGroup.get(use: getAll)
        routeGroup.post(use: create)
        routeGroup.get(":user_id",":cart_id", use: getOneByCartId)
        routeGroup.get(":user_id", use: getOneByUserId)
        routeGroup.delete(":user_id", ":cart_id", use: deleteOneByCartId)
    }
    
    func create(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(cartServiceUrl)/cart"){ createRequest in
            try createRequest.content.encode(req.content.decode(CreateCartData.self))
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            createRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getAll(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(cartServiceUrl)/cart"){ getAll in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getAll.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOneByUserId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let user_id = try req.parameters.require("user_id", as: String.self)
        return req.client.get("\(cartServiceUrl)/cart/\(user_id)"){
            getOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOneByCartId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let cart_id = try req.parameters.require("cart_id", as: String.self)
        let user_id = try req.parameters.require("user_id", as: String.self)
        return req.client.get("\(cartServiceUrl)/cart/\(user_id)/\(cart_id)"){
            getAll in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getAll.headers.add(name: .authorization, value: authHeader)
        }
    }


    func deleteOneByCartId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let cart_id = try req.parameters.require("cart_id", as: String.self)
        let user_id = try req.parameters.require("user_id", as: String.self)
        return req.client.delete("\(cartServiceUrl)/cart/\(user_id)/\(cart_id)"){
            deleteOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            deleteOne.headers.add(name: .authorization, value: authHeader)
        }
    }


    
    
  
}
