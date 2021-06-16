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
    @Field(key: "password")
    var password: String
    @Field(key: "created_by")
    var createdBy: String?
    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?
    @Field(key: "last_modified_by")
    var lastModifiedBy: String?
    @Timestamp(key: "last_modified_at", on: .update)
    var lastModifiedAt: Date?

    init() {}

    init(id: UUID? = nil, userName: String) {
        self.id = id
        self.userName = userName
        self.password = password
    }
}
