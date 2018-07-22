import Test
@testable import HTTP

class BodyTests: TestCase {
    func testRequestBytes() {
        let request = Request()
        request.bytes = [1,2,3]
        assertEqual(request.body, .bytes([1,2,3]))
        assertEqual(request.bytes, [1,2,3])
        assertEqual(request.contentLength, 3)
        request.bytes = nil
        assertEqual(request.body, .none)
        assertEqual(request.contentLength, nil)
    }

    func testResponseBytes() {
        let response = Response()
        response.bytes = [1,2,3]
        assertEqual(response.body, .bytes([1,2,3]))
        assertEqual(response.bytes, [1,2,3])
        assertEqual(response.contentLength, 3)
        response.bytes = nil
        assertEqual(response.body, .none)
        assertEqual(response.contentLength, nil)
    }

    func testRequestString() {
        let request = Request()
        request.string = "hello"
        assertEqual(request.body, .bytes(ASCII("hello")))
        assertEqual(request.bytes, ASCII("hello"))
        assertEqual(request.contentLength, 5)
        request.string = nil
        assertEqual(request.body, .none)
        assertEqual(request.contentLength, nil)
    }

    func testResponseString() {
        let response = Response()
        response.string = "hello"
        assertEqual(response.body, .bytes(ASCII("hello")))
        assertEqual(response.bytes, ASCII("hello"))
        assertEqual(response.contentLength, 5)
        response.string = nil
        assertEqual(response.body, .none)
        assertEqual(response.contentLength, nil)
    }

    func testRequestJSON() {
        let request = Request()
        request.json = .object(["message" : .string("Hello!")])
        assertEqual(request.body, .bytes(ASCII("{\"message\":\"Hello!\"}")))
        assertEqual(request.contentLength, 20)
        request.json = nil
        assertEqual(request.body, .none)
        assertEqual(request.contentLength, nil)
    }

    func testResponseJSON() {
        let response = Response()
        response.json = .object(["message" : .string("Hello!")])
        assertEqual(response.body, .bytes(ASCII("{\"message\":\"Hello!\"}")))
        assertEqual(response.contentLength, 20)
        response.json = nil
        assertEqual(response.body, .none)
        assertEqual(response.contentLength, nil)
    }
}
