//
//  UserModel.swift
//  
//
//  Created by Nikolai Faustov on 16.06.2021.
//

import Vapor
import Fluent
import JWT

final class UserModel: Model, Content {
    static let schema = "users"

    @ID(key: .id)
    var id: UUID?
    @Field(key: "name")
    var name: String
    @Field(key: "email")
    var email: String
    @Field(key: "password_hash")
    var passwordHash: String
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?

    init() {}

    init(id: UUID? = nil, name: String, email: String, passwordHash: String) {
        self.id = id
        self.name = name
        self.email = email
        self.passwordHash = passwordHash
    }
}

extension UserModel {
    struct Create: Content {
        var name: String
        var email: String
        var password: String
        var confirmPassword: String
    }
}

extension UserModel.Create: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("name", as: String.self, is: !.empty)
        validations.add("email", as: String.self, is: .email)
        validations.add("password", as: String.self, is: .count(8...))
    }
}

extension UserModel: ModelAuthenticatable {
    static var usernameKey: KeyPath<UserModel, Field<String>> = \UserModel.$name
    static var passwordHashKey: KeyPath<UserModel, Field<String>> = \UserModel.$passwordHash

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: passwordHash)
    }
}

extension UserModel {
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        expDate.addTimeInterval(86_400)
        let exp = ExpirationClaim(value: expDate)

        return try app.jwt.signers.get(kid: .private)!.sign(MyJWTPayload(id: id, name: name, exp: exp))
    }
}

struct JWTBearerAuthenticator: JWTAuthenticator {
    typealias Payload = MyJWTPayload

    func authenticate(jwt: Payload, for request: Request) -> EventLoopFuture<Void> {
        do {
            try jwt.verify(using: request.application.jwt.signers.get()!)

            return UserModel
                .find(jwt.id, on: request.db)
                .unwrap(or: Abort(.notFound))
                .map { user in
                    request.auth.login(user)
                }
        } catch {
            return request.eventLoop.makeSucceededFuture(())
        }
    }
}
