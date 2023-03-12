import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var playlistCreateUseCase: PlaylistCreateUseCase {
        get { self[PlaylistCreateUseCase.self] }
        set { self[PlaylistCreateUseCase.self] = newValue }
    }
    
}

extension PlaylistCreateUseCase: TestDependencyKey {
    
    static public var testValue = PlaylistCreateUseCase(
        start: XCTUnimplemented("\(PlaylistCreateUseCase.self).start")
    )
    
}
