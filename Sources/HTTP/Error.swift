enum HTTPError: Error {
    case invalidRequest
    case invalidResponse
    case invalidURL
    case invalidMethod
    case invalidStatus
    case invalidVersion
    case invalidHeaderName
    case invalidHeaderValue
    case unsupportedContentType
    case unsupportedAcceptCharset
    case unexpectedEnd
}
