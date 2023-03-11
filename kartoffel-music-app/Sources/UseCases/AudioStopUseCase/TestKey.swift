import ComposableArchitecture
import XCTestDynamicOverlay

extension DependencyValues {
    
    public var audioStopUseCase: AudioStopUseCase {
        get { self[AudioStopUseCase.self] }
        set { self[AudioStopUseCase.self] = newValue }
    }
    
}

extension AudioStopUseCase: TestDependencyKey {
    
    static public var testValue = AudioStopUseCase(
        start: XCTUnimplemented("\(AudioStopUseCase.self).start")
    )
    
}
