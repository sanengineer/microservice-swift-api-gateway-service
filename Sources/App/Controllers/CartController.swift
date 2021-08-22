import Vapor

struct CartController: RouteCollection {
    let cartServiceUrl: String
    
    init(cartServicesHostname: String, cartServicesPort:String) {
        cartServiceUrl = "http://\(cartServicesHostname):\(cartServicesPort)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let cartRouteGroup = routes.grouped("api","v1", "cart")
    
        cartRouteGroup.get(":cart_id", use: getOneCart)
        cartRouteGroup.post(use: createCart)
    }
    
    func getOneCart(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("cart_id", as: String.self)
        
        return req.client.get("\(cartServiceUrl)/cart/\(id)"){
            getAllCartReq in
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            getAllCartReq.headers.add(name: .authorization, value: authHeader)
        }
    }
    
    func createCart(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(cartServiceUrl)/cart"){ createRequest in

            try createRequest.content.encode(req.content.decode(CreateCartData.self))
            
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            
            createRequest.headers.add(name: .authorization, value: authHeader)
            
            //debug
            print("\nID:", try createRequest.content.encode(req.content.decode(CreateCartData.self)),"\n")
            print("\nAUTHHHH:",authHeader,"\n")
            
         
        }
    }
    
    
  
}
