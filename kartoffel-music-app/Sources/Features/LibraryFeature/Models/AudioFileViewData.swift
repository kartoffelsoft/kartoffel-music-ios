import CommonModels
import Foundation

struct AudioFileViewData: Equatable, Hashable, Identifiable {
    
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
    
    mutating func mutatingPlayState(_ state: PlayState) -> Self {
        playState = state
        return self
    }
}
