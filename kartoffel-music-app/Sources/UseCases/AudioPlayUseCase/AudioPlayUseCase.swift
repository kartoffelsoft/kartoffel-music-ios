import ComposableArchitecture
import Foundation

public class AudioPlayUseCase {
    
    public var start: @Sendable (_ id: String) -> AsyncThrowingStream<Event, Error>

    public enum Event: Equatable {
        case start(String, Double)
        case playing(String, Double, Double)
        case finish(String)
    }

    init(
        start: @escaping @Sendable (_ id: String) -> AsyncThrowingStream<Event, Error>
    ) {
        self.start = start
    }
    
}
