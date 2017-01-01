import XCTest
@testable import HTTPMessage

class BugTests: XCTestCase {
    let simpleGet = ASCII("GET /test HTTP/1.1\r\n\r\n")
    func testStringTerminationBug() {
        if !_isDebugAssertConfiguration() {
            for _ in 0..<1_000_000 {
                if let request = try? HTTPRequest(fromBytes: simpleGet) {
                    if !request.urlBytes.elementsEqual(ASCII("/test")) {
                        XCTFail("(\"\(request.url)\") in not equal to (\"Optional(\"/test\")\")")
                        break
                    }
                }
            }
        }
    }
}
