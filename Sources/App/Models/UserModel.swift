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
    @Field(key: "user_name")
    var userName: String
    @Field(key: "email")
    var email: String
    @Field(key: "password")
    var password: String
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?

    init() {}

    init(id: UUID? = nil, userName: String, email: String, password: String) {
        self.id = id
        self.userName = userName
        self.email = email
        self.password = password
    }
}

extension UserModel: ModelAuthenticatable {
    static var usernameKey: KeyPath<UserModel, Field<String>> = \UserModel.$userName
    static var passwordHashKey: KeyPath<UserModel, Field<String>> = \UserModel.$password

    func verify(password: String) throws -> Bool {
        let hash = try Bcrypt.hash(self.password)
        return try Bcrypt.verify(password, created: hash)
    }
}

extension UserModel {
    func generateToken(_ app: Application) throws -> String {
        var expDate = Date()
        expDate.addTimeInterval(86_400)
        let exp = ExpirationClaim(value: expDate)

        return try app.jwt.signers.get(kid: .private)!.sign(MyJWTPayload(id: self.id, username: self.userName, exp: exp))
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
