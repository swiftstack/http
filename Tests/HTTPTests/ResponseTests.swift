@testable import HTTP

class ResponseTests: TestCase {
    func testResponse() {
        let response = Response()
        assertNotNil(response)
    }
}
