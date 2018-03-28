import Test
import Stream
@testable import HTTP

class HeadersAuthorizationTests: TestCase {
    func testBasic() {
        scope {
            let stream = InputByteStream("Basic sYbe7s3c73Tt0k3n")
            let basic = try Request.Authorization(from: stream)
            assertEqual(basic, .basic(credentials: "sYbe7s3c73Tt0k3n"))
        }
    }

    func testBearer() {
        scope {
            let stream = InputByteStream("Bearer sYbe7s3c73Tt0k3n")
            let bearer = try Request.Authorization(from: stream)
            assertEqual(bearer, .bearer(credentials: "sYbe7s3c73Tt0k3n"))
        }
    }

    func testToken() {
        scope {
            let stream = InputByteStream("Token sYbe7s3c73Tt0k3n")
            let token = try Request.Authorization(from: stream)
            assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
        }
    }

    func testCustom() {
        scope {
            let stream = InputByteStream("Custom sYbe7s3c73Tt0k3n")
            let custom = try Request.Authorization(from: stream)
            assertEqual(custom, .custom(
                scheme: "Custom", credentials: "sYbe7s3c73Tt0k3n"))
        }
    }

    func testLowercased() {
        scope {
            let stream = InputByteStream("token sYbe7s3c73Tt0k3n")
            let token = try Request.Authorization(from: stream)
            assertEqual(token, .token(credentials: "sYbe7s3c73Tt0k3n"))
        }
    }
}
