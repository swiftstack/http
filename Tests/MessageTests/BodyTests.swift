import Test
@testable import HTTP

class BodyTests: TestCase {
    func testRequestBytes() {
        let request = Request()
        request.bytes = [1,2,3]
        expect(request.body == .bytes([1,2,3]))
        expect(request.bytes == [1,2,3])
        expect(request.contentLength == 3)
        request.bytes = nil
        expect(request.body == .none)
        expect(request.contentLength == nil)
    }

    func testResponseBytes() {
        let response = Response()
        response.bytes = [1,2,3]
        expect(response.body == .bytes([1,2,3]))
        expect(response.bytes == [1,2,3])
        expect(response.contentLength == 3)
        response.bytes = nil
        expect(response.body == .none)
        expect(response.contentLength == nil)
    }

    func testRequestString() {
        let request = Request()
        request.string = "hello"
        expect(request.body == .bytes(ASCII("hello")))
        expect(request.bytes == ASCII("hello"))
        expect(request.contentLength == 5)
        request.string = nil
        expect(request.body == .none)
        expect(request.contentLength == nil)
    }

    func testResponseString() {
        let response = Response()
        response.string = "hello"
        expect(response.body == .bytes(ASCII("hello")))
        expect(response.bytes == ASCII("hello"))
        expect(response.contentLength == 5)
        response.string = nil
        expect(response.body == .none)
        expect(response.contentLength == nil)
    }

    func testRequestJSON() {
        let request = Request()
        request.json = .object(["message" : .string("Hello!")])
        expect(request.body == .bytes(ASCII("{\"message\":\"Hello!\"}")))
        expect(request.contentLength == 20)
        request.json = nil
        expect(request.body == .none)
        expect(request.contentLength == nil)
    }

    func testResponseJSON() {
        let response = Response()
        response.json = .object(["message" : .string("Hello!")])
        expect(response.body == .bytes(ASCII("{\"message\":\"Hello!\"}")))
        expect(response.contentLength == 20)
        response.json = nil
        expect(response.body == .none)
        expect(response.contentLength == nil)
    }
}
