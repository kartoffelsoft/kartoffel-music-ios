struct FileViewModel: Equatable, Hashable, Identifiable {
    
    let id: String
    let name: String
    var accessoryViewModel: DownloadAccessoryViewModel

    init(
        id: String,
        name: String,
        accessoryViewModel: DownloadAccessoryViewModel = .nothing
    ) {
        self.id = id
        self.name = name
        self.accessoryViewModel = accessoryViewModel
    }
    
}
