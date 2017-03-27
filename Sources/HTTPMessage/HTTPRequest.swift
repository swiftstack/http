public enum HTTPRequestType {
    case get
    case head
    case post
    case put
    case delete
    case options
}

enum HTTPRequestError: Error {
    case invalidRequest
    case invalidMethod
    case invalidVersion
    case invalidHeaderName
    case unexpectedEnd
}

extension HTTPRequest {
    public enum ContentType: String {
        case urlEncoded = "application/x-www-form-urlencoded"
        case json = "application/json"
    }
}

public class HTTPRequest {
    public private(set) var type: HTTPRequestType
    public private(set) var version: HTTPVersion
    private var _url: ArraySlice<UInt8>
    private var _headers: [HeaderName: ArraySlice<UInt8>] = [:]
    private var _cookies: [ArraySlice<UInt8>] = []
    private var _body: [ArraySlice<UInt8>]

    public private(set) var size: Int

    /// lazy. string construction is slow, use only if you really need it
    public lazy var url: String = { [unowned self] in
        if let index = self._url.index(of: Character.questionMark) {
            return String(slice: self._url.prefix(upTo: index))
        }
        return String(slice: self._url)
    }()

    public lazy var queryString: String = { [unowned self] in
        if let index = self._url.index(of: Character.questionMark) {
            return String(slice: self._url.suffix(from: index.advanced(by: 1)))
        }
        return ""
    }()

    public lazy var urlBytes: [UInt8] = { [unowned self] in
        if let index = self._url.index(of: Character.questionMark) {
            return [UInt8](self._url.prefix(upTo: index))
        }
        return [UInt8](self._url)
    }()

    // MARK: Headers

    @inline(__always)
    fileprivate func getHeaderValueIfPresent(_ name: HeaderName) -> String? {
        guard let value = self._headers[name] else {
            return nil
        }
        return String(slice: value)
    }

    @inline(__always)
    fileprivate func getHeaderValueIfPresent(_ name: HeaderName) -> Int? {
        guard let value: String = getHeaderValueIfPresent(name) else {
            return nil
        }
        return Int(value)
    }

