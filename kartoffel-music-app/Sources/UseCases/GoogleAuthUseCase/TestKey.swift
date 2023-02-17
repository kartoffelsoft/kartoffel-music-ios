import ComposableArchitecture
import XCTestDynamicOverlay

extension GoogleAuthUseCase: TestDependencyKey {
    
    static public var testValue = GoogleAuthUseCase(
        start: XCTUnimplemented("\(GoogleAuthUseCase.self).start")
    )
    
}
