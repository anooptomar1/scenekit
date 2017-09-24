//
//  SoundPlayer.swift
//  Piano
//
//  Created by Ibram Uppal on 4/3/15.
//  Copyright (c) 2015 Ibram Uppal. All rights reserved.
//

import UIKit
import AVFoundation

class KeyStroke: AVAudioPlayer, AVAudioPlayerDelegate {
    
    var C: AVAudioPlayer?
    var CSharp: AVAudioPlayer?
    var D: AVAudioPlayer?
    var DSharp: AVAudioPlayer?
    var E: AVAudioPlayer?
    var F: AVAudioPlayer?
    var FSharp: AVAudioPlayer?
    var G: AVAudioPlayer?
    var GSharp: AVAudioPlayer?
    var A: AVAudioPlayer?
    var ASharp: AVAudioPlayer?
    var B: AVAudioPlayer?
    var CHi: AVAudioPlayer?
    
    override init() {
     super.init()
        
        C = returnSound(name: "C")!
        CSharp = returnSound(name: "CSharp")!
        D = returnSound(name: "D")!
        DSharp = returnSound(name: "DSharp")!
        E = returnSound(name: "E")!
        F = returnSound(name: "F")!
        FSharp = returnSound(name: "FSharp")!
        G = returnSound(name: "G")!
        GSharp = returnSound(name: "GSharp")!
        A = returnSound(name: "A")!
        ASharp = returnSound(name: "ASharp")!
        B = returnSound(name: "B")!
        CHi = returnSound(name: "CHi")!
    
    }
    
    func playKey(keyName: String) {
        
        switch keyName {
        case "C":
            playSound(soundPlayer: C)
        case "CSharp":
            playSound(soundPlayer:CSharp)
        case "D":
            playSound(soundPlayer:D)
        case "DSharp":
            playSound(soundPlayer:DSharp)
        case "E":
            playSound(soundPlayer:E)
        case "F":
            playSound(soundPlayer:F)
        case "FSharp":
            playSound(soundPlayer:FSharp)
        case "G":
            playSound(soundPlayer:G)
        case "GSharp":
            playSound(soundPlayer:GSharp)
        case "A":
            playSound(soundPlayer:A)
        case "ASharp":
            playSound(soundPlayer:ASharp)
        case "B":
            playSound(soundPlayer:B)
        case "CHi":
            playSound(soundPlayer:CHi)
        default:
            break;
        }
        
    }
    
    func returnSound(name:String) -> AVAudioPlayer? {
        let Cpath = Bundle.main.path(forResource: "KeySounds/\(name)Key", ofType: "wav")
        if let path = Cpath {
            let CUrlPath = NSURL(fileURLWithPath: path)
            do {
                return try AVAudioPlayer(contentsOf: CUrlPath as URL)
            } catch _ {
                return nil
            }
        } else {
            return nil
        }
    }
    
    func playSound(soundPlayer: AVAudioPlayer?) {
        if let sound = soundPlayer{
            if sound.isPlaying {
                sound.stop()
                sound.currentTime = 0
                sound.play(atTime: sound.deviceCurrentTime)
            } else {
                sound.play()
            }
        }
    }
    
}

