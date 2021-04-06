import Vapor

struct OrderController: RouteCollection {
    
    let orderServiceUrl: String
    
    init(orderServiceHostname: String){
        orderServiceUrl = "http://\(orderServiceHostname):1234"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let orderRouteGroup = routes.grouped("api", "v1", "order")
        
        orderRouteGroup.get(use: getAllHandler)
        orderRouteGroup.get(":order_id", use: getOneHandler)
        orderRouteGroup.get("user",":user_id", use: getOneByUserIdHandler)
        orderRouteGroup.get("user",":user_id", "count" ,use: getOrderNumbersByUserId)
        orderRouteGroup.post(use: createHandler)
        orderRouteGroup.put(":order_id", use: updateHandler)
        orderRouteGroup.delete(":order_id", use: deleteOneHandler)
        
        
    }
    
    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(orderServiceUrl)/order")
    }
    
    func getOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
    
        let id = try req.parameters.require("order_id", as: UUID.self)
        
        return req.client.get("\(orderServiceUrl)/order/\(id)")
    }
    
    func getOneByUserIdHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let userId = try req.parameters.require("user_id", as: UUID.self)
        
        return req.client.get("\(orderServiceUrl)/order/user/\(userId)")
    }
    
    func getOrderNumbersByUserId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
      
        let userId = try req.parameters.require("user_id", as: UUID.self)
        
        
        return req.client.get("\(orderServiceUrl)/order/user/\(userId)/count")
    }
    
    func createHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(orderServiceUrl)/order") {
            createRequest in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            createRequest.headers.add(name: .authorization, value: authHeader)
            
            try createRequest.content.encode(req.content.decode(CreateOrderData.self))
        }
    }
    
    
    func updateHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        
        let orderId = try req.parameters.require("order_id", as: UUID.self)
        
        return req.client.put("\(orderServiceUrl)/order/\(orderId)") {
            updateRequest in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            updateRequest.headers.add(name: .authorization, value: authHeader)
            
            try updateRequest.content.encode(req.content.decode(CreateOrderData.self))
        }
    }
    
    func deleteOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let orderId = try req.parameters.require("order_id", as: UUID.self)
        
        return req.client.delete("\(orderServiceUrl)/order/\(orderId)"){
            deleteReq in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized) }
            
            deleteReq.headers.add(name: .authorization, value: authHeader)
            
        }
    }
}

struct CreateOrderData: Content {
    let name: String
    let user_id: String
}
