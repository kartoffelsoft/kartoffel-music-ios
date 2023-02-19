import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var googleDriveUseCase: GoogleDriveUseCase {
        get { self[GoogleDriveUseCase.self] }
        set { self[GoogleDriveUseCase.self] = newValue }
    }
    
}

extension GoogleDriveUseCase: TestDependencyKey {
    
    static public var testValue = GoogleDriveUseCase(
        setAuthorizer: XCTUnimplemented("\(GoogleDriveUseCase.self).setAuthorizer"),
        retrieveFiles: XCTUnimplemented("\(GoogleDriveUseCase.self).retrieveFiles")
    )
    
}
