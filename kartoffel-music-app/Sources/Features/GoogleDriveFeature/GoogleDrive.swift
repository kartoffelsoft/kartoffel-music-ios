import ComposableArchitecture
import GoogleSignIn
import GoogleUserUseCase
import UIKit

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        public init() {}
    }
    
    public enum Action: Equatable {
        case requestFileList(GIDGoogleUser?)
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case let .requestFileList(user):
                guard let user = user else {
                    return .none
                }
                return .none
            }
        }
    }
    
}
