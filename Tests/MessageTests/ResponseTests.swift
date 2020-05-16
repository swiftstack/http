import Test
@testable import HTTP

class ResponseTests: TestCase {
    func testResponse() {
        let response = Response(status: .ok)
        expect(response.status == .ok)
        expect(response.contentType == nil)
    }

    func testDefaultStatus() {
        let response = Response()
        expect(response.status == .ok)
        expect(response.contentType == nil)
    }

    func testContentType() {
        let response = Response(status: .ok, bytes: [], contentType: .json)
        expect(response.contentType == .json)
    }

    func testBytes() {
        _ = Response(status: .ok, bytes: [], contentType: .stream)
        _ = Response(bytes: [], contentType: .stream)
        _ = Response(bytes: [])
    }

    func testString() {
        _ = Response(status: .ok, string: "", contentType: .text)
        _ = Response(string: "", contentType: .text)
        _ = Response(string: "")
    }

    func testXML() {
        _ = Response(status: .ok, xml: "")
        _ = Response(xml: "")
    }

    func testHTML() {
        _ = Response(status: .ok, html: "")
        _ = Response(html: "")
    }

    func testJavaScript() {
        _ = Response(status: .ok, javascript: "")
        _ = Response(javascript: "")
    }
}
