import ComposableArchitecture

public struct AudioFileOptions: ReducerProtocol {
    public struct State: Equatable {
        let id: String
        
        public init(id: String) {
            self.id = id
        }
    }
    
    public enum Action: Equatable {
        case delete
        case dismiss
    }
    
    public init() {}
    
    public var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .delete:
                return .none
            case .dismiss:
                return .none
            }
        }
    }
}
