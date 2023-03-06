import ComposableArchitecture
import Foundation

public class AudioPlayUseCase {
    
    public var start: @Sendable (String?) async throws -> String?
    
    init(start: @escaping @Sendable (String?) async throws -> String?) {
        self.start = start
    }
    
}
