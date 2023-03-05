import AudioFileManager
import ComposableArchitecture

extension AudioFileDeleteUseCase: DependencyKey {
    
    static public var liveValue = AudioFileDeleteUseCase(
        start: { id in
            try await AudioFileManager.database.deleteAudioFile(id: id)
        }
    )
    
}
