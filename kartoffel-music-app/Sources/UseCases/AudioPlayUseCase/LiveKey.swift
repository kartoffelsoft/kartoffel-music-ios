import AudioPlayer
import ComposableArchitecture

extension AudioPlayUseCase: DependencyKey {
    
    static public var liveValue = AudioPlayUseCase(
        start: { id in
            .init { continuation in
                Task {
                    do {
                        for try await event in AudioPlayer.shared.play(id: id) {
                            switch event {
                            case let .start(id, duration):
                                continuation.yield(.start(id, duration))
                            case let .playing(id, duration, elapsed):
                                continuation.yield(.playing(id, duration, elapsed))
                            case let .finish(id):
                                continuation.yield(.finish(id))
                                continuation.finish()
                            }
                        }
                        continuation.finish()
                    } catch(let e){
                        continuation.finish(throwing: e)
                    }
                }
            }
        }
    )
    
}
