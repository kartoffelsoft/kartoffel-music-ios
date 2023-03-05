import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioFileReadAllUseCase: AudioFileReadAllUseCase {
        get { self[AudioFileReadAllUseCase.self] }
        set { self[AudioFileReadAllUseCase.self] = newValue }
    }
    
}

extension AudioFileReadAllUseCase: TestDependencyKey {
    
    static public var testValue = AudioFileReadAllUseCase(
        start: XCTUnimplemented("\(AudioFileReadAllUseCase.self).start")
    )
    
}
