import Test

@testable import HTTP

test("Response") {
    let response = Response(status: .ok)
    expect(response.status == .ok)
    expect(response.contentType == nil)
}

test("DefaultStatus") {
    let response = Response()
    expect(response.status == .ok)
    expect(response.contentType == nil)
}

test("ContentType") {
    let response = Response(status: .ok, bytes: [], contentType: .json)
    expect(response.contentType == .json)
}

test("Bytes") {
    _ = Response(status: .ok, bytes: [], contentType: .stream)
    _ = Response(bytes: [], contentType: .stream)
    _ = Response(bytes: [])
}

test("String") {
    _ = Response(status: .ok, string: "", contentType: .text)
    _ = Response(string: "", contentType: .text)
    _ = Response(string: "")
}

test("XML") {
    _ = Response(status: .ok, xml: "")
    _ = Response(xml: "")
}

test("HTML") {
    _ = Response(status: .ok, html: "")
    _ = Response(html: "")
}

test("JavaScript") {
    _ = Response(status: .ok, javascript: "")
    _ = Response(javascript: "")
}

await run()
