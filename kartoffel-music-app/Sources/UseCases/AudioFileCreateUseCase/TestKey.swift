import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioFileCreateUseCase: AudioFileCreateUseCase {
        get { self[AudioFileCreateUseCase.self] }
        set { self[AudioFileCreateUseCase.self] = newValue }
    }
    
}

extension AudioFileCreateUseCase: TestDependencyKey {
    
    static public var testValue = AudioFileCreateUseCase(
        start: XCTUnimplemented("\(AudioFileCreateUseCase.self).start")
    )
    
}
