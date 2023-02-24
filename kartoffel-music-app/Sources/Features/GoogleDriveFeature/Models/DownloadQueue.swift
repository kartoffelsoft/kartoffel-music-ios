struct DownloadQueue: Equatable {
    private var queue: [String]
    let total: Int
    
    var done: Int {
        self.total - self.queue.count
    }
    
    var first: String? {
        return queue.first
    }
    
    mutating func removeFirst() {
        self.queue.removeFirst()
    }
    
    init(_ queue: [String]) {
        self.queue = queue
        self.total = queue.count
    }
}
