import CommonModels
import ComposableArchitecture
import PlaylistCreateFeature
import PlaylistReadUseCase

public struct Playlists: ReducerProtocol {
    public struct State: Equatable {
        var isNavigationActive = false
        var playlistCreate: PlaylistCreate.State? = nil
        
        var arrayOfPlaylistViewData: IdentifiedArrayOf<PlaylistViewData> = []
        
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case initialize
        case receivePlaylists(TaskResult<[PlaylistData]>)
        case navigateToPlaylistCreate(Bool)
        case playlistCreate(PlaylistCreate.Action)
    }
    
    private enum PlaylistReadRequestID {}
    
    @Dependency(\.playlistReadUseCase) var playlistReadUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task {
                    await .receivePlaylists(TaskResult {
                        try await playlistReadUseCase.start(nil)
                    })
                }
                .cancellable(id: PlaylistReadRequestID.self)
            case let .receivePlaylists(.success(data)):
                state.arrayOfPlaylistViewData.removeAll()
                state.arrayOfPlaylistViewData.append(contentsOf: data.map({
                    PlaylistViewData(
                        id: $0.id,
                        name: $0.name
                    )
                }))
                return .none
            case let .receivePlaylists(.failure):
                return .none
            case .navigateToPlaylistCreate(true):
                state.isNavigationActive = true
                state.playlistCreate = PlaylistCreate.State()
                return .none
            case .navigateToPlaylistCreate(false):
                return .none
            case .playlistCreate(.dismiss):
                state.isNavigationActive = false
                state.playlistCreate = nil
                return .none
            case .playlistCreate:
                return .none
            }
        }
        .ifLet(\.playlistCreate, action: /Action.playlistCreate) {
            PlaylistCreate()
        }
    }
}
