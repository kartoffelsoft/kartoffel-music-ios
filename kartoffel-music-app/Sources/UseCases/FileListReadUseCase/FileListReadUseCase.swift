import CommonModels
import ComposableArchitecture
import Foundation

public class FileListReadUseCase {
    
    public var start: @Sendable () async throws -> [AudioMetaData]
    
    init(start: @escaping @Sendable () async throws -> [AudioMetaData]) {
        self.start = start
    }
    
}
