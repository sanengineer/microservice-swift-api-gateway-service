import Vapor

struct CreateUserData: Content {
    let name: String
    let username: String
    let password: String
    let email: String
    let role_id: Int
}

struct UpdateUserBio: Content {
    var gender: String?
    var date_of_birth: String?
    var mobile: String?
    var province: String?
    var email: String?
    var city: String?
    var country: String?
    var domicile: String?
    var residence: String?
    var shipping_address_default: String?
}
