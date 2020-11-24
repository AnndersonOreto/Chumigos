//
//  SoundManager.swift
//  Loggio
//
//  Created by Annderson Packeiser Oreto on 19/11/20.
//  Copyright © 2020 Chumigos. All rights reserved.
//

import Foundation
import SpriteKit
import AVFoundation
import AudioToolbox.AudioServices

enum GameMusic: String {
    case trail = "smile.mp3"
    case game = "ukulele.mp3"
}

enum GameSound: String {
    case button = "tap.wav"
    case unit1Shot = "unit1shot.wav"
    case place = "place.wav"
    case enemyArrivedFinalNode = "arrived.mp3"
    case pick = "pick.mp3"
    case drop = "drop.mp3"
    case positive = "positive.mp3"
    case negative = "negative.mp3"
}

public class SoundManager: NSObject {
    
    // MARK: - Singleton variable
    
    static let shared = SoundManager()
    
    // MARK: - Default values
    
    // Sound volume
    let minSoundVolume: Float = 0.0
    let maxSoundVolume: Float = 1.0
    let currentSoundVolume: Float = 0.7
    
    // Music volume
    let minMusicVolume: Float = 0.0
    let maxMusicVolume: Float = 1.0
    var currentMusicVolume: Float = 0.5 {
        didSet {
            audioPlayerMusic?.volume = currentMusicVolume
        }
    }
    
    // MARK: - Variables
    
    var audioPlayerMusic: AVAudioPlayer? {
        didSet {
            if isBackgroundMusicMuted {
                audioPlayerMusic?.volume = minMusicVolume
            } else {
                audioPlayerMusic?.volume = currentMusicVolume
            }
        }
    }
    
    // List of all sounds being played in the app
    var soundList: [AVAudioPlayer] = []
    
    // Sound flags
    var isBackgroundMusicMuted: Bool = false
    var isSoundMuted: Bool = false
    var lastTimePlaySound: Date = Date()
    
    // MARK: - Init
    
    private override init() {
        super.init()
    }
    
    // MARK: - Functions
    
    /// Pause the background music.
    func pauseMusic() {
        
        if isBackgroundMusicMuted {
            isBackgroundMusicMuted = false
            audioPlayerMusic?.volume = currentMusicVolume
        } else {
            isBackgroundMusicMuted = true
            audioPlayerMusic?.volume = minMusicVolume
        }
    }
    
    /// Pause the sound music.
    func pauseSound() {
        isSoundMuted = !isSoundMuted
    }
    
    func playAppleDefaultButtonSound() {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    /// Plays a sound with given sound name.
    /// - Parameter gameSound: sound name that should be played
    func playSound(gameSound: GameSound) {
        
        if isSoundMuted { return }
        
        // Don't play sound if the interval betweens shoots is smaller than 45ms
        if lastTimePlaySound.timeIntervalSinceNow < -0.045 {
            let sound: AVAudioPlayer
            
            do {
                let url = Bundle.main.url(forAuxiliaryExecutable: gameSound.rawValue)
                sound = try AVAudioPlayer(contentsOf: url!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            // Preload the sound in buffer
            sound.prepareToPlay()
            
            // Delegate this class to AVAudioPlayer to catch when audio did finished playing
            sound.delegate = self
            
            // How many times does the sound should be played
            sound.numberOfLoops = 0
            
            // Set custom sound volume
            sound.volume = currentSoundVolume
            
            // Play the sound
            sound.play()
            
            // Add sound to a list so it can be freed when has finished playing, otherwise keep an reference to its instance so it can continue playing
            soundList.append(sound)
        }
        lastTimePlaySound = Date()
    }
    
    /// Plays a music with given music name.
    /// - Parameter gameMusic: music name that should be played
    func playMusic(gameMusic: GameMusic) {
        
        if isBackgroundMusicMuted { return }
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            // Stop last music, if it has one
            self.audioPlayerMusic?.stop()
            
            do {
                let url = Bundle.main.url(forAuxiliaryExecutable: gameMusic.rawValue)
                self.audioPlayerMusic = try AVAudioPlayer(contentsOf: url!)
            } catch let error {
                fatalError(error.localizedDescription)
            }
            
            // Preload the sound in buffer
            self.audioPlayerMusic?.prepareToPlay()
            
            // Loop the music forever until be overriden
            self.audioPlayerMusic?.numberOfLoops = -1
            
            // Play the music
            self.audioPlayerMusic?.play()
        }
    }
}

extension SoundManager: AVAudioPlayerDelegate {
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        soundList = soundList.compactMap {
            if $0 == player {
                return nil
            } else {
                return $0
            }
        }
    }
}
