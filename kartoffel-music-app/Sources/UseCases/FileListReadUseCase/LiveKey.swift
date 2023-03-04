import AppFileManager
import ComposableArchitecture

extension FileListReadUseCase: DependencyKey {
    
    static public var liveValue = FileListReadUseCase(
        start: {
            return try await AppFileManager.database.readAllAudioMetaData()
        }
    )
    
}
