extension Request {
    public struct Accept: Equatable {
        public let mediaType: MediaType
        public let priority: Double

        public init(_ mediaType: MediaType, priority: Double = 1.0) {
            self.mediaType = mediaType
            self.priority = priority
        }
    }
}
