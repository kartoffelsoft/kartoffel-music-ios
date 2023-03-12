import ComposableArchitecture
import PlaylistCreateUseCase

public struct PlaylistCreate: ReducerProtocol {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case create(String)
        case dismiss
    }
    
    @Dependency(\.playlistCreateUseCase) var playlistCreateUseCase
    
    private enum PlaylistCreateRequestID {}

    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .create(name):
                return .run { send in
                    try? await playlistCreateUseCase.start(name)
                    await send(.dismiss)
                }
                .cancellable(id: PlaylistCreateRequestID.self)
            case .dismiss:
                return .none
            }
        }
    }
}
