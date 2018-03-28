import JSON
import Stream
import Network

// MARK: Coder

public struct Coder {
    public enum Error: Swift.Error {
        case invalidRequest
        case invalidContentType
    }

    // MARK: Transform convenient router result into Response

    @_versioned
    @inline(__always)
    static func makeRespone<T: Encodable>(
        for request: Request,
        encoding object: T
    ) throws -> Response {
        let response = Response(status: .ok)
        try Coder.updateRespone(response, for: request, with: .object(object))
        return response
    }

    @inline(__always)
    public static func updateRespone(
        _ response: Response,
        for request: Request,
        with result: ApiResult
    ) throws {
        switch result {
        case .string(let string):
            response.contentType = .text
            response.string = string
        case .redirect(let to):
            response.status = .found
            response.headers["Location"] = to
        case .status(let status):
            response.status = status
        case .json(let object):
            try Coder.encode(object: object, to: response, contentType: .json)
        case .object(let object):
            // TODO: respect Request.Accept
            switch object {
            case let string as String:
                if response.contentType == nil {
                    response.contentType = .text
                }
                response.string = string
            default:
                try Coder.encode(
                    object: object,
                    to: response,
                    contentType: .json)
            }
        }
    }

    @_versioned
    static func encode(
        object: Encodable,
        to response: Response,
        contentType type: ApplicationSubtype
    ) throws {
        switch type {
        case .json:
            // TODO: Use stream + chunked?
            let bytes = try JSONEncoder().encode(object)
            response.bytes = bytes
            response.contentLength = bytes.count
            response.contentType = .json

        case .formURLEncoded:
            let bytes = try FormURLEncoded.encode(encodable: object)
            response.bytes = bytes
            response.contentLength = bytes.count
            response.contentType = .formURLEncoded

        default:
            throw ParseError.unsupportedContentType
        }
    }

    // MARK: Transform route's Model from Request

    @_inlineable
    public static func decodeModel<T: Decodable>(
        _ type: T.Type,
        from request: Request
    ) throws -> T {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return try KeyValueDecoder().decode(type, from: values)

        default:
            guard let contentType = request.contentType else {
                throw Error.invalidRequest
            }

            switch contentType.mediaType {
            case .application(.json):
                return try decodeJSON(type, from: request)

            case .application(.formURLEncoded):
                return try decodeFormEncoded(type, from: request)

            default:
                throw Error.invalidContentType
            }
        }
    }

    @_inlineable
    public static func decodeJSON<T: Decodable>(
        _ type: T.Type,
        from request: Request) throws -> T
    {
        switch request.body {
        case .bytes(let bytes):
            let stream = InputByteStream(bytes)
            return try JSONDecoder().decode(type, from: stream)
        case .input(let reader):
            switch reader {
            // FIXME: Use typed reader or add the api to JSONDecoder
            case let stream as BufferedInputStream<NetworkStream>:
                return try JSONDecoder().decode(type, from: stream)
            default:
                return try reader.read(while: { _ in true }) { bytes -> T in
                    let stream = UnsafeRawInputStream(bytes)
                    return try JSONDecoder().decode(type, from: stream)
                }
            }
        default:
            throw Error.invalidRequest
        }
    }

    @_inlineable
    public static func decodeFormEncoded<T: Decodable>(
        _ type: T.Type,
        from request: Request) throws -> T
    {
        // TODO: Use stream
        guard let bytes = request.bytes else {
            throw Error.invalidRequest
        }
        let values = try URL.Query(from: bytes).values
        return try KeyValueDecoder().decode(type, from: values)
    }
}

extension UnsafeRawInputStream {
    @_versioned
    convenience init(_ bytes: UnsafeRawBufferPointer) {
        self.init(pointer: bytes.baseAddress!, count: bytes.count)
    }
}
