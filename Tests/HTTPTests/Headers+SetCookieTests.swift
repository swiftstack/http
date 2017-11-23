import Test
@testable import HTTP

import struct Foundation.Date

class HeadersSetCookieTests: TestCase {
    func testSetCookie() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"))

        let bytes = ASCII("username=tony")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testExpires() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            expires: Date(timeIntervalSinceReferenceDate: 467105280))

        let bytes = ASCII(
            "username=tony; Expires=Wed, 21 Oct 2015 07:28:00 GMT")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testMaxAge() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            maxAge: 42)

        let bytes = ASCII(
            "username=tony; Max-Age=42")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testHttpOnly() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            httpOnly: true)

        let bytes = ASCII("username=tony; HttpOnly")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testSecure() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            secure: true)

        let bytes = ASCII("username=tony; Secure")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testDomain() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            domain: "somedomain.com")

        let bytes = ASCII("username=tony; Domain=somedomain.com")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }

    func testPath() {
        let expected = Response.SetCookie(
            Cookie(name: "username", value: "tony"),
            path: "/")

        let bytes = ASCII("username=tony; Path=/")
        let buffer = UnsafeRawBufferPointer(start: bytes, count: bytes.count)

        let setCookie = try? Response.SetCookie(from: buffer[...])
        assertEqual(setCookie, expected)

        var encoded = [UInt8]()
        setCookie?.encode(to: &encoded)
        assertEqual(encoded, bytes)
    }
}
