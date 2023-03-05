import ComposableArchitecture
import Foundation

public class AudioPlayUseCase {
    
    public var start: @Sendable (String) async throws -> Void
    
    init(start: @escaping @Sendable (String) async throws -> Void) {
        self.start = start
    }
    
}
