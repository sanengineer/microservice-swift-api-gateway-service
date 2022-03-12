import Vapor


func routes(_ app: Application) throws {
    let userUrl: String
    let productUrl: String
    let categoryUrl: String
 
    guard let userUrlEnv = Environment.get("USER_URL") else {
        return print("No Env User URL")
    }
    
    guard let productUrlEnv = Environment.get("PRODUCT_URL") else {
        return print("No Env Product Hostname")
    }

    guard let categoryUrlEnv = Environment.get("CATEGORY_URL") else {
        return print("No Env Product Hostname")
    }

    userUrl = "\(userUrlEnv)"
    productUrl = "\(productUrlEnv)"
    categoryUrl = "\(categoryUrlEnv)"

    try app.register(collection: UserController(_userServiceUrl: userUrl ))
    try app.register(collection: RoleController(_roleServiceUrl: userUrl ))
    try app.register(collection: ProductController(_productServiceUrl: productUrl))
    try app.register(collection: CategoryController(_categoryServiceUrl: categoryUrl))
    
    
}
