import Test
import Stream
@testable import HTTP

class HeadersAuthorizationTests: TestCase {
    func testBasic() {
        let bytes = ASCII("Basic sYbe7s3c73Tt0k3n")
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        let basic = try? Request.Authorization(from: stream)
        assertEqual(basic, .basic(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testBearer() {
        let bytes = ASCII("Bearer sYbe7s3c73Tt0k3n")
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        let bearer = try? Request.Authorization(from: stream)
        assertEqual(bearer, .bearer(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testToken() {
        let bytes = ASCII("Token sYbe7s3c73Tt0k3n")
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        let token = try? Request.Authorization(from: stream)
        assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testCustom() {
        let bytes = ASCII("Custom sYbe7s3c73Tt0k3n")
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        let custom = try? Request.Authorization(from: stream)
        assertEqual(custom, .custom(
            scheme: "Custom", credentials: "sYbe7s3c73Tt0k3n"))
    }

    func testLowercased() {
        let bytes = ASCII("token sYbe7s3c73Tt0k3n")
        let stream = BufferedInputStream(baseStream: InputByteStream(bytes))
        let token = try? Request.Authorization(from: stream)
        assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
    }
}
