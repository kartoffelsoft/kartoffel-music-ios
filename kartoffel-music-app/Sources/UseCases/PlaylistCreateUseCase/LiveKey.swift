import ComposableArchitecture
import PlaylistManager

extension PlaylistCreateUseCase: DependencyKey {
    
    static public var liveValue = PlaylistCreateUseCase(
        start: { name in

        }
    )
    
}
