import ComposableArchitecture
import GoogleAuthUseCase

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case access
    }
    
    @Dependency(\.googleAuthUseCase) var googleAuthUseCase
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .access:
                googleAuthUseCase.start()
                return .none
            }
        }
    }
    
}
