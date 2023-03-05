import Foundation

public class AudioFileDeleteUseCase {
    
    public var start: (String) async throws -> Void
    
    init(start: @escaping (String) async throws -> Void) {
        self.start = start
    }
    
}
