@testable import HTTP

class EncodeRequestTests: TestCase {
    func testRequest() {
        let expected = "GET /test HTTP/1.1\r\n\r\n"
        let request = Request(method: .get, url: "/test")
        let result = String(bytes: request.bytes)
        assertEqual(result, expected)
    }

    func testUrlQuery() {
        let expected = "GET /test? HTTP/1.1\r\n\r\n"
        let request = Request(
            method: .get,
            url: URL(path: "/test", query: "?"))
        let result = String(bytes: request.bytes)
        assertEqual(result, expected)
    }
}
