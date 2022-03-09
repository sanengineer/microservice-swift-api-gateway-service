import Vapor

func routes(_ app: Application) throws {
    // let userHostname: String
    let _userUrl: String = Environment.get("USER_URL")!
    let userUrl: String
    // let productHostname: String
    // let orderHostname: String
    // let cartHostname: String
    // let varianHostname: String
    // let categoryHostname: String
    
    // let userPort: String = Environment.get("USER_PORT")!
    // let cartPort: String = Environment.get("CART_PORT")!
    // let productPort: String = Environment.get("PRODUCT_PORT")!
    // let orderPort: String = Environment.get("ORDER_PORT")!
    // let varianPort: String = Environment.get("VARIAN_PORT")!
    // let categoryPort: String = Environment.get("CATEGORY_PORT")!
    // let serverPort: Int = Int(Environment.get("SERVER_PORT")!)!
    // let serverPort: Int

    // guard let serverHostname = Environment.get("SERVER_HOSTNAME") else {
    //     return print("No Env Server Hostname")
    // }
    
    // if let serverEnvPort = Environment.get("SERVER_PORT") {
    //     serverPort = Int(serverEnvPort) ?? 8081
    // } else {
    //     serverPort = 8081
    // }

    // if let userEnvHostname = Environment.get("USER_HOSTNAME"){
    //     userHostname = userEnvHostname
    // } else {
    //     userHostname = "localhost"
    // }

    if let userUrlEnv = Environment.get("USER_URL"){
        userUrl = "http://\(userUrlEnv)"
    } else {
        userUrl = _userUrl
    }
    
    
    // if let productEnvHostname = Environment.get("PRODUCT_HOSTNAME"){
    //     productHostname = productEnvHostname
    // } else {
    //     productHostname = "localhost"
    // }
    
    
    // if let orderEnvHostname = Environment.get("ORDER_HOSTNAME"){
    //     orderHostname = orderEnvHostname
    // } else {
    //     orderHostname = "localhost"
    // }

    
    // if let cartEnvHostname = Environment.get("CART_HOSTNAME"){
    //     cartHostname = cartEnvHostname
    // } else {
    //     cartHostname = "localhost"
    // }
    
    
    // if let varianEnvHostname = Environment.get("VARIAN_HOSTNAME"){
    //     varianHostname = varianEnvHostname
    // } else {
    //     varianHostname = "localhost"
    // }
    
    // if let categoryEnvHostname = Environment.get("CATEGORY_HOSTNAME"){
    //     categoryHostname = categoryEnvHostname
    // } else {
    //     categoryHostname = "localhost"
    // }
    
    let corsConfiguration = CORSMiddleware.Configuration(
        allowedOrigin: .all,
        allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
        allowedHeaders: [.accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent, .accessControlAllowOrigin]
    )
    let cors = CORSMiddleware(configuration: corsConfiguration)

    // Only add this if you want to enable the default per-route logging
    let routeLogging = RouteLoggingMiddleware(logLevel: .info)

    // Add the default error middleware
    let error = ErrorMiddleware.default(environment: app.environment)
    // Clear any existing middleware.
    app.middleware = .init()
    app.middleware.use(cors)
    app.middleware.use(routeLogging)
    app.middleware.use(error)
    
    
    app.logger.logLevel = .debug
    // app.http.server.configuration.hostname = serverHostname
    // app.http.server.configuration.port = serverPort

    // try app.register(collection: UserController(userServiceHostname: userHostname, userServicePort: userPort))

    try app.register(collection: UserController(_userServiceUrl: userUrl ))

    try app.register(collection: RoleController(_roleServiceUrl: userUrl ))
    
    // try app.register(collection: ProductController(productServiceHostName: productHostname, productServicePort: productPort))
    
    // try app.register(collection: OrderController(orderServiceHostname: orderHostname, orderServicePort: orderPort))
    
    // try app.register(collection: CartController(cartServicesHostname: cartHostname, cartServicesPort:cartPort))
    
    // try app.register(collection: ItemController(itemServicesHostname: cartHostname, itemServicesPort: cartPort))
    
    // try app.register(collection: VarianController(varianServiceHostname: varianHostname, varianServicePort: varianPort))
    
    // try app.register(collection: CategoryController(categoryServicesHostname: categoryHostname, categoryServicesPort: categoryPort))
}
