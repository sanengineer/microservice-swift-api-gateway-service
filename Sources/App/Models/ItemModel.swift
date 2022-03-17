import Vapor

struct ItemCreate: Content {
    let product_id: UUID
    let cart_id: UUID
    let topping_id: UUID
    let varian_id: UUID
    let user_id: UUID
}

struct ItemUpdate: Content {
    let product_id: UUID?
    let cart_id: UUID?
    let topping_id: UUID?
    let varian_id: UUID?
    let user_id: UUID?
}


 

   