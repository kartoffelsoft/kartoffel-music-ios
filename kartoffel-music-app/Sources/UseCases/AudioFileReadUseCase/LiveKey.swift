import AudioFileManager
import ComposableArchitecture

extension AudioFileReadUseCase: DependencyKey {
    
    static public var liveValue = AudioFileReadUseCase(
        start: { id in
            return try await AudioFileManager.database.readAudioMetaData(id: id)
        }
    )
    
}
