import CommonModels
import ComposableArchitecture
import Foundation

public class FileListReadUseCase {
    
    public var start: @Sendable () async throws -> [AudioFileMetaData]
    
    init(start: @escaping @Sendable () async throws -> [AudioFileMetaData]) {
        self.start = start
    }
    
}
