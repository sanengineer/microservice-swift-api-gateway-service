import Vapor

func routes(_ app: Application) throws {
    let userHostname: String
    let productHostname: String
    let orderHostname: String
    
    if let userEnvHostname = Environment.get("USER_HOSTNAME"){
        userHostname = userEnvHostname
    } else {
        userHostname = "localhost"
    }
    
    if let productEnvHostname = Environment.get("PRODUCT_HOSTNAME"){
        productHostname = productEnvHostname
    } else {
        productHostname = "localhost"
    }
    
    if let orderEnvHostname = Environment.get("ORDER_HOSTNAME"){
        orderHostname = orderEnvHostname
    } else {
        orderHostname = "localhost"
    }

    
    app.logger.logLevel = .debug

    try app.register(collection: UserController(userServiceHostname: userHostname))
    
    try app.register(collection: ProductController(productServiceHostName: productHostname))
    
    try app.register(collection: OrderController(orderServiceHostname: orderHostname))
}
