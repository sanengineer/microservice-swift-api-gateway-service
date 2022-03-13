import Vapor

struct CreateProductData: Content {
    let name: String
    let description: String
    let price: Int
    let image_featured: String
}

struct ProductDataUpdate: Content {
    let name: String?
    let description: String?
    let price: Int?
    let image_featured: String?
}

struct SearchData: Content {
    let value: String
}

