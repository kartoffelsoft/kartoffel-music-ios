import ComposableArchitecture
import GoogleSignIn

public struct GoogleDrive: ReducerProtocol {
    public struct State: Equatable {
        public init() {
            
        }
    }
    
    public enum Action: Equatable {
        
    }
    
    public init() {}
    
    public func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    }
}
