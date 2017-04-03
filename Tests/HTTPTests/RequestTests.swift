@testable import HTTP

class RequestTests: TestCase {
    func testRequest() {
        let request = Request(url: URL("/test"))
        assertNotNil(request)
        assert(request.url.path == "/test")
    }
}
