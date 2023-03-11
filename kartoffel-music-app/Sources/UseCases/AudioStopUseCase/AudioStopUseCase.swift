import ComposableArchitecture
import Foundation

public class AudioStopUseCase {
    
    public var start: () async throws -> Void
    
    init(start: @escaping () async throws -> Void) {
        self.start = start
    }
    
}