    public lazy var host: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.host)
    }()

    public lazy var userAgent: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.userAgent)
    }()

    public lazy var accept: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.accept)
    }()

    public lazy var acceptLanguage: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.acceptLanguage)
    }()

    public lazy var acceptEncoding: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.acceptEncoding)
    }()

    public lazy var acceptCharset: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.acceptCharset)
    }()

    public lazy var keepAlive: Int? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.keepAlive)
    }()

    public lazy var shouldKeepAlive: Bool = { [unowned self] in
        if self.connection?.lowercased() == "close" {
            return false
        }
        return true
    }()

    public lazy var connection: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.connection)
    }()

    public lazy var contentType: ContentType? = { [unowned self] in
        guard let contentType: String =
            self.getHeaderValueIfPresent(HeaderName.contentType) else {
                return nil
        }
        return ContentType(rawValue: contentType)
    }()

    public lazy var contentLength: Int? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.contentLength)
    }()

    public lazy var transferEncoding: String? = { [unowned self] in
        return self.getHeaderValueIfPresent(HeaderName.transferEncoding)
    }()

    public lazy var rawBody: [UInt8]? = { [unowned self] in
        if self._body.count == 0 {
            return nil
        }
        var body = [UInt8]()
        for chunk in self._body {
            body.append(contentsOf: chunk)
        }
        return body
    }()

    public lazy var body: String? = { [unowned self] in
        guard let bytes = self.rawBody else {
            return nil
        }
        return String(cString: bytes + [0])
    }()

    public init(fromBytes bytes: [UInt8]) throws {
        guard let typeEnd = bytes.index(of: Character.whitespace) else { throw HTTPRequestError.invalidRequest }
        self.type = try HTTPRequestType(slice: bytes[bytes.startIndex..<typeEnd])

        let queryStart = bytes.index(after: typeEnd)
        let queryArea = bytes[queryStart..<bytes.endIndex]
        guard let queryEnd = queryArea.index(of: Character.whitespace) else { throw HTTPRequestError.invalidRequest }
        self._url = bytes[queryStart..<queryEnd]

        let httpStart = bytes.index(after: queryEnd)
        let httpEnd = bytes.index(httpStart, offsetBy: HTTPConstants.versionLength)
        guard httpEnd < bytes.endIndex else { throw HTTPRequestError.unexpectedEnd }
        let httpArea = bytes[httpStart..<bytes.endIndex]
        self.version = try HTTPVersion(slice: httpArea)

        let requestLineEnd = httpEnd.advanced(by: 2)
        guard requestLineEnd < bytes.endIndex else { throw HTTPRequestError.unexpectedEnd }
        guard bytes[httpEnd..<requestLineEnd].elementsEqual(HTTPConstants.lineEnd) else {
            throw HTTPRequestError.invalidRequest
        }


        var nextLine = requestLineEnd
        let maximumHeaderStart = bytes.endIndex.advanced(by: -HTTPConstants.minimumHeaderLength)
        while nextLine < maximumHeaderStart
            && bytes[nextLine] != Character.cr
            && bytes[nextLine.advanced(by: 1)] != Character.lf {

                guard let colonIndex = bytes[nextLine..<bytes.endIndex].index(of: Character.colon) else {
                    throw HTTPRequestError.invalidHeaderName
                }
                let headerName = try HeaderName(validatingCharacters: bytes[nextLine..<colonIndex])

                guard let lineEnd = bytes[colonIndex..<bytes.endIndex].index(of: Character.cr) else {
                    throw HTTPRequestError.unexpectedEnd
                }

                let headerValueStart = bytes[colonIndex.advanced(by: 1)] == Character.whitespace ?
                    bytes.index(after: colonIndex.advanced(by: 1)) :
                    bytes.index(after: colonIndex)

                let headerValueEnd = bytes[lineEnd.advanced(by: -1)] == Character.whitespace ?
                    bytes.index(before: lineEnd) :
                    lineEnd

                self._headers[headerName] = bytes[headerValueStart..<headerValueEnd]

                nextLine = lineEnd.advanced(by: 2)
        }

        guard nextLine <= bytes.endIndex.advanced(by: -2),
            bytes[nextLine] == Character.cr,
            bytes[nextLine.advanced(by: 1)] == Character.lf else {
            throw HTTPRequestError.unexpectedEnd
        }
        nextLine = nextLine.advanced(by: 2)

        // Body

        self._body = []

        // 1. content-lenght
        if let contentLength = self._headers[HeaderName.contentLength],
            let length = Int(String(slice: contentLength)) {

            let endIndex = nextLine.advanced(by: length)
            guard endIndex <= bytes.endIndex else {
                throw HTTPRequestError.unexpectedEnd
            }
            self._body.append(bytes[nextLine..<endIndex])
            size = endIndex
            return
        }

        // 2. chunked
        guard let transferEncoding = self._headers[HeaderName.transferEncoding],
            transferEncoding.contains(other: HTTPConstants.chunked.slice) else {
            size = nextLine
            return
        }

        self._body = []
        let maximumChunkedStart = bytes.endIndex.advanced(by: -HTTPConstants.minimumChunkLength)
        while nextLine <= maximumChunkedStart {
            guard let sizeEnd = bytes[nextLine..<bytes.endIndex].index(of: Character.cr),
                bytes[sizeEnd.advanced(by: 1)] == Character.lf else {
                throw HTTPRequestError.invalidRequest
            }

            let hexSize = String(slice: bytes[nextLine..<sizeEnd])
            guard let size = Int(hexSize, radix: 16) else {
                throw HTTPRequestError.invalidRequest
            }
            guard size > 0 else {
                nextLine = sizeEnd.advanced(by: 2)
                break
            }
            let messageStart = sizeEnd.advanced(by: 2)
            let messageEnd = messageStart.advanced(by: size)
            guard messageEnd < bytes.endIndex else {
                throw HTTPRequestError.unexpectedEnd
            }

            self._body.append(bytes[messageStart..<messageEnd])
            nextLine = messageEnd.advanced(by: 2)
        }

        guard nextLine == bytes.endIndex || (
            nextLine == bytes.endIndex.advanced(by: -2) &&
                bytes.suffix(from: nextLine).elementsEqual(HTTPConstants.lineEnd)) else {
                    throw HTTPRequestError.unexpectedEnd
        }
        self.size = nextLine
    }
}
