import Vapor

struct CategoryController: RouteCollection {
    let categoryServiceUrl: String
    
    init(_categoryServiceUrl: String) {
        categoryServiceUrl = "\(_categoryServiceUrl)"
    }
    
    func boot(routes: RoutesBuilder) throws {
        let categoryGroup = routes.grouped("api", "v1", "category")
     
        categoryGroup.get(use: getAllCategory)
        categoryGroup.get("count", use: getNumbersCategory)
        categoryGroup.get(":category_id", use: getOneCategory)
        categoryGroup.post(use: createOneCategory)
        categoryGroup.put(":category_id", use: updateOneCategory)
        categoryGroup.delete(":category_id", use: deleteOneCategory)
    }
    
    func getAllCategory(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(categoryServiceUrl)/category"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getNumbersCategory(_ req: Request) -> EventLoopFuture<ClientResponse> {  
        return req.client.get("\(categoryServiceUrl)/category/count"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
  
    
    func getOneCategory(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("category_id", as: UUID.self)
        return req.client.get("\(categoryServiceUrl)/category/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func createOneCategory(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(categoryServiceUrl)/category"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func updateOneCategory(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("category_id", as: UUID.self)
        return req.client.put("\(categoryServiceUrl)/category/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
            try getRequest.content.encode(req.content.decode(CategoryDataUpdate.self))
        }
    }

    func deleteOneCategory(_ req: Request) throws -> EventLoopFuture<ClientResponse> { 
        let id = try req.parameters.require("category_id", as: UUID.self)
        return req.client.delete("\(categoryServiceUrl)/category/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }
}
