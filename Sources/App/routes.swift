import Vapor


func routes(_ app: Application) throws {
    let userUrl: String
    let productUrl: String
    let categoryUrl: String
    let cartUrl: String
    let orderUrl: String
    let varianUrl: String
    let toppingUrl: String
    let itemUrl: String
    let imageUrl: String
 
    guard let userUrlEnv = Environment.get("USER_URL") else {
        return print("No Env User URL")
    }
    guard let productUrlEnv = Environment.get("PRODUCT_URL") else {
        return print("No Env Product Hostname")
    }
    guard let categoryUrlEnv = Environment.get("CATEGORY_URL") else {
        return print("No Env Category Hostname")
    }
    guard let cartUrlEnv = Environment.get("CART_URL") else {
        return print("No Env Cart Hostname")
    }
    guard let orderUrlEnv = Environment.get("ORDER_URL") else {
        return print("No Env Order Hostname")
    }
    guard let varianUrlEnv = Environment.get("VARIAN_URL") else {
        return print("No Env Varian Hostname")
    }
    guard let toppingUrlEnv = Environment.get("TOPPING_URL") else {
        return print("No Env Topping Hostname")
    }
    guard let itemUrlEnv = Environment.get("ITEM_URL") else {
        return print("No Env Item Hostname")
    }
    guard let imageUrlEnv = Environment.get("IMAGE_URL") else {
        return print("No Env Image Hostname")
    }

    userUrl = "\(userUrlEnv)"
    productUrl = "\(productUrlEnv)"
    categoryUrl = "\(categoryUrlEnv)"
    cartUrl = "\(cartUrlEnv)"
    orderUrl = "\(orderUrlEnv)"
    varianUrl = "\(varianUrlEnv)"
    toppingUrl = "\(toppingUrlEnv)"
    itemUrl = "\(itemUrlEnv)"
    imageUrl = "\(imageUrlEnv)"

    try app.register(collection: UserController(_userServiceUrl: userUrl ))
    try app.register(collection: RoleController(_roleServiceUrl: userUrl ))
    try app.register(collection: ProductController(_productServiceUrl: productUrl))
    try app.register(collection: CategoryController(_categoryServiceUrl: categoryUrl))
    try app.register(collection: CartController(_cartServiceUrl: cartUrl))
    try app.register(collection: OrderController(_orderServiceUrl: orderUrl))
    try app.register(collection: VarianController(_varianServiceUrl: varianUrl))
    try app.register(collection: ToppingController(_toppingServiceUrl: toppingUrl))
    try app.register(collection: ItemController(_itemServiceUrl: itemUrl))
    try app.register(collection: ImageController(_imageServiceUrl: imageUrl))
}
