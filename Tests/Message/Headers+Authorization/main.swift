import Test
import Stream

@testable import HTTP

test.case("Basic") {
    let stream = InputByteStream("Basic sYbe7s3c73Tt0k3n")
    let basic = try await Request.Authorization.decode(from: stream)
    expect(basic == .basic(credentials: "sYbe7s3c73Tt0k3n"))
}

test.case("Bearer") {
    let stream = InputByteStream("Bearer sYbe7s3c73Tt0k3n")
    let bearer = try await Request.Authorization.decode(from: stream)
    expect(bearer == .bearer(credentials: "sYbe7s3c73Tt0k3n"))
}

test.case("Token") {
    let stream = InputByteStream("Token sYbe7s3c73Tt0k3n")
    let token = try await Request.Authorization.decode(from: stream)
    expect(token == .token(credentials: "sYbe7s3c73Tt0k3n"))
}

test.case("Custom") {
    let stream = InputByteStream("Custom sYbe7s3c73Tt0k3n")
    let custom = try await Request.Authorization.decode(from: stream)
    expect(custom == .custom(
        scheme: "Custom", credentials: "sYbe7s3c73Tt0k3n"))
}

test.case("Lowercased") {
    let stream = InputByteStream("token sYbe7s3c73Tt0k3n")
    let token = try await Request.Authorization.decode(from: stream)
    expect(token == .token(credentials: "sYbe7s3c73Tt0k3n"))
}

test.run()
