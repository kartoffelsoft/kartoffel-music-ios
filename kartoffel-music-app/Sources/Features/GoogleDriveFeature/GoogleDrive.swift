import ComposableArchitecture
import GoogleAuthUseCase
import GoogleSignIn
import GoogleUserUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var needsSignIn = false
        public init() {}
    }
    
    public enum Action: Equatable {
        case requestAuthFromLocal
        case receiveAuthFromLocal(TaskResult<GIDGoogleUser?>)
        case receiveAuthFromRemote(GIDGoogleUser)
        case requestFileList(GIDGoogleUser)
        case navigateBack
    }
    
    @Dependency(\.googleAuthUseCase) var googleAuthUseCase
    @Dependency(\.googleUserUseCase) var googleUserUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .requestAuthFromLocal:
                return .task {
                    await .receiveAuthFromLocal(TaskResult {
                        try await googleUserUseCase.start()
                    })
                }
                
            case let .receiveAuthFromLocal(.success(user)):
                guard let user = user else {
                    state.needsSignIn = true
                    return .none
                }
                return .run { send in
                    await send(.requestFileList(user))
                }
                
            case let .receiveAuthFromLocal(.failure(error)):
                print("[ERROR]:", error.localizedDescription)
                return .none
                
            case let .receiveAuthFromRemote(user):
                return .run { send in
                    try await googleUserUseCase.store(user)
                    await send(.requestFileList(user))
                }
                
            case let .requestFileList(user):
                return .none
                
            case .navigateBack:
                state.needsSignIn = false
                return .none
            }
        }
    }
    
}
