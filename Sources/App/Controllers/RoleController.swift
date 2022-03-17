import Vapor

struct RoleController: RouteCollection {
    let roleServiceUrl: String

    init(_roleServiceUrl: String) {
        roleServiceUrl = "\(_roleServiceUrl)"
    }

    func boot(routes: RoutesBuilder) throws {
        let roleRouteGroup = routes.grouped("api", "v1", "role")

        roleRouteGroup.get(use: getAllHandler)
        roleRouteGroup.put(":id", use: updateOneHandler)
    }

    func getAllHandler(_ req: Request) -> EventLoopFuture<ClientResponse> {
        return req.client.get("\(roleServiceUrl)/role"){
            getRequest in 
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            getRequest.headers.add(name: .authorization, value: authHeader)
        }
    }

    func updateOneHandler(_ req: Request) throws -> EventLoopFuture<ClientResponse> {
        let id = try req.parameters.require("id", as: UUID.self)
        return req.client.put("\(roleServiceUrl)/role/\(id)"){
            put in
            guard let authHeader = req.headers[.authorization].first else {
                throw Abort(.unauthorized)
            }
            put.headers.add(name: .authorization, value: authHeader)
            try put.content.encode(req.content.decode(UpdateRole.self))
        }
    }
}
