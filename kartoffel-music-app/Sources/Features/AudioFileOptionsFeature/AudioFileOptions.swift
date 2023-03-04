import ComposableArchitecture
import CommonModels
import FileReadUseCase

public struct AudioFileOptions: ReducerProtocol {
    public struct State: Equatable {
        let id: String
        
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
    
    @Dependency(\.fileReadUseCase) var fileReadUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                return .task { [id = state.id] in
                    await .receiveMetaData(TaskResult {
                        try await fileReadUseCase.start(id)
                    })
                }

            case let .receiveMetaData(.success(data)):
                return .none
                
            case .receiveMetaData(.failure):
                return .none
                
            case .delete:
                return .none
            case .dismiss:
                return .none
            }
        }
    }
}
