import AVFoundation
import ComposableArchitecture

extension AudioPlayUseCase: DependencyKey {
    
    static public var liveValue = AudioPlayUseCase(
        start: { id in
            await player.pause()
            
            if let observer = observer {
                player.removeTimeObserver(observer)
            }
            observer = nil
            
            guard let id = id else {
                return nil
            }
            
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                
                let url = FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
                )[0].appendingPathComponent("\(id).mp3")
                
                let item = AVPlayerItem(url: url)
                player.replaceCurrentItem(with: item)
                
                let interval = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

                observer = player.addPeriodicTimeObserver(forInterval: interval, queue: .main) { elapsedTime in
                    let elapsedTimeSecondsFloat = CMTimeGetSeconds(elapsedTime)
                    print("# ElapsedTimeSeconds: ", elapsedTimeSecondsFloat)
                }

                await player.play()
            } catch {
                print("#: Something went wrong")
                return nil
            }
            
            return id
        }
    )
    
}

//private var player: AVAudioPlayer?

private var player: AVPlayer = AVPlayer()
//{
//    let player = AVPlayer()
//
////        print("#: ", elapsedTimeSecondsFloat)
//////      let totalTimeSecondsFloat = CMTimeGetSeconds(self?.player.currentItem?.duration ?? CMTimeMake(value: 1, timescale: 1))
//////      guard
//////        !elapsedTimeSecondsFloat.isNaN,
//////        !elapsedTimeSecondsFloat.isInfinite,
//////        !totalTimeSecondsFloat.isNaN,
//////        !totalTimeSecondsFloat.isInfinite
//////      else { return }
//////      self?.elapsedTimeSecondsFloat = elapsedTimeSecondsFloat
//////      self?.totalTimeSecondsFloat = totalTimeSecondsFloat
////    }
//
//    return player
//}()

private var observer: Any?
