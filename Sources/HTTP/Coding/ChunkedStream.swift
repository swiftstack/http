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

    var closed = false
    var currentChunkBytesLeft = 0

    func readNextChunkSize() async throws -> Int {
        let size = try await baseStream.read(until: .cr) { bytes -> Int in
            guard let size = Int(from: bytes, radix: 16) else {
                throw Error.invalidRequest
            }
            return size
        }
        try await readLineEnd()
        return size
    }

    func read(
        to pointer: UnsafeMutableRawPointer,
        byteCount requested: Int
    ) async throws -> Int {
        guard !closed else {
            return 0
        }

        @inline(__always)
        func read(byteCount: Int, offset: Int = 0) async throws {
            try await baseStream.read(count: byteCount) { bytes in
                pointer
                    .advanced(by: offset)
                    .copyMemory(
                        from: bytes.baseAddress!,
                        byteCount: bytes.count)
            }
        }

        if currentChunkBytesLeft > requested {
            try await read(byteCount: requested)
            currentChunkBytesLeft -= requested
            return requested
        }

        var remaining = requested
        if currentChunkBytesLeft > 0 {
            try await read(byteCount: currentChunkBytesLeft)
            remaining -= currentChunkBytesLeft
            currentChunkBytesLeft = 0
            try await readLineEnd()
        }

        while remaining > 0 {
            currentChunkBytesLeft = try await readNextChunkSize()
            guard currentChunkBytesLeft > 0 else {
                try await readLineEnd()
                closed = true
                return requested - remaining
            }
            let count = min(remaining, currentChunkBytesLeft)
            try await read(byteCount: count, offset: requested - remaining)
            if currentChunkBytesLeft <= remaining {
                try await readLineEnd()
            }
            remaining -= count
        }

        return requested
    }

    func close() async throws {
        guard !closed else {
            return
        }
        if currentChunkBytesLeft > 0 {
            try await baseStream.consume(count: currentChunkBytesLeft)
            currentChunkBytesLeft = 0
        }
        while true {
            let size = try await readNextChunkSize()
            guard size > 0 else {
                try await readLineEnd()
                closed = true
                break
            }
            try await baseStream.consume(count: size)
        }
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

    init(baseStream: StreamReader) {
        self.baseStream = BufferedInputStream(
            baseStream: ChunkedInputStream(baseStream: baseStream),
            capacity: 4096)
    }

    func close() async throws {
        try await baseStream.baseStream.close()
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
