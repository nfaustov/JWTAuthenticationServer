//
//  MyJWTPayload.swift
//  
//
//  Created by Nikolai Faustov on 23.06.2021.
//

import Vapor
import JWT

struct MyJWTPayload: JWTPayload {
    var id: UUID?
    var name: String
    var exp: ExpirationClaim

    func verify(using signer: JWTSigner) throws {
        try exp.verifyNotExpired()
    }
}
