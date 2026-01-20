import Foundation
internal import Combine
import AVFoundation

class MusicManager: ObservableObject {
    static let shared = MusicManager()
    private var audioPlayer: AVAudioPlayer?
    
    @Published var volume: Double = UserDefaults.standard.double(forKey: "musicVolume") {
        didSet {
            audioPlayer?.volume = Float(volume)
            UserDefaults.standard.set(volume, forKey: "musicVolume")
        }
    }
    
    private init() {
        if UserDefaults.standard.object(forKey: "musicVolume") == nil {
            self.volume = 0.5
        }
        setupPlayer()
    }
    
    func setupPlayer() {
        guard let url = Bundle.main.url(forResource: "background", withExtension: "mp3") else {
            print("Background music file not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.numberOfLoops = -1 // Loop indefinitely
            audioPlayer?.volume = Float(volume)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Could not create audio player: \(error)")
        }
    }
    
    func play() {
        audioPlayer?.play()
    }
    
    func stop() {
        audioPlayer?.stop()
    }
}
