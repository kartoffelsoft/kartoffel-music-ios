import ComposableArchitecture

extension GoogleUserUseCase: DependencyKey {
    
    static public var liveValue = GoogleUserUseCase(
        start: {
            return nil
        },
        store: { user in 
            return
        }
    )
}
