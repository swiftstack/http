import Stream

extension Response.Status {
    private struct Bytes {
        // 1xx
        static let `continue` = ASCII("100 Continue")
        static let switchingProtocols = ASCII("101 Switching Protocols")
        static let processing = ASCII("102 Processing")
        static let earlyHints = ASCII("103 Early Hints")
        // 2xx
        static let ok = ASCII("200 OK")
        static let created = ASCII("201 Created")
        static let accepted = ASCII("202 Accepted")
        static let nonAuthoritativeInformation =
            ASCII("203 Non-Authoritative Information")
        static let noContent = ASCII("204 No Content")
        static let resetContent = ASCII("205 Reset Content")
        static let partialContent = ASCII("206 Partial Content")
        static let multiStatus = ASCII("207 Multi-Status")
        static let alreadyReported = ASCII("208 Already Reported")
        static let imUsed = ASCII("226 IM Used")
        // 3xx
        static let multipleChoices = ASCII("300 Multiple Choices")
        static let moved = ASCII("301 Moved Permanently")
        static let found = ASCII("302 Found")
        static let seeOther = ASCII("303 See Other")
        static let notModified = ASCII("304 Not Modified")
        static let useProxy = ASCII("305 Use Proxy")
        static let switchProxy = ASCII("306 Switch Proxy")
        static let temporaryRedirect = ASCII("307 Temporary Redirect")
        static let permanentRedirect = ASCII("308 Permanent Redirect")
        // 4xx
        static let badRequest = ASCII("400 Bad Request")
        static let unauthorized = ASCII("401 Unauthorized")
        static let paymentRequired = ASCII("402 Payment Required")
        static let forbidden = ASCII("403 Forbidden")
        static let notFound = ASCII("404 Not Found")
        static let methodNotAllowed = ASCII("405 Method Not Allowed")
        static let notAcceptable = ASCII("406 Not Acceptable")
        static let proxyAuthenticationRequired =
            ASCII("407 Proxy Authentication Required")
        static let requestTimeout = ASCII("408 Request Timeout")
        static let conflict = ASCII("409 Conflict")
        static let gone = ASCII("410 Gone")
        static let lengthRequired = ASCII("411 Length Required")
        static let preconditionFailed = ASCII("412 Precondition Failed")
        static let payloadTooLarge = ASCII("413 Payload Too Large")
        static let uriTooLong = ASCII("414 URI Too Long")
        static let unsupportedMediaType = ASCII("415 Unsupported Media Type")
        static let rangeNotSatisfiable = ASCII("416 Range Not Satisfiable")
        static let expectationFailed = ASCII("417 Expectation Failed")
        static let iAmATeapot = ASCII("418 I'm a teapot")
        static let misdirectedRequest = ASCII("421 Misdirected Request")
        static let unprocessableEntity = ASCII("422 Unprocessable Entity")
        static let locked = ASCII("423 Locked")
        static let failedDependency = ASCII("424 Failed Dependency")
        static let upgradeRequired = ASCII("426 Upgrade Required")
        static let preconditionRequired = ASCII("428 Precondition Required")
        static let tooManyRequests = ASCII("429 Too Many Requests")
        static let requestHeaderFieldsTooLarge =
            ASCII("431 Request Header Fields Too Large")
        static let unavailableForLegalReasons =
            ASCII("451 Unavailable For Legal Reasons")
        // 5xx
        static let internalServerError = ASCII("500 Internal Server Error")
        static let notImplemented = ASCII("501 Not Implemented")
        static let badGateway = ASCII("502 Bad Gateway")
        static let serviceUnavailable = ASCII("503 Service Unavailable")
        static let gatewayTimeout = ASCII("504 Gateway Timeout")
        static let httpVersionNotSupported =
            ASCII("505 HTTP Version Not Supported")
        static let variantAlsoNegotiates = ASCII("506 Variant Also Negotiates")
        static let insufficientStorage = ASCII("507 Insufficient Storage")
        static let loopDetected = ASCII("508 Loop Detected")
        static let notExtended = ASCII("510 Not Extended")
        static let networkAuthenticationRequired =
            ASCII("511 Network Authentication Required")
    }

