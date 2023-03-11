import AVFoundation
import Combine

public class AudioPlayer {
    
    public static let shared = AudioPlayer()
    
    public enum Event: Equatable {
        case start(String, Double)
        case playing(String, Double, Double)
        case finish(String)
    }
    
    private let player: AVPlayer
    private let directoryUrl: URL
    
    private var elapsedTimeObserver: Any?
    
    private init() {
        self.player = AVPlayer()
        self.directoryUrl = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
    }

    public func play(id: String) -> AsyncThrowingStream<Event, Error> {
        .init { continuation in
            Task {
                do {
                    try AVAudioSession.sharedInstance().setCategory(.playback)
                    
                    let url = directoryUrl.appendingPathComponent("\(id).mp3")
                    let item = AVPlayerItem(url: url)
                    player.replaceCurrentItem(with: item)
                    
                    if let elapsedTimeObserver = elapsedTimeObserver {
                        player.removeTimeObserver(elapsedTimeObserver)
                    }
                    
                    let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                    
                    elapsedTimeObserver = player.addPeriodicTimeObserver(
                        forInterval: interval,
                        queue: .main) { [weak self] elapsedTime in
                        if let currentItem = self?.player.currentItem {
                            let durationInSeconds = CMTimeGetSeconds(currentItem.asset.duration)
                            let elapsedTimeInSeconds = CMTimeGetSeconds(elapsedTime)
                            continuation.yield(
                                .playing(id, durationInSeconds, elapsedTimeInSeconds)
                            )
                            
                            if 1 > (durationInSeconds - elapsedTimeInSeconds) {
                                continuation.yield(.finish(id))
                                continuation.finish()
                            }
                        }
                    }

                    await player.play()
                    
                    if let currentItem = player.currentItem {
                        continuation.yield(
                            .start(id, CMTimeGetSeconds(currentItem.asset.duration))
                        )
                    }
                } catch(let e) {
                    continuation.finish(throwing: e)
                }
            }
        }
        
    }
    
    public func stop() async throws {
        if let elapsedTimeObserver = elapsedTimeObserver {
            player.removeTimeObserver(elapsedTimeObserver)
        }
        elapsedTimeObserver = nil
        await player.pause()
    }

}
