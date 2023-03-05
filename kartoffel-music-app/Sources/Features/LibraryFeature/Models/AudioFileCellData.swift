import Foundation

struct AudioFileCellData: Equatable, Hashable, Identifiable {
    
    enum PlayState {
        case stop
        case playing
    }
    
    let id: String
    let title: String?
    let artist: String?
    let artwork: Data?
    
    var playState: PlayState

    init(
        id: String,
        title: String?,
        artist: String?,
        artwork: Data?,
        playState: PlayState
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.artwork = artwork
        self.playState = playState
    }
    
}
