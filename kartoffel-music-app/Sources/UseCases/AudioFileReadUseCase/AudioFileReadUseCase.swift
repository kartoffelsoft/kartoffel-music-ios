import CommonModels
import ComposableArchitecture
import Foundation

public class AudioFileReadUseCase {
    
    public var start: @Sendable (String) async throws -> AudioMetaData?
    
    init(start: @escaping @Sendable (String) async throws -> AudioMetaData?) {
        self.start = start
    }
    
}
