import CommonModels
import ComposableArchitecture
import Foundation

public class FileListReadUseCase {
    
    public var start: @Sendable () async throws -> [MusicMetaModel]
    
    init(start: @escaping @Sendable () async throws -> [MusicMetaModel]) {
        self.start = start
    }
    
}
