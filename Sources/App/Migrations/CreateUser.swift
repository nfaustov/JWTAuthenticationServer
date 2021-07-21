//
//  CreateUser.swift
//  
//
//  Created by Nikolai Faustov on 16.06.2021.
//

import Fluent

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema)
            .id()
            .field("name", .string, .required)
            .field("email", .string, .required)
            .field("password_hash", .string, .required)
            .field("created_at", .datetime, .required)
            .field("last_modified_at", .datetime, .required)
            .unique(on: "email")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        database.schema(UserModel.schema).delete()
    }
}
