import Test
import Stream
@testable import HTTP

class HeadersCookieTests: TestCase {
    func testCookie() {
        do {
            let expected = Cookie(name: "username", value: "tony")

            let bytes = ASCII("username=tony")
            let stream = BufferedInputStream(baseStream: InputByteStream(bytes))

            let cookie = try Cookie(from: stream)
            assertEqual(cookie, expected)

            var encoded = [UInt8]()
            cookie?.encode(to: &encoded)
            assertEqual(encoded, bytes)
        } catch {
            fail(String(describing: error))
        }
    }

    func testJoinedCookie() {
        do {
            let expected: [Cookie] = [
                Cookie(name: "username", value: "tony"),
                Cookie(name: "lang", value: "aurebesh")
            ]

            let bytes = ASCII("username=tony; lang=aurebesh")
            let stream = BufferedInputStream(baseStream: InputByteStream(bytes))

            let cookie = try [Cookie](from: stream)
            assertEqual(cookie, expected)
        } catch {
            fail(String(describing: error))
        }
    }
}
