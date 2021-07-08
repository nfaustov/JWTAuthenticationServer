//
//  UserController.swift
//  
//
//  Created by Nikolai Faustov on 23.06.2021.
//

import Fluent
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let users = routes.grouped("users")

        users.group("login") { user in
            user.post(use: login)
        }

        users.group("create") { user in
                user.post(use: create)
            }

        users
            .grouped(JWTBearerAuthenticator())
            .group("me") { user in
                user.get(use: payload)
            }
    }

    func payload(req: Request) throws -> EventLoopFuture<Me> {
        let user = try req.auth.require(UserModel.self)
        let username = user.name

        return UserModel.query(on: req.db)
            .filter(\.$name == username)
            .first()
            .unwrap(or: Abort(.notFound))
            .map { user in
                return Me(id: UUID(), username: user.name)
            }
    }

    func login(req: Request) throws -> EventLoopFuture<[String: String]> {
        let userToLogin = try req.content.decode(UserLogin.self)
        print("User to login \(userToLogin.email)")

        return UserModel.query(on: req.db)
            .filter(\.$email == userToLogin.email)
            .first()
            .unwrap(or: Abort(.notFound))
            .flatMapThrowing { databaseUser in
                let verified = try databaseUser.verify(password: userToLogin.password)
                print("Attempt verify \(verified)")

                if verified == false {
                    throw Abort(.unauthorized)
                }

                req.auth.login(databaseUser)
                let user = try req.auth.require(UserModel.self)
                let token = try user.generateToken(req.application)

                return ["token": token]
            }
    }

    func get(req: Request) throws -> EventLoopFuture<UserModel> {
        return UserModel.query(on: req.db)
            .filter(\.$name == req.parameters.get("name") ?? "N/A")
            .first()
            .unwrap(or: Abort(.notFound))
    }

    func create(req: Request) throws -> EventLoopFuture<UserModel> {
        try UserModel.Create.validate(content: req)
        let create = try req.content.decode(UserModel.Create.self)

        guard create.password == create.confirmPassword else {
            throw Abort(.badRequest, reason: "Password did not match")
        }

        let user = try UserModel(
            name: create.name,
            email: create.email,
            passwordHash: Bcrypt.hash(create.password)
        )

        return user.save(on: req.db).map { user }
    }
}
