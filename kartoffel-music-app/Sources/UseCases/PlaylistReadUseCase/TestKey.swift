import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var playlistReadUseCase: PlaylistReadUseCase {
        get { self[PlaylistReadUseCase.self] }
        set { self[PlaylistReadUseCase.self] = newValue }
    }
    
}

extension PlaylistReadUseCase: TestDependencyKey {
    
    static public var testValue = PlaylistReadUseCase(
        start: XCTUnimplemented("\(PlaylistReadUseCase.self).start")
    )
    
}
