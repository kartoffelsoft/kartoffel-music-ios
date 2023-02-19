import CommonModels
import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var files: [FileModel]?
        public init() {}
    }
    
    public enum Action: Equatable {
        case initialize
        case requestFiles
        case receiveFiles(TaskResult<[FileModel]>)
    }
    
    @Dependency(\.googleDriveUseCase) var googleDriveUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .initialize:
                googleDriveUseCase.setAuthorizer()
                return .none
//            case let .receiveAuthFromLocal(.success(user)):
//                guard let user = user else {
//                    state.needsSignIn = true
//                    return .none
//                }
//                return .run { send in
//                    await send(.requestFileList(user))
//                }
                
            case .requestFiles:
                return .task {
                    await .receiveFiles(TaskResult {
                        try await googleDriveUseCase.retrieveFiles()
                    })
                }
                
            case let .receiveFiles(.success(files)):
                state.files = files
                return .none
                
            case let .receiveFiles(.failure(error)):
                return .none
            }
        }
    }
    
}
