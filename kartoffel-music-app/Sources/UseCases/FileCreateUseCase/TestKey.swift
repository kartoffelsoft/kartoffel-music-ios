import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var fileCreateUseCase: FileCreateUseCase {
        get { self[FileCreateUseCase.self] }
        set { self[FileCreateUseCase.self] = newValue }
    }
    
}

extension FileCreateUseCase: TestDependencyKey {
    
    static public var testValue = FileCreateUseCase(
        start: XCTUnimplemented("\(FileCreateUseCase.self).start")
    )
    
}
