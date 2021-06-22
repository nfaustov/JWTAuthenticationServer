//
//  Me.swift
//  
//
//  Created by Nikolai Faustov on 23.06.2021.
//

import Vapor

struct Me: Content {
    var id: UUID?
    var username: String
}
