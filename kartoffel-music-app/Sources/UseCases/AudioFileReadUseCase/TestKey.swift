import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioFileReadUseCase: AudioFileReadUseCase {
        get { self[AudioFileReadUseCase.self] }
        set { self[AudioFileReadUseCase.self] = newValue }
    }
    
}

extension AudioFileReadUseCase: TestDependencyKey {
    
    static public var testValue = AudioFileReadUseCase(
        start: XCTUnimplemented("\(AudioFileReadUseCase.self).start")
    )
    
}
