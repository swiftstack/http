import Test
@testable import HTTP

class ResponseTests: TestCase {
    func testResponse() {
        let response = Response(status: .ok)
        assertEqual(response.status, .ok)
        assertNil(response.contentType)
    }

    func testDefaultStatus() {
        let response = Response()
        assertEqual(response.status, .ok)
        assertNil(response.contentType)
    }

    func testVersion() {
        let response = Response(version: .oneOne)
        assertEqual(response.version, .oneOne)
    }

    func testBytes() {
        let response = Response(bytes: [], contentType: .stream)
        assertEqual(response.contentType, .stream)
    }
}
