import Test
import Stream

@testable import HTTP

test("OutputStream") {
    let byteStream = OutputByteStream()
    let chunkedStream = ChunkedStreamWriter(baseStream: byteStream)
    try await chunkedStream.write("Hello, World!")
    expect(byteStream.stringValue == "d\r\nHello, World!\r\n")
    try await chunkedStream.close()
    expect(byteStream.stringValue == "d\r\nHello, World!\r\n0\r\n\r\n")
}

test("InputStream") {
    let chunked = "d\r\nHello, World!\r\n0\r\n\r\n"
    let byteStream = InputByteStream(ASCII(chunked))
    let chunkedStream = ChunkedStreamReader(baseStream: byteStream)
    let string = try await chunkedStream.readUntilEnd(as: String.self)
    expect(string == "Hello, World!")
}

test("OutputStreamMultiline") {
    let byteStream = OutputByteStream()
    let chunkedStream = ChunkedStreamWriter(baseStream: byteStream)
    try await chunkedStream.write("This is the data in the first chunk")
    try await chunkedStream.write("and this is the second one")
    try await chunkedStream.write("con")
    try await chunkedStream.write("sequence")
    try await chunkedStream.close()

    let expected = "23\r\nThis is the data in the first chunk\r\n" +
        "1a\r\nand this is the second one\r\n" +
        "3\r\ncon\r\n" +
        "8\r\nsequence\r\n" +
        "0\r\n\r\n"

    expect(byteStream.stringValue == expected)
}

test("InputStreamMultiline") {
    let chunked = "23\r\nThis is the data in the first chunk\r\n" +
        "1A\r\nand this is the second one\r\n" +
        "3\r\ncon\r\n" +
        "8\r\nsequence\r\n" +
        "0\r\n\r\n"
    let byteStream = InputByteStream(ASCII(chunked))
    let chunkedStream = ChunkedStreamReader(baseStream: byteStream)
    let string = try await chunkedStream.readUntilEnd(as: String.self)

    let expected = "This is the data in the first chunkand " +
        "this is the second oneconsequence"

    expect(string == expected)
}

// TODO: make it work with 256 byte buffer
test("SmallerBufferSize") {
    let chars300 =
        "Simple 30 byte string number 0" +
        "Simple 30 byte string number 1" +
        "Simple 30 byte string number 2" +
        "Simple 30 byte string number 3" +
        "Simple 30 byte string number 4" +
        "Simple 30 byte string number 5" +
        "Simple 30 byte string number 6" +
        "Simple 30 byte string number 7" +
        "Simple 30 byte string number 8" +
        "Simple 30 byte string number 9"

    // default buffer size is 256 bytes
    let chunked = "12C\r\n\(chars300)\r\n0\r\n\r\n"
    let byteStream = InputByteStream(ASCII(chunked))
    let chunkedStream = ChunkedStreamReader(baseStream: byteStream)
    let string = try await chunkedStream.readUntilEnd(as: String.self)

    expect(string == chars300)
}

await run()
