import CommonModels
import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var files: [FileViewModel]?
        var downloadBar: DownloadBarViewModel = .nothing
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
                switch state.files?[index].accessoryViewModel {
                case .nothing:
                    state.files?[index].accessoryViewModel = .selected
                case .selected:
                    state.files?[index].accessoryViewModel = .nothing
                default:
                    ()
                }
                
                guard let files = state.files else { return .none }
                let count = files.filter { $0.accessoryViewModel == .selected }.count
                state.downloadBar = count == 0 ? .nothing : .selected(count)
                
                return .none
            }
        }
    }
    
}
