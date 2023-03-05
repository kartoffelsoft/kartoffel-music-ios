import ComposableArchitecture
import AVFoundation

extension AudioPlayUseCase: DependencyKey {
    
    static public var liveValue = AudioPlayUseCase(
        start: { id in
            if let player = player, player.isPlaying {
                player.stop()
            } else {
                do {
                    try AVAudioSession.sharedInstance().setMode(.default)
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                    try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                    
                    print("@2")
                    
                    let url = FileManager.default.urls(
                            for: .documentDirectory,
                            in: .userDomainMask
                        )[0].appendingPathComponent("\(id).mp3")
             
                    player = try AVAudioPlayer(contentsOf: url)
                    
                    guard let player = player else {
                        return
                    }
                    
                    player.play()
                } catch {
                    print("#: Something went wrong")
                }
            }
        }
    )
    
}

private var player: AVAudioPlayer?
