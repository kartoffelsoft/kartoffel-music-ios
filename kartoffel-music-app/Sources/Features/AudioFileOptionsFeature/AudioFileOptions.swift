import ComposableArchitecture
import CommonModels
import AudioFileDeleteUseCase
import AudioFileReadUseCase

public struct AudioFileOptions: ReducerProtocol {
    public struct State: Equatable {
        let id: String
        var viewData: AudioFileOptionsViewData?
        
        public init(id: String) {
            self.id = id
        }
    }
    
    public enum Action: Equatable {
        case initialize
        case receiveMetaData(TaskResult<AudioMetaData?>)
        case delete
        case dismiss
    }
    
    @Dependency(\.audioFileDeleteUseCase) var audioFileDeleteUseCase
    @Dependency(\.audioFileReadUseCase) var audioFileReadUseCase
    
    private enum DeleteRequestID {}
    private enum AudioFileReadRequestID {}
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task { [id = state.id] in
                    await .receiveMetaData(TaskResult {
                        try await audioFileReadUseCase.start(id)
                    })
                }
                .cancellable(id: AudioFileReadRequestID.self)

            case let .receiveMetaData(.success(data)):
                guard let data = data else { return .none }
                state.viewData = .init(
                    id: data.id,
                    title: data.title,
                    artist: data.artist,
                    albumName: data.albumName,
                    artwork: data.artwork
                )
                return .none
                
            case .receiveMetaData(.failure):
                return .none
                
            case .delete:
                return .run { [id = state.id] send in
                    try? await audioFileDeleteUseCase.start(id)
                    await send(.dismiss)
                }
                .cancellable(id: DeleteRequestID.self)
            case .dismiss:
                return .none
            }
        }
    }
}
