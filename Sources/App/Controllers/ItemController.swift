import Vapor

struct ItemController: RouteCollection {
    let itemServiceUrl: String
    
    init(_itemServiceUrl: String) {
        itemServiceUrl = "\(_itemServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        
        let routeGroup = routes.grouped("api", "v1", "item")
        
        routeGroup.get(use: getAll)
        routeGroup.post(use: create)
        routeGroup.get(":item_id", use: getOne)
        routeGroup.get("cart",":cart_id", use: getOneByCartId)
        routeGroup.get("user",":user_id", use: getOneByUserId)
        routeGroup.put(":item_id", use: update)
        routeGroup.delete(":item_id", use: deleteOne)
    }
    
    // item
    func getAll(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(itemServiceUrl)/item"){ getOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOne(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("item_id", as: String.self)
        return req.client.get("\(itemServiceUrl)/item/\(id)"){ getOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOneByUserId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("user_id", as: String.self)
        return req.client.get("\(itemServiceUrl)/item/user/\(id)"){ getOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOneByCartId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("cart_id", as: String.self)
        return req.client.get("\(itemServiceUrl)/item/cart/\(id)"){ getOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(itemServiceUrl)/item"){ createOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            createOne.headers.add(name: .authorization, value: authHeader)
            try createOne.content.encode(req.content.decode(ItemCreate.self))
        }
    }

    func update(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("item_id", as: String.self)
        return req.client.put("\(itemServiceUrl)/item/\(id)"){ putOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            putOne.headers.add(name: .authorization, value: authHeader)
             try putOne.content.encode(req.content.decode(ItemUpdate.self))
        }
    }
    
    func deleteOne(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("item_id", as: String.self)
        return req.client.delete("\(itemServiceUrl)/item/\(id)"){ deleteOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            deleteOne.headers.add(name: .authorization, value: authHeader)
        }
    }
}
