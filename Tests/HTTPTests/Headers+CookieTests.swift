import Test
@testable import HTTP

class HeadersCookieTests: TestCase {
    func testCookie() {
        let expected = Cookie(name: "username", value: "tony")

        let bytes = ASCII("username=tony")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let cookie = try? Cookie(from: buffer[...])
        assertEqual(cookie, expected)

        var encoded = [UInt8]()
        cookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testJoinedCookie() {
        let expected: [Cookie] = [
            Cookie(name: "username", value: "tony"),
            Cookie(name: "lang", value: "aurebesh")
        ]

        let bytes = ASCII("username=tony; lang=aurebesh")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let cookie = try? [Cookie](from: buffer[...])
        assertEqual(cookie ?? [], expected)
    }

    func testJoinedCookieNoSpace() {
        let bytes = ASCII("username=tony;lang=aurebesh")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        assertThrowsError(try [Cookie](from: buffer[...])) { error in
            assertEqual(error as? HTTPError, .invalidCookie)
        }
    }

    func testTrailingSemicolon() {
        let bytes = ASCII("username=tony;")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        assertThrowsError(try [Cookie](from: buffer[...])) { error in
            assertEqual(error as? HTTPError, .invalidCookie)
        }
    }
}
