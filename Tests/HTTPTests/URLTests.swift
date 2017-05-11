@testable import HTTP

class URLTests: TestCase {
    func testPath() {
        let url = try! URL("/test")
        assertEqual(url.path, "/test")
    }

    func testQuery() {
        let url = try! URL("/test?query=true")
        assertEqual(url.query, ["query" : "true"])
    }

    func testHost() {
        let url = try! URL("http://domain.com/test")
        assertEqual(url.host, "domain.com")
    }

    func testPort() {
        let url = try! URL("http://domain.com:8080/test")
        assertEqual(url.port, 8080)
    }

    func testScheme() {
        assertEqual(try! URL("http://domain.com/").scheme, .http)
        assertEqual(try! URL("https://domain.com/").scheme, .https)
    }
}
