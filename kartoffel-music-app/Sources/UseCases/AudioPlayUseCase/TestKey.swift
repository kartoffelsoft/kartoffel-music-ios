import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioPlayUseCase: AudioPlayUseCase {
        get { self[AudioPlayUseCase.self] }
        set { self[AudioPlayUseCase.self] = newValue }
    }
    
}

extension AudioPlayUseCase: TestDependencyKey {
    
    static public var testValue = AudioPlayUseCase(
        start: XCTUnimplemented("\(AudioPlayUseCase.self).start")
    )
    
}
