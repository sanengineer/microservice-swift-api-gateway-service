import Vapor

struct ImageCreate: Content{
    let file: File
    let type: String
}

struct ImageDelete: Content{
    let id: UUID
    let type: String
    let user_id: UUID
}

struct ImageType: Content{
    let type: String
}

struct ImageQuery: Content {
    let user_id: UUID
    let type: String
}
