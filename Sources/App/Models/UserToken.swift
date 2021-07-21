//
//  UserToken.swift
//  
//
//  Created by Nikolai Faustov on 24.06.2021.
//

import Fluent
import Vapor

final class UserToken: Model, Content {
    static let schema = "user_tokens"

    @ID(key: .id)
    var id: UUID?
    @Field(key: "value")
    var value: String
    @Parent(key: "user_id")
    var user: UserModel

    init() { }

    init(id: UUID? = nil, value: String, userID: UserModel.IDValue) {
        self.id = id
        self.value = value
        self.$user.id = userID
    }
}

extension UserToken: ModelTokenAuthenticatable {
    static let valueKey: KeyPath<UserToken, Field<String>> = \UserToken.$value
    static var userKey: KeyPath<UserToken, Parent<UserModel>> = \UserToken.$user

    var isValid: Bool { true }
}
