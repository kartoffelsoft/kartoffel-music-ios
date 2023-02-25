import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var fileManagerCreateUseCase: FileManagerCreateUseCase {
        get { self[FileManagerCreateUseCase.self] }
        set { self[FileManagerCreateUseCase.self] = newValue }
    }
    
}

extension FileManagerCreateUseCase: TestDependencyKey {
    
    static public var testValue = FileManagerCreateUseCase(
        start: XCTUnimplemented("\(FileManagerCreateUseCase.self).start")
    )
    
}
