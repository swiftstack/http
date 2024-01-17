import Test
import Stream

@testable import HTTP

test("Basic") {
    let stream = InputByteStream("Basic sYbe7s3c73Tt0k3n")
    let basic = try await Request.Authorization.decode(from: stream)
    expect(basic == .basic(credentials: "sYbe7s3c73Tt0k3n"))
}

test("Bearer") {
    let stream = InputByteStream("Bearer sYbe7s3c73Tt0k3n")
    let bearer = try await Request.Authorization.decode(from: stream)
    expect(bearer == .bearer(credentials: "sYbe7s3c73Tt0k3n"))
}

test("Token") {
    let stream = InputByteStream("Token sYbe7s3c73Tt0k3n")
    let token = try await Request.Authorization.decode(from: stream)
    expect(token == .token(credentials: "sYbe7s3c73Tt0k3n"))
}

test("Custom") {
    let stream = InputByteStream("Custom sYbe7s3c73Tt0k3n")
    let custom = try await Request.Authorization.decode(from: stream)
    expect(custom == .custom(
        scheme: "Custom", credentials: "sYbe7s3c73Tt0k3n"))
}

test("Lowercased") {
    let stream = InputByteStream("token sYbe7s3c73Tt0k3n")
    let token = try await Request.Authorization.decode(from: stream)
    expect(token == .token(credentials: "sYbe7s3c73Tt0k3n"))
}

await run()
