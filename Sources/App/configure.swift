import Vapor
import Fluent
import FluentPostgresDriver
import JWT

extension String {
    var bytes: [UInt8] { .init(self.utf8)}
}

extension JWKIdentifier {
    static let `public` = JWKIdentifier(string: "public")
    static let `private` = JWKIdentifier(string: "private")
}

public func configure(_ app: Application) throws {
    switch app.environment {
    case.production:
        break
    default:
        app.databases.use(.postgres(
            hostname: "localhost",
            username: "nfaustov",
            password: "",
            database: "usersdb"
        ), as: .psql)
    }

    app.migrations.add(CreateUser())

    let privateKey = try String(contentsOfFile: app.directory.workingDirectory + "jwtRS256.pem")
    let privateSigner = try JWTSigner.rs256(key: .private(pem: privateKey.bytes))

    let publicKey = try String(contentsOfFile: app.directory.workingDirectory + "jwtRS256.key.pub")
    let publicSigner = try JWTSigner.rs256(key: .public(pem: publicKey.bytes))

    app.jwt.signers.use(privateSigner, kid: .private)
    app.jwt.signers.use(publicSigner, kid: .public, isDefault: true)

    try routes(app)
}
