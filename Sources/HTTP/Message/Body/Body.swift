import Stream

public enum Body {
    case input(StreamReader)
    case output((StreamWriter) async throws -> Void)

    static func input(_ bytes: [UInt8]) -> Body {
        .input(InputByteStream(bytes))
    }

    static func input(_ string: String) -> Body {
        .input(InputByteStream(string))
    }

    static func output(_ bytes: [UInt8]) -> Body {
        .output({ try await $0.write(bytes) })
    }

    static func output(_ string: String) -> Body {
        .output({ try await $0.write(string) })
    }
}
