import Foundation

struct AudioFileOptionsViewData: Equatable {
    
    let id: String
    let title: String?
    let artist: String?
    let albumName: String?
    let artwork: Data?

    init(
        id: String,
        title: String?,
        artist: String?,
        albumName: String?,
        artwork: Data?
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumName = albumName
        self.artwork = artwork
    }
    
}
