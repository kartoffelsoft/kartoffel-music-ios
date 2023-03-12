import ComposableArchitecture
import PlaylistCreateFeature

public struct Playlists: ReducerProtocol {
    public struct State: Equatable {
        var isNavigationActive = false
        var playListCreate: PlaylistCreate.State? = nil
        
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case navigateToPlayListCreate(Bool)
        case playListCreate(PlaylistCreate.Action)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .navigateToPlayListCreate(true):
                state.isNavigationActive = true
                state.playListCreate = PlaylistCreate.State()
                return .none
            case .navigateToPlayListCreate(false):
                return .none
            case .playListCreate(.dismiss):
                state.isNavigationActive = false
                state.playListCreate = nil
                return .none
            case .playListCreate:
                return .none
            }
        }
        .ifLet(\.playListCreate, action: /Action.playListCreate) {
            PlaylistCreate()
        }
    }
}
