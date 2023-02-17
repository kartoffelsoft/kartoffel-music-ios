import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var googleUserUseCase: GoogleUserUseCase {
        get { self[GoogleUserUseCase.self] }
        set { self[GoogleUserUseCase.self] = newValue }
    }
    
}

extension GoogleUserUseCase: TestDependencyKey {
    
    static public var testValue = GoogleUserUseCase(
        start: XCTUnimplemented("\(GoogleUserUseCase.self).start")
    )
    
}
