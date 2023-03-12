import ComposableArchitecture
import PlaylistCreateUseCase

public struct PlayListCreate: ReducerProtocol {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case create(String)
        case dismiss
    }
    
    @Dependency(\.playlistCreateUseCase) var playlistCreateUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .create(name):
                print("# create: ", name)
                return .none
            case .dismiss:
                return .none
            }
        }
    }
}