    init<T: UnsafeStreamReader>(from stream: T) throws {
        let bytes = try stream.read(until: .cr)
        switch bytes.lowercasedHashValue {
        case Bytes.`continue`.lowercasedHashValue: self = .`continue`
        case Bytes.switchingProtocols.lowercasedHashValue: self = .switchingProtocols
        case Bytes.processing.lowercasedHashValue: self = .processing
        case Bytes.earlyHints.lowercasedHashValue: self = .earlyHints
        case Bytes.ok.lowercasedHashValue: self = .ok
        case Bytes.created.lowercasedHashValue: self = .created
        case Bytes.accepted.lowercasedHashValue: self = .accepted
        case Bytes.nonAuthoritativeInformation.lowercasedHashValue: self = .nonAuthoritativeInformation
        case Bytes.noContent.lowercasedHashValue: self = .noContent
        case Bytes.resetContent.lowercasedHashValue: self = .resetContent
        case Bytes.partialContent.lowercasedHashValue: self = .partialContent
        case Bytes.multiStatus.lowercasedHashValue: self = .multiStatus
        case Bytes.alreadyReported.lowercasedHashValue: self = .alreadyReported
        case Bytes.imUsed.lowercasedHashValue: self = .imUsed
        case Bytes.multipleChoices.lowercasedHashValue: self = .multipleChoices
        case Bytes.moved.lowercasedHashValue: self = .moved
        case Bytes.found.lowercasedHashValue: self = .found
        case Bytes.seeOther.lowercasedHashValue: self = .seeOther
        case Bytes.notModified.lowercasedHashValue: self = .notModified
        case Bytes.useProxy.lowercasedHashValue: self = .useProxy
        case Bytes.switchProxy.lowercasedHashValue: self = .switchProxy
        case Bytes.temporaryRedirect.lowercasedHashValue: self = .temporaryRedirect
        case Bytes.permanentRedirect.lowercasedHashValue: self = .permanentRedirect
        case Bytes.badRequest.lowercasedHashValue: self = .badRequest
        case Bytes.unauthorized.lowercasedHashValue: self = .unauthorized
        case Bytes.paymentRequired.lowercasedHashValue: self = .paymentRequired
        case Bytes.forbidden.lowercasedHashValue: self = .forbidden
        case Bytes.notFound.lowercasedHashValue: self = .notFound
        case Bytes.methodNotAllowed.lowercasedHashValue: self = .methodNotAllowed
        case Bytes.notAcceptable.lowercasedHashValue: self = .notAcceptable
        case Bytes.proxyAuthenticationRequired.lowercasedHashValue: self = .proxyAuthenticationRequired
        case Bytes.requestTimeout.lowercasedHashValue: self = .requestTimeout
        case Bytes.conflict.lowercasedHashValue: self = .conflict
        case Bytes.gone.lowercasedHashValue: self = .gone
        case Bytes.lengthRequired.lowercasedHashValue: self = .lengthRequired
        case Bytes.preconditionFailed.lowercasedHashValue: self = .preconditionFailed
        case Bytes.payloadTooLarge.lowercasedHashValue: self = .payloadTooLarge
        case Bytes.uriTooLong.lowercasedHashValue: self = .uriTooLong
        case Bytes.unsupportedMediaType.lowercasedHashValue: self = .unsupportedMediaType
        case Bytes.rangeNotSatisfiable.lowercasedHashValue: self = .rangeNotSatisfiable
        case Bytes.expectationFailed.lowercasedHashValue: self = .expectationFailed
        case Bytes.iAmATeapot.lowercasedHashValue: self = .iAmATeapot
        case Bytes.misdirectedRequest.lowercasedHashValue: self = .misdirectedRequest
        case Bytes.unprocessableEntity.lowercasedHashValue: self = .unprocessableEntity
        case Bytes.locked.lowercasedHashValue: self = .locked
        case Bytes.failedDependency.lowercasedHashValue: self = .failedDependency
        case Bytes.upgradeRequired.lowercasedHashValue: self = .upgradeRequired
        case Bytes.preconditionRequired.lowercasedHashValue: self = .preconditionRequired
        case Bytes.tooManyRequests.lowercasedHashValue: self = .tooManyRequests
        case Bytes.requestHeaderFieldsTooLarge.lowercasedHashValue: self = .requestHeaderFieldsTooLarge
        case Bytes.unavailableForLegalReasons.lowercasedHashValue: self = .unavailableForLegalReasons
        case Bytes.internalServerError.lowercasedHashValue: self = .internalServerError
        case Bytes.notImplemented.lowercasedHashValue: self = .notImplemented
        case Bytes.badGateway.lowercasedHashValue: self = .badGateway
        case Bytes.serviceUnavailable.lowercasedHashValue: self = .serviceUnavailable
        case Bytes.gatewayTimeout.lowercasedHashValue: self = .gatewayTimeout
        case Bytes.httpVersionNotSupported.lowercasedHashValue: self = .httpVersionNotSupported
        case Bytes.variantAlsoNegotiates.lowercasedHashValue: self = .variantAlsoNegotiates
        case Bytes.insufficientStorage.lowercasedHashValue: self = .insufficientStorage
        case Bytes.loopDetected.lowercasedHashValue: self = .loopDetected
        case Bytes.notExtended.lowercasedHashValue: self = .notExtended
        case Bytes.networkAuthenticationRequired.lowercasedHashValue: self = .networkAuthenticationRequired
        default:
            guard let spaceIndex = bytes.index(of: .whitespace) else {
                throw ParseError.invalidStatus
            }
            let codeString =
                String(decoding: bytes[..<spaceIndex], as: UTF8.self)
            guard let code = Int(codeString) else {
                throw ParseError.invalidStatus
            }
            let descriptionIndex = spaceIndex + 1
            guard descriptionIndex < bytes.endIndex else {
                throw ParseError.invalidStatus
            }
            let description =
                String(decoding: bytes[descriptionIndex...], as: UTF8.self)
            self = .custom(code, description)
        }
    }

