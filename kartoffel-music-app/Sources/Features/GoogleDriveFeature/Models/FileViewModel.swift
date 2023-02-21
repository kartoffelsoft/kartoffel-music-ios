struct FileViewModel: Equatable, Hashable {
    
    let id: String
    let name: String
    var downloadState: DownloadStateViewModel

    init(
        id: String,
        name: String,
        downloadState: DownloadStateViewModel = .nothing
    ) {
        self.id = id
        self.name = name
        self.downloadState = downloadState
    }
    
}
