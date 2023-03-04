import Foundation

struct LibraryFileViewData: Equatable, Hashable, Identifiable {
    
    let id: String
    let title: String?
    let artist: String?
    let artwork: Data?

    init(
        id: String,
        title: String?,
        artist: String?,
        artwork: Data?
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
    }
    
}
