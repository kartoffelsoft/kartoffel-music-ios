import AudioFileManager
import ComposableArchitecture

extension FileListReadUseCase: DependencyKey {
    
    static public var liveValue = FileListReadUseCase(
        start: {
            return try await AudioFileManager.database.readAllAudioMetaData()
        }
    )
    
}
