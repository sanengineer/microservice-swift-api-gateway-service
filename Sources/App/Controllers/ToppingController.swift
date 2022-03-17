import Vapor

struct ToppingController: RouteCollection {
    let toppingServiceUrl: String
    
    init(_toppingServiceUrl: String) {
        toppingServiceUrl = "\(_toppingServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let routeGroup = routes.grouped("api", "v1", "topping")
        
        routeGroup.get(use: getAll)
        routeGroup.post(use: create)
        routeGroup.get(":topping_id", use: getOne)
        routeGroup.put(":topping_id", use: update)
        routeGroup.delete(":topping_id", use: deleteOne)
    }
    
    func getAll(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(toppingServiceUrl)/topping"){ getOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOne(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("topping_id", as: String.self)
        return req.client.get("\(toppingServiceUrl)/topping/\(id)"){ getOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getOne.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    func create(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(toppingServiceUrl)/topping"){ createOne in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            createOne.headers.add(name: .authorization, value: authHeader)
            try createOne.content.encode(req.content.decode(ToppingCreate.self))
        }
    }

    func update(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("topping_id", as: String.self)
        return req.client.put("\(toppingServiceUrl)/topping/\(id)"){ putOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            putOne.headers.add(name: .authorization, value: authHeader)
             try putOne.content.encode(req.content.decode(ToppingUpdate.self))
        }
    }
    
    func deleteOne(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("topping_id", as: String.self)
        return req.client.delete("\(toppingServiceUrl)/topping/\(id)"){ deleteOne in  
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            deleteOne.headers.add(name: .authorization, value: authHeader)
        }
    }
}
