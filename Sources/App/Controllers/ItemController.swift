import Vapor

struct ItemController: RouteCollection {
    let itemServiceUrl: String
    
    init(itemServicesHostname: String, itemServicesPort: String) {
        itemServiceUrl = "http://\(itemServicesHostname):\(itemServicesPort)"
    }
    
    
    func boot(routes: RoutesBuilder) throws {
        
        let itemRouteGroup = routes.grouped("api", "v1", "item")
        
        itemRouteGroup.get(use: getAllItem)
        itemRouteGroup.post(use: createOneItem)
        itemRouteGroup.delete(":item_id", use: deleteOneItem)
    }
    
    
    // item
    func getAllItem(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(itemServiceUrl)/item"){ getOneItemReq in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getOneItemReq.headers.add(name: .authorization, value: authHeader)
            
        }
    }
    
    
    func createOneItem(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        return req.client.post("\(itemServiceUrl)/item"){ createOneItemReq in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            createOneItemReq.headers.add(name: .authorization, value: authHeader)
            
            try createOneItemReq.content.encode(req.content.decode(CreateItemData.self))
        }
    }
    
    
    func deleteOneItem(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let id = try req.parameters.require("item_id", as: String.self)
        
        return req.client.delete("\(itemServiceUrl)/item/\(id)"){ deleteOneItemReq in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            deleteOneItemReq.headers.add(name: .authorization, value: authHeader)
        }
    }
}
