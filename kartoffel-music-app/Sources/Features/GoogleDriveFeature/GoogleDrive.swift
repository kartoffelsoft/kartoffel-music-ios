import ComposableArchitecture
import GoogleSignIn
import GoogleDriveUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        case requestFiles(GIDGoogleUser?)
        case receiveFiles(TaskResult<[String]>)
    }
    
    @Dependency(\.googleDriveUseCase) var googleDriveUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
//            case let .receiveAuthFromLocal(.success(user)):
//                guard let user = user else {
//                    state.needsSignIn = true
//                    return .none
//                }
//                return .run { send in
//                    await send(.requestFileList(user))
//                }
                
            case let .requestFiles(user):
                guard let _ = user else {
                    return .none
                }
                return .task {
                    await .receiveFiles(TaskResult {
                        try await googleDriveUseCase.retrieveFiles()
                    })
                }
                
            case let .receiveFiles(.success(files)):
                return .none
                
            case let .receiveFiles(.failure(error)):
                return .none
            }
        }
    }
    
}
