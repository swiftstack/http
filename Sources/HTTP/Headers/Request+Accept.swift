extension Request {
    public struct Accept {
        public let mediaType: MediaType
        public let priority: Double

        public init(_ mediaType: MediaType, priority: Double = 1.0) {
            self.mediaType = mediaType
            self.priority = priority
        }
    }
}

extension Request.Accept: Equatable {
    public static func ==(lhs: Request.Accept, rhs: Request.Accept) -> Bool {
        return lhs.mediaType == rhs.mediaType &&
            lhs.priority == rhs.priority
    }
}
