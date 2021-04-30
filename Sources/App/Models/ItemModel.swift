import Vapor

struct CreateItemData: Content {
    let product_id: String
    let cart_id: String
}
