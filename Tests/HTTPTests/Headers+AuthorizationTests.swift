import Test
@testable import HTTP

class HeadersAuthorizationTests: TestCase {
    func testBasic() {
        let bytes = ASCII("Basic sYbe7s3c73Tt0k3n")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        let basic = try? Request.Authorization(from: buffer[...])
        assertEqual(basic, .basic(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testBearer() {
        let bytes = ASCII("Bearer sYbe7s3c73Tt0k3n")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        let bearer = try? Request.Authorization(from: buffer[...])
        assertEqual(bearer, .bearer(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testToken() {
        let bytes = ASCII("Token sYbe7s3c73Tt0k3n")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        let token = try? Request.Authorization(from: buffer[...])
        assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testCustom() {
        let bytes = ASCII("Custom sYbe7s3c73Tt0k3n")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        let custom = try? Request.Authorization(from: buffer[...])
        assertEqual(custom, .custom(
            scheme: "Custom", credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testLowercased() {
        let bytes = ASCII("token sYbe7s3c73Tt0k3n")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)
        let token = try? Request.Authorization(from: buffer[...])
        assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
    }
}
