import Vapor

struct OrderCreate: Content {
    var status: String
    var payment_url: String
    var diskon: Float?
    var tax: Float?
    var shipping_platform: String?
    var shipping_cost: Float?
    var shipping_address: String?
    var shipping_track_id: String?
    var total_product_price: Float?
    var grand_total_price: Float?
    var collect_self: Bool?
    var cart_id: UUID
    var user_id: UUID
    var geo_loc_id: UUID?
    var name: String
    var email: String
    var city: String?
    var province: String?
    var postal_code: String?
    var country: String?
    var mobile_phone: String
    var billing_address: String?
}

struct OrderUpdate: Content {
    var status: String?
    var payment_url: String?
    var diskon: Float?
    var tax: Float?
    var shipping_platform: String?
    var shipping_cost: Float?
    var shipping_address: String?
    var shipping_track_id: String?
    var total_product_price: Float?
    var grand_total_price: Float?
    var collect_self: Bool?
    var geo_loc_id: UUID?
    var name: String?
    var email: String?
    var city: String?
    var province: String?
    var postal_code: String?
    var country: String?
    var mobile_phone: String?
    var billing_address: String?
    var created_at: Date?
    var updated_at: Date?
}

struct OrderCheckId: Content {
    var user_id: UUID
}

struct OrderCheckNumber: Content {
    var num: Int
}

struct OrderLanding: Content{
    var title: String
}