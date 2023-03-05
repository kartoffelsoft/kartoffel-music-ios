import Foundation

public class AudioFileCreateUseCase {
    
    public var start: (String, Data) async throws -> Void
    
    init(start: @escaping (String, Data) async throws -> Void) {
        self.start = start
    }
    
}
