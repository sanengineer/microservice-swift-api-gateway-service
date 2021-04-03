import Vapor

func routes(_ app: Application) throws {
    let userHostname: String
    let productHostname: String
    
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

    
    app.logger.logLevel = .debug

    try app.register(collection: UserController(userServiceHostname: userHostname))
    
    try app.register(collection: ProductController(productServiceHostName: productHostname))
    
}
