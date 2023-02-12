import ComposableArchitecture
import LibraryFeature
import PlayListsFeature

public struct AppRoot: ReducerProtocol {
    public struct State: Equatable {
        
        var library: Library.State
        var playLists: PlayLists.State
        
        public init() {
            library = .init()
            playLists = .init()
        }
    }
    
    public enum Action: Equatable {
        case library(Library.Action)
        case playLists(PlayLists.Action)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .library:
                return .none
            case .playLists:
                return .none
            }
        }
        Scope(state: \.playLists, action: /Action.playLists) {
            PlayLists()
        }
        Scope(state: \.library, action: /Action.library) {
            Library()
        }
    }
    
}
