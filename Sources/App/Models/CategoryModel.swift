import Vapor


struct CreateCategoryData: Content {
    var title: String
    var description: String
    var image_featured: String?
    var icon: String?
}

struct CategoryDataUpdate: Content {
    var title: String?
    var description: String? 
    var icon: String?
    var image_featured: String?   
}
