import Vapor


struct ToppingCreate: Content {
    let title: String
    let description: String
    let image_featured: String
    let price: Float
}

struct ToppingUpdate: Content {
    let title: String?
    let description: String?
    let image_featured: String?
    let price: Float?
}

struct ToppingLanding: Content {
    let title: String
}