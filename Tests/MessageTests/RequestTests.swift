import Test
@testable import HTTP

class RequestTests: TestCase {
    func testRequest() {
        let request = Request(url: "/", method: .get)
        expect(request.method == .get)
        expect(request.url.path == "/")
    }

    func testDefaultRequest() {
        let request = Request()
        expect(request.method == .get)
        expect(request.url.path == "/")
    }

    func testDefaultMethod() {
        let request = Request(url: "/")
        expect(request.method == .get)
        expect(request.url.path == "/")
    }

    func testDefaultURL() {
        let request = Request(method: .get)
        expect(request.method == .get)
        expect(request.url.path == "/")
    }

    func testFromString() {
        let request = Request(url: "/test?query=true")
        expect(request.url.path == "/test")
        expect(request.url.query == ["query" : "true"])
    }
}
