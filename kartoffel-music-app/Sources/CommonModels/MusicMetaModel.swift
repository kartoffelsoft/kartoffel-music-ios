import Foundation

public struct MusicMetaModel: Equatable {
    
    public let id: String
    public let title: String?
    public let artist: String?
    public let albumName: String?
    public let artwork: Data?
    
    public init(
        id: String,
        title: String? = nil,
        artist: String? = nil,
        albumName: String? = nil,
        artwork: Data? = nil
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.albumName = albumName
        self.artwork = artwork
    }
    
}
