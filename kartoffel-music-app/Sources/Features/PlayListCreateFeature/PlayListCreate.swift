import ComposableArchitecture

public struct PlayListCreate: ReducerProtocol {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        case dismiss
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .dismiss:
                return .none
            }
        }
    }
}
