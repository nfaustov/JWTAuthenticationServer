//
//  File.swift
//  
//
//  Created by Nikolai Faustov on 16.06.2021.
//

import Fluent
import Vapor
import PostgresKit

struct CreateUser: Migration {
    func prepare(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(UserModel.schema)
            .id()
            .field("user_name", .custom("character varying(60)"), .required)
            .field("password", .custom("character varying(60)"), .required)
            .field("created_by", .custom("character varying(60)"), .required)
            .field("created_at", .datetime, .required)
            .field("last_modified_by", .custom("character varying(60)"), .required)
            .field("last_modified_at", .datetime, .required)
            .unique(on: "user_name")
            .create()
    }

    func revert(on database: Database) -> EventLoopFuture<Void> {
        return database.schema(User.schema).delete()
    }
}
