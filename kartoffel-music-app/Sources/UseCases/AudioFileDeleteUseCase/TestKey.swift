import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioFileDeleteUseCase: AudioFileDeleteUseCase {
        get { self[AudioFileDeleteUseCase.self] }
        set { self[AudioFileDeleteUseCase.self] = newValue }
    }
    
}

extension AudioFileDeleteUseCase: TestDependencyKey {
    
    static public var testValue = AudioFileDeleteUseCase(
        start: XCTUnimplemented("\(AudioFileDeleteUseCase.self).start")
    )
    
}
