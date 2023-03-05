import AudioFileManager
import ComposableArchitecture

extension AudioFileCreateUseCase: DependencyKey {
    
    static public var liveValue = AudioFileCreateUseCase(
        start: { id, data in
            try await AudioFileManager.database.createAudioFile(id: id, data: data)
        }
    )
    
}
