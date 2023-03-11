import AudioPlayer
import ComposableArchitecture

extension AudioStopUseCase: DependencyKey {
    
    static public var liveValue = AudioStopUseCase(
        start: {
            try await AudioPlayer.shared.stop()
        }
    )
    
}

