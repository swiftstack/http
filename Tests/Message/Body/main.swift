import Test

@testable import HTTP

test.case("RequestBytes") {
    let request = Request()
    request.bytes = [1,2,3]
    expect(request.body == .bytes([1,2,3]))
    expect(request.bytes == [1,2,3])
    expect(request.contentLength == 3)
    request.bytes = nil
    expect(request.body == .none)
    expect(request.contentLength == nil)
}

test.case("ResponseBytes") {
    let response = Response()
    response.bytes = [1,2,3]
    expect(response.body == .bytes([1,2,3]))
    expect(response.bytes == [1,2,3])
    expect(response.contentLength == 3)
    response.bytes = nil
    expect(response.body == .none)
    expect(response.contentLength == nil)
}

test.case("RequestString") {
    let request = Request()
    request.string = "hello"
    expect(request.body == .bytes(ASCII("hello")))
    expect(request.bytes == ASCII("hello"))
    expect(request.contentLength == 5)
    request.string = nil
    expect(request.body == .none)
    expect(request.contentLength == nil)
}

test.case("ResponseString") {
    let response = Response()
    response.string = "hello"
    expect(response.body == .bytes(ASCII("hello")))
    expect(response.bytes == ASCII("hello"))
    expect(response.contentLength == 5)
    response.string = nil
    expect(response.body == .none)
    expect(response.contentLength == nil)
}

test.case("RequestJSON") {
    let request = Request()
    request.json = .object(["message" : .string("Hello!")])
    expect(request.body == .bytes(ASCII("{\"message\":\"Hello!\"}")))
    expect(request.contentLength == 20)
    request.json = nil
    expect(request.body == .none)
    expect(request.contentLength == nil)
}

test.case("ResponseJSON") {
    let response = Response()
    response.json = .object(["message" : .string("Hello!")])
    expect(response.body == .bytes(ASCII("{\"message\":\"Hello!\"}")))
    expect(response.contentLength == 20)
    response.json = nil
    expect(response.body == .none)
    expect(response.contentLength == nil)
}

test.run()
