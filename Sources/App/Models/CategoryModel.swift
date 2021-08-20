import Vapor


struct CreateCategoryData: Content {
    var title: String
    var description: String    
}
