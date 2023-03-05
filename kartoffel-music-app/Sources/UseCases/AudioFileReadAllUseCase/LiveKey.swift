import AudioFileManager
import ComposableArchitecture

extension AudioFileReadAllUseCase: DependencyKey {
    
    static public var liveValue = AudioFileReadAllUseCase(
        start: {
            return try await AudioFileManager.database.readAudioMetaDataAll()
        }
    )
    
}
