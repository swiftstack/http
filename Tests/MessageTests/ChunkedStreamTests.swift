import Test
import Stream
@testable import HTTP

extension OutputByteStream {
    var string: String {
        return String(decoding: bytes, as: UTF8.self)
    }
}

extension UnsafeStreamReader {
    func readString() throws -> String {
        let buffer = try readUntilEnd()
        return String(decoding: buffer, as: UTF8.self)
    }

    func readUntilEnd() throws -> UnsafeRawBufferPointer {
        return try read(
            while: { _ in true },
            allowingExhaustion: true)
    }
}

class ChunkedStreamTests: TestCase {
    func testOutputStream() {
        do {
            let byteStream = OutputByteStream()
            let chunkedStream = ChunkedStreamWriter(baseStream: byteStream)
            try chunkedStream.write("Hello, World!")
            assertEqual(byteStream.string, "d\r\nHello, World!\r\n")
            try chunkedStream.close()
            assertEqual(byteStream.string, "d\r\nHello, World!\r\n0\r\n\r\n")
        } catch {
            fail(String(describing: error))
        }
    }

    func testInputStream() {
        do {
            let chunked = "d\r\nHello, World!\r\n0\r\n\r\n"
            let byteStream = InputByteStream(ASCII(chunked))
            let chunkedStream = ChunkedStreamReader(baseStream: byteStream)
            let string = try chunkedStream.readString()
            assertEqual(string, "Hello, World!")
        } catch {
            fail(String(describing: error))
        }
    }

    func testOutputStreamMultiline() {
        do {
            let byteStream = OutputByteStream()
            let chunkedStream = ChunkedStreamWriter(baseStream: byteStream)
            try chunkedStream.write("This is the data in the first chunk")
            try chunkedStream.write("and this is the second one")
            try chunkedStream.write("con")
            try chunkedStream.write("sequence")
            try chunkedStream.close()

            let expected = "23\r\nThis is the data in the first chunk\r\n" +
                "1a\r\nand this is the second one\r\n" +
                "3\r\ncon\r\n" +
                "8\r\nsequence\r\n" +
                "0\r\n\r\n"

            assertEqual(byteStream.string, expected)
        } catch {
            fail(String(describing: error))
        }
    }

    func testInputStreamMultiline() {
        do {
            let chunked = "23\r\nThis is the data in the first chunk\r\n" +
                "1A\r\nand this is the second one\r\n" +
                "3\r\ncon\r\n" +
                "8\r\nsequence\r\n" +
                "0\r\n\r\n"
            let byteStream = InputByteStream(ASCII(chunked))
            let chunkedStream = ChunkedStreamReader(baseStream: byteStream)
            let string = try chunkedStream.readString()

            let expected = "This is the data in the first chunkand " +
                "this is the second oneconsequence"

            assertEqual(string, expected)
        } catch {
            fail(String(describing: error))
        }
    }
}
