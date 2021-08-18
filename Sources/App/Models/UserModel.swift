import Vapor

struct CreateUserData: Content {
    let name: String
    let username: String
    let password: String
    let email: String
    let role_id: Int
}

struct GetUserData: Content {
    let name: String
    let username: String
    let email: String
    let id: UUID
}


struct UpdateUserBio: Content {
    var mobile: String?
    var point_reward: String?
    var geo_location: String?
    var city: String?
    var province: String?
    var country: String?
    var domicile: String?
    var residence: String?
    var shipping_address_default: String?
    var shipping_address_id: UUID?
    var gender: String?
    var date_of_birth: String?
}