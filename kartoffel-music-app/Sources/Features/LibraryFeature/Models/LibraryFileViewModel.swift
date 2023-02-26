struct LibraryFileViewModel: Equatable, Hashable, Identifiable {
    
    let id: String
    let title: String?

    init(
        id: String,
        title: String?
    ) {
        self.id = id
        self.title = title
    }
    
}
