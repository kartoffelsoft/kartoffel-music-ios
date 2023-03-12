import ComposableArchitecture

public class PlaylistReadUseCase {
    
    public var start: @Sendable (String?) async throws -> [String]
    
    init(start: @escaping @Sendable (String?) async throws -> [String]) {
        self.start = start
    }
    
}
