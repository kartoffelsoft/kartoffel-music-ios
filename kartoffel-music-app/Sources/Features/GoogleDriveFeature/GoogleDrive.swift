import CommonModels
import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var files: [FileViewModel]?
        public init() {}
    }
    
    public enum Action: Equatable {
        case initialize
        case requestFiles
        case receiveFiles(TaskResult<[FileModel]>)
        
        case didSelectItemAt(Int)
    }
    
    @Dependency(\.googleDriveUseCase) var googleDriveUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                googleDriveUseCase.setAuthorizer()
                return .none

            case .requestFiles:
                return .task {
                    await .receiveFiles(TaskResult {
                        try await googleDriveUseCase.retrieveFiles()
                    })
                }
                
            case let .receiveFiles(.success(files)):
                state.files = files.map({
                    FileViewModel(id: $0.id, name: $0.name)
                })
                return .none
                
            case let .receiveFiles(.failure(error)):
                return .none
                
            case let .didSelectItemAt(index):
                switch state.files?[index].downloadState {
                case .nothing:
                    state.files?[index].downloadState = .selected
                case .selected:
                    state.files?[index].downloadState = .nothing
                default:
                    ()
                }
                
                return .none
            }
        }
    }
    
}
