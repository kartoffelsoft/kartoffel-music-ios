import ComposableArchitecture
import FilesFeature
import PlayListsFeature

public struct AppRoot: ReducerProtocol {
    public struct State: Equatable {
        
        var files: Files.State
        var playLists: PlayLists.State
        
        public init() {
            files = .init()
            playLists = .init()
        }
    }
    
    public enum Action: Equatable {
        case files(Files.Action)
        case playLists(PlayLists.Action)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .files:
                return .none
            case .playLists:
                return .none
            }
        }
    }
    
}
