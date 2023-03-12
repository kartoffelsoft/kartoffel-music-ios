import ComposableArchitecture
import LibraryFeature
import PlaylistsFeature

public struct AppRoot: ReducerProtocol {
    
    public struct State: Equatable {
        var library: Library.State
        var playlists: Playlists.State
        
        public init() {
            library = .init()
            playlists = .init()
        }
    }
    
    public enum Action: Equatable {
        case library(Library.Action)
        case playlists(Playlists.Action)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .library:
                return .none
            case .playlists:
                return .none
            }
        }
        Scope(state: \.playlists, action: /Action.playlists) {
            Playlists()
        }
        Scope(state: \.library, action: /Action.library) {
            Library()
        }
    }
    
}
