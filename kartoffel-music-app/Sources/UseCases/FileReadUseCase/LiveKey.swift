import AudioFileManager
import ComposableArchitecture

extension FileReadUseCase: DependencyKey {
    
    static public var liveValue = FileReadUseCase(
        start: { id in
            return try await AudioFileManager.database.readAudioMetaData(id: id)
        }
    )
    
}
