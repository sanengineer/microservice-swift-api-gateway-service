import Vapor

func routes(_ app: Application) throws {
    let userHostname: String
    let productHostname: String
    let orderHostname: String
    let cartHostname: String
    
    let userPort: String = Environment.get("USER_PORT")!
    let cartPort: String = Environment.get("CART_PORT")!
    let productPort: String = Environment.get("PRODUCT_PORT")!
    let orderPort: String = Environment.get("ORDER_PORT")!
    
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

    
    if let cartEnvHostname = Environment.get("CART_HOSTNAME"){
        cartHostname = cartEnvHostname
    } else {
        cartHostname = "localhost"
    }
    
    
    app.logger.logLevel = .debug

    try app.register(collection: UserController(userServiceHostname: userHostname, userServicePort: userPort))
    
    try app.register(collection: ProductController(productServiceHostName: productHostname, productServicePort: productPort))
    
    try app.register(collection: OrderController(orderServiceHostname: orderHostname, orderServicePort: orderPort))
    
    try app.register(collection: CartController(cartServicesHostname: cartHostname, cartServicesPort:cartPort))
    
    try app.register(collection: ItemController(itemServicesHostname: cartHostname, itemServicesPort: cartPort))
}
