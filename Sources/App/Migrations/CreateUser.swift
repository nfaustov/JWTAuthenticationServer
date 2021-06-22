//
//  CreateUser.swift
//  
//
//  Created by Nikolai Faustov on 16.06.2021.
//

import Fluent
import Vapor

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserModel.schema)
            .id()
            .field("user_name", .string, .required)
            .field("password", .string, .required)
            .field("email", .string, .required)
            .field("created_at", .datetime, .required)
            .field("last_modified_at", .datetime, .required)
            .unique(on: "user_name")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserModel.schema).delete()
    }
}