    func encode<T: UnsafeStreamWriter>(to stream: T) throws {
        let bytes: [UInt8]
        switch self {
        case .`continue`: bytes = Bytes.`continue`
        case .switchingProtocols: bytes = Bytes.switchingProtocols
        case .processing: bytes = Bytes.processing
        case .earlyHints: bytes = Bytes.earlyHints
        case .ok: bytes = Bytes.ok
        case .created: bytes = Bytes.created
        case .accepted: bytes = Bytes.accepted
        case .nonAuthoritativeInformation: bytes = Bytes.nonAuthoritativeInformation
        case .noContent: bytes = Bytes.noContent
        case .resetContent: bytes = Bytes.resetContent
        case .partialContent: bytes = Bytes.partialContent
        case .multiStatus: bytes = Bytes.multiStatus
        case .alreadyReported: bytes = Bytes.alreadyReported
        case .imUsed: bytes = Bytes.imUsed
        case .multipleChoices: bytes = Bytes.multipleChoices
        case .moved: bytes = Bytes.moved
        case .found: bytes = Bytes.found
        case .seeOther: bytes = Bytes.seeOther
        case .notModified: bytes = Bytes.notModified
        case .useProxy: bytes = Bytes.useProxy
        case .switchProxy: bytes = Bytes.switchProxy
        case .temporaryRedirect: bytes = Bytes.temporaryRedirect
        case .permanentRedirect: bytes = Bytes.permanentRedirect
        case .badRequest: bytes = Bytes.badRequest
        case .unauthorized: bytes = Bytes.unauthorized
        case .paymentRequired: bytes = Bytes.paymentRequired
        case .forbidden: bytes = Bytes.forbidden
        case .notFound: bytes = Bytes.notFound
        case .methodNotAllowed: bytes = Bytes.methodNotAllowed
        case .notAcceptable: bytes = Bytes.notAcceptable
        case .proxyAuthenticationRequired: bytes = Bytes.proxyAuthenticationRequired
        case .requestTimeout: bytes = Bytes.requestTimeout
        case .conflict: bytes = Bytes.conflict
        case .gone: bytes = Bytes.gone
        case .lengthRequired: bytes = Bytes.lengthRequired
        case .preconditionFailed: bytes = Bytes.preconditionFailed
        case .payloadTooLarge: bytes = Bytes.payloadTooLarge
        case .uriTooLong: bytes = Bytes.uriTooLong
        case .unsupportedMediaType: bytes = Bytes.unsupportedMediaType
        case .rangeNotSatisfiable: bytes = Bytes.rangeNotSatisfiable
        case .expectationFailed: bytes = Bytes.expectationFailed
        case .iAmATeapot: bytes = Bytes.iAmATeapot
        case .misdirectedRequest: bytes = Bytes.misdirectedRequest
        case .unprocessableEntity: bytes = Bytes.unprocessableEntity
        case .locked: bytes = Bytes.locked
        case .failedDependency: bytes = Bytes.failedDependency
        case .upgradeRequired: bytes = Bytes.upgradeRequired
        case .preconditionRequired: bytes = Bytes.preconditionRequired
        case .tooManyRequests: bytes = Bytes.tooManyRequests
        case .requestHeaderFieldsTooLarge: bytes = Bytes.requestHeaderFieldsTooLarge
        case .unavailableForLegalReasons: bytes = Bytes.unavailableForLegalReasons
        case .internalServerError: bytes = Bytes.internalServerError
        case .notImplemented: bytes = Bytes.notImplemented
        case .badGateway: bytes = Bytes.badGateway
        case .serviceUnavailable: bytes = Bytes.serviceUnavailable
        case .gatewayTimeout: bytes = Bytes.gatewayTimeout
        case .httpVersionNotSupported: bytes = Bytes.httpVersionNotSupported
        case .variantAlsoNegotiates: bytes = Bytes.variantAlsoNegotiates
        case .insufficientStorage: bytes = Bytes.insufficientStorage
        case .loopDetected: bytes = Bytes.loopDetected
        case .notExtended: bytes = Bytes.notExtended
        case .networkAuthenticationRequired: bytes = Bytes.networkAuthenticationRequired
        case .custom(let code, let description):
            bytes = [UInt8]("\(code) " + description)
        }
        try stream.write(bytes)
    }
}
