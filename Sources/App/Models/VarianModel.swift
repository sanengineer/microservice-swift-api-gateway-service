import Vapor

struct CreateVarianData: Content {
    let size: String
    let sugar: String
    let ice: String
    let item_id: UUID
    let user_id: UUID
}

struct VarianDelete: Content {
    let item_id: UUID
    let user_id: UUID
}

struct VarianResponseDelete: Content {
    let status: Bool
    let message: String
}
