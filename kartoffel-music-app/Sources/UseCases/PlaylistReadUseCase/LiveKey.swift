import PlaylistManager
import ComposableArchitecture

extension PlaylistReadUseCase: DependencyKey {
    
    static public var liveValue = PlaylistReadUseCase(
        start: { id in
            try await PlaylistManager.shared.read()
            return []
        }
    )
    
}
