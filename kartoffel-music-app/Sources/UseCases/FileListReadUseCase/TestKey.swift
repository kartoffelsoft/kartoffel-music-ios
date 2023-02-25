import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var fileListReadUseCase: FileListReadUseCase {
        get { self[FileListReadUseCase.self] }
        set { self[FileListReadUseCase.self] = newValue }
    }
    
}

extension FileListReadUseCase: TestDependencyKey {
    
    static public var testValue = FileListReadUseCase(
        start: XCTUnimplemented("\(FileListReadUseCase.self).start")
    )
    
}
