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

    init(id: UUID? = nil, userName: String) {
        self.id = id
        self.userName = userName
        self.password = password
    }
}

extension UserModel: ModelAuthenticatable {
    static var usernameKey: KeyPath<UserModel, Field<String>> = \UserModel.$userName
    static var passwordHashKey: KeyPath<UserModel, Field<String>> = \UserModel.$password

    func verify(password: String) throws -> Bool {
        try Bcrypt.verify(password, created: self.password)
    }
}
