import Test
@testable import HTTP

class HeaderNameTests: TestCase {
    func testHeaderName() {
        let name = HeaderName("Content-Length")
        expect(name == HeaderName("Content-Length"))
        expect(name == HeaderName("content-length"))
    }

    func testHeaderNameDescription() {
        let name = HeaderName("Content-Length")
        expect(name.description == "Content-Length")
    }
}
