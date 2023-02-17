import ComposableArchitecture
import GoogleAuthUseCase
import GoogleUserUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        var needsSignIn = false
        public init() {}
    }
    
    public enum Action: Equatable {
        case authenticate
        case access(TaskResult<String>)
    }
    
    @Dependency(\.googleAuthUseCase) var googleAuthUseCase
    @Dependency(\.googleUserUseCase) var googleUserUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
                // get User from storage: Task
                // Request gogole signIn If not available (Delegate)
                // Request file: Task
//                return .task { [rootviewController = rootviewController] in
//                    await .access(TaskResult {
//                        try await googleAuthUseCase.start(rootviewController)
//                    })
//                }
            case .authenticate:
                state.needsSignIn = true
                return .none
                
            case let .access(.success(token)):
                print("#1: ", token)
                return .none

            case let .access(.failure(error)):
                print("#2: ", error)
                return .none
            }
        }
    }
    
}
