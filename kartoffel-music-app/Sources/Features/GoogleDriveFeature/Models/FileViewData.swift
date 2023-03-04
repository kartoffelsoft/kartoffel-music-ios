struct FileViewData: Equatable, Hashable, Identifiable {
    
    let id: String
    let name: String
    var accessoryViewData: DownloadAccessoryViewData

    init(
        id: String,
        name: String,
        accessoryViewData: DownloadAccessoryViewData = .nothing
    ) {
        self.id = id
        self.name = name
        self.accessoryViewData = accessoryViewData
    }
    
}
