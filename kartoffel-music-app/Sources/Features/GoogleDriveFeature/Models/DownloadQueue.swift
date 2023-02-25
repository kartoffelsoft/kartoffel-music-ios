struct DownloadQueue: Equatable {

    private var queue: [String]
    
    var total: Int
    var done: Int { self.total - self.queue.count }
    var first: String? { return queue.first }

    init(_ queue: [String]) {
        self.queue = queue
        self.total = queue.count
    }
    
    mutating func removeFirst() {
        self.queue.removeFirst()
    }
    
    mutating func reload(_ queue: [String]) {
        self.queue = queue
        self.total = queue.count
    }
    
}
