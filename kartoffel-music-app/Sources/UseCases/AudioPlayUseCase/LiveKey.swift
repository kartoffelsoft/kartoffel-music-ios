import AVFoundation
import ComposableArchitecture

extension AudioPlayUseCase: DependencyKey {
    
    static public var liveValue = AudioPlayUseCase(
        start: { id in
            if let player = player, player.isPlaying {
                player.stop()
            }
            
            guard let id = id else { return nil }
            
            do {
                try AVAudioSession.sharedInstance().setMode(.default)
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
                
                let url = FileManager.default.urls(
                    for: .documentDirectory,
                    in: .userDomainMask
                )[0].appendingPathComponent("\(id).mp3")
                
                player = try AVAudioPlayer(contentsOf: url)
                
                guard let player = player else {
                    return nil
                }
                
                player.play()
            } catch {
                print("#: Something went wrong")
                return nil
            }
            
            return id
        }
    )
    
}

private var player: AVAudioPlayer?
