var isDebugBuild: Bool {
    @inline(__always) get {
        return _isDebugAssertConfiguration()
    }
}
