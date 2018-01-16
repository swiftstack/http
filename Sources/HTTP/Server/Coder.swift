import JSON

// MARK: Coder

struct Coder {
    public enum Error: Swift.Error {
        case invalidRequest
        case invalidContentType
    }

    // MARK: Transform convenient router result into Response

    @_versioned
    @inline(__always)
    static func makeRespone<T: Encodable>(for object: T) throws -> Response {
        switch object {
        case let string as String: return Response(string: string)
        case is Void: return Response(status: .ok)
        default: return try Response(body: object)
        }
    }

    // MARK: Transform route's Model from Request

    @_versioned
    @inline(__always)
    static func decodeModel<T: Decodable>(
        _ type: T.Type,
        from request: Request
    ) throws -> T {
        switch request.method {
        case .get:
            let values = request.url.query?.values ?? [:]
            return try KeyValueDecoder().decode(type, from: values)

        default:
            guard let body = request.bytes,
                let contentType = request.contentType else {
                    throw Error.invalidRequest
            }

            switch contentType.mediaType {
            case .application(.json):
                return try JSONDecoder().decode(type, from: body)

            case .application(.formURLEncoded):
                let values = try URL.Query(from: body).values
                return try KeyValueDecoder().decode(type, from: values)

            default:
                throw Error.invalidContentType
            }
        }
    }
}
