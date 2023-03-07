
public enum PlayState: Equatable, Hashable {
    case stop
    case playing(progress: Int)
}
