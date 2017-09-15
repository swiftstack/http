import Test
@testable import HTTP

class HeaderNameTests: TestCase {
    func testHeaderName() {
        let name = HeaderName("Content-Length")
        assertEqual(name, HeaderName("Content-Length"))
        assertEqual(name, HeaderName("content-length"))
    }

    func testHeaderNameDescription() {
        let name = HeaderName("Content-Length")
        assertEqual(name.description, "Content-Length")
    }
}
