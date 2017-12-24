public enum ContentEncoding: Equatable {
    case gzip
    case deflate
    case custom(String)
}
