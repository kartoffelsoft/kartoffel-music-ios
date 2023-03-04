import AppFileManager
import ComposableArchitecture

extension FileCreateUseCase: DependencyKey {
    
    static public var liveValue = FileCreateUseCase(
        start: { id, data in
            try await AppFileManager.database.createAudioFile(id: id, data: data)
        }
    )
    
}
