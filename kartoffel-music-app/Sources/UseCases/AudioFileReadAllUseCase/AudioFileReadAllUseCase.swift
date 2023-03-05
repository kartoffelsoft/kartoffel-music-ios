import CommonModels
import ComposableArchitecture
import Foundation

public class AudioFileReadAllUseCase {
    
    public var start: @Sendable () async throws -> [AudioMetaData]
    
    init(start: @escaping @Sendable () async throws -> [AudioMetaData]) {
        self.start = start
    }
    
}
