import CommonModels
import ComposableArchitecture

public class PlaylistReadUseCase {
    
    public var start: @Sendable (String?) async throws -> [PlaylistData]
    
    init(start: @escaping @Sendable (String?) async throws -> [PlaylistData]) {
        self.start = start
    }
    
}
