import AudioFileManager
import ComposableArchitecture

extension FileCreateUseCase: DependencyKey {
    
    static public var liveValue = FileCreateUseCase(
        start: { id, data in
            try await AudioFileManager.database.createAudioFile(id: id, data: data)
        }
    )
    
}
