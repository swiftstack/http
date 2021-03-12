import Stream

class ChunkedStreamWriter: StreamWriter {
    let baseStream: StreamWriter

    init(baseStream: StreamWriter) {
        self.baseStream = baseStream
    }

    func write(_ bytes: UnsafeRawPointer, byteCount: Int) async throws {
        try await baseStream.write(String(byteCount, radix: 16))
        try await baseStream.write(Constants.lineEnd)
        try await baseStream.write(bytes, byteCount: byteCount)
        try await baseStream.write(Constants.lineEnd)
    }

    func write(_ byte: UInt8) async throws {
        var copy = byte
        try await write(&copy, byteCount: 1)
    }

    func write<T: BinaryInteger>(_ value: T) async throws {
        var copy = value
        try await write(&copy, byteCount: MemoryLayout<T>.size)
    }

    func flush() async throws {
        try await baseStream.flush()
    }

    func close() async throws {
        try await baseStream.write("0\r\n\r\n")
    }
}

class ChunkedInputStream: InputStream {
    let baseStream: StreamReader

    init(baseStream: StreamReader) {
        self.baseStream = baseStream
    }

    var isEmpty = false
    var remainingChunkBytes = 0

    func read(
        to pointer: UnsafeMutableRawPointer,
        byteCount requested: Int
    ) async throws -> Int {
        guard !isEmpty else {
            return 0
        }

        if remainingChunkBytes == 0 {
            remainingChunkBytes = try await baseStream.read(until: .cr)
            { bytes -> Int in
                guard let size = Int(from: bytes, radix: 16) else {
                    throw Error.invalidRequest
                }
                return size
            }
            try await readLineEnd()
        }

        guard remainingChunkBytes > 0 else {
            try await readLineEnd()
            isEmpty = true
            return 0
        }

        let count = min(remainingChunkBytes, requested)
        try await baseStream.read(count: count) { bytes in
            pointer.copyMemory(from: bytes.baseAddress!, byteCount: bytes.count)
        }
        remainingChunkBytes -= count
        if remainingChunkBytes == 0 {
            try await readLineEnd()
        }
        return count
    }

    @inline(__always)
    func readLineEnd() async throws {
        guard try await baseStream.consume(.cr),
              try await baseStream.consume(.lf) else
        {
            throw Error.invalidRequest
        }
    }
}

class ChunkedStreamReader: StreamReader {
    let baseStream: BufferedInputStream<ChunkedInputStream>

    init(baseStream: StreamReader, capacity: Int = 16384) {
        self.baseStream = BufferedInputStream(
            baseStream: ChunkedInputStream(baseStream: baseStream),
            capacity: capacity)
    }

    var buffered: Int {
        return baseStream.buffered
    }

    func cache(count: Int) async throws -> Bool {
        return try await baseStream.cache(count: count)
    }

    func peek() async throws -> UInt8 {
        return try await baseStream.peek()
    }

    func peek<T>(
        count: Int, body: (UnsafeRawBufferPointer) throws -> T) async throws -> T
    {
        return try await baseStream.peek(count: count, body: body)
    }

    func read(_ type: UInt8.Type) async throws -> UInt8 {
        return try await baseStream.read(UInt8.self)
    }

    func read<T: FixedWidthInteger>(_ type: T.Type) async throws -> T {
        return try await baseStream.read(type)
    }

    func read<T>(
        count: Int,
        body: (UnsafeRawBufferPointer) throws -> T) async throws -> T
    {
        return try await baseStream.read(count: count, body: body)
    }

    func read<T>(
        mode: PredicateMode,
        while predicate: (UInt8) -> Bool,
        body: (UnsafeRawBufferPointer) throws -> T) async throws -> T
    {
        return try await baseStream.read(
            mode: mode,
            while: predicate,
            body: body)
    }

    func consume(count: Int) async throws {
        try await baseStream.consume(count: count)
    }

    func consume(_ byte: UInt8) async throws -> Bool {
        return try await baseStream.consume(byte)
    }

    func consume(mode: PredicateMode, while predicate: (UInt8) -> Bool) async throws {
        return try await baseStream.consume(mode: mode, while: predicate)
    }
}
