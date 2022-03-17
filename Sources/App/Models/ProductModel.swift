import Vapor

struct CreateProductData: Content {
    let name: String
    let description: String
    let price: Int
    let image_featured: String
    let category_id: UUID?
}

struct ProductDataUpdate: Content {
    let name: String?
    let description: String?
    let price: Int?
    let image_featured: String?
    let category_id: UUID?
}

struct SearchData: Content {
    let value: String
}

