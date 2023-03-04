import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var fileReadUseCase: FileReadUseCase {
        get { self[FileReadUseCase.self] }
        set { self[FileReadUseCase.self] = newValue }
    }
    
}

extension FileReadUseCase: TestDependencyKey {
    
    static public var testValue = FileReadUseCase(
        start: XCTUnimplemented("\(FileReadUseCase.self).start")
    )
    
}
