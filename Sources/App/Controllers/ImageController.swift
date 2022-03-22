import Vapor

struct ImageController: RouteCollection {

    let imageServiceUrl: String

    init(_imageServiceUrl: String) {
        imageServiceUrl = "\(_imageServiceUrl)"
    }

    func boot(routes: RoutesBuilder) throws {
        let imageRouteGroup = routes.grouped("api", "v1", "image")

        imageRouteGroup.on(.POST, body: .collect(maxSize: "10mb"), use: createHandler)
        imageRouteGroup.on(.PUT, ":user_id", body: .collect(maxSize: "10mb"), use: updateOneHandlerByUserId)
        imageRouteGroup.get(use: getAllHandler)
        imageRouteGroup.get(":user_id" ,use: getOneHandlerByUserId)
        imageRouteGroup.delete(use: deleteOneHandler)
    }

    func createHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.post("\(imageServiceUrl)/image"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
            try getRequest.content.encode(req.content.decode(ImageCreate.self))
        }
    }

    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(imageServiceUrl)/image"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func getOneHandlerByUserId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("user_id", as: UUID.self)
        let query = try req.query.decode(ImageQuery.self)
        return req.client.get("\(imageServiceUrl)/image/\(id)?type=\(query.type)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func updateOneHandlerByUserId(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("user_id", as: UUID.self)
        return req.client.put("\(imageServiceUrl)/image/\(id)"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
            try getRequest.content.encode(req.content.decode(ImageCreate.self))
        }
    }

    func deleteOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        return req.client.delete("\(imageServiceUrl)/image/"){
            getRequest in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
            try getRequest.content.encode(req.content.decode(ImageDelete.self))
        }
    }
}