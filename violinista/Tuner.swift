//
//  Tuner.swift
//  violinista
//
//  Created by Srinidhi Sasidharan on 5/23/24.
//

import UIKit
import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import AudioToolbox
import SoundpipeAudioKit

class Tuner: HasAudioEngine{
    
    var engine = AudioEngine()
    var pitch: Float = 0.0
    var amplitude: Float = 0.0
    var noteNameWithSharps = "-"
    var noteNameWithFlats = "-"
    
    let initialDevice: Device
    
    let mic: AudioEngine.InputNode
    let tappableNodeA: Fader
    let tappableNodeB: Fader
    let tappableNodeC: Fader
    let silence: Fader

    var tracker: PitchTap!
    
    let noteFrequencies = [16.35, 17.32, 18.35, 19.45, 20.6, 21.83, 23.12, 24.5, 25.96, 27.5, 29.14, 30.87]
    let noteNamesWithSharps = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B"]
    let noteNamesWithFlats = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B"]
    
    init(){
        print("tuner")
        guard let input = engine.input else {fatalError()}
        
        guard let device = engine.inputDevice else {fatalError()}
        
        initialDevice = device
        
        mic = input
        tappableNodeA = Fader(mic)
        tappableNodeB = Fader(tappableNodeA)
        tappableNodeC = Fader(tappableNodeB)
        silence = Fader(tappableNodeC, gain: 0)
        engine.output = silence
        
        tracker = PitchTap(mic){ [self] pitch, amp in
            DispatchQueue.main.async {
                self.update(pitch[0],amp[0])
            }
            
        }
        do {
            try engine.start()
            tracker.start()  
        } catch {
            print("Failed to start engine or tracker: \(error)")
        }

    }
    
    func update(_ pitch: AUValue, _ amp: AUValue){
        guard amp > 0.1 else {return}
        
        self.pitch = pitch
        amplitude = amp
        
        var freq = pitch
        print("before freq",freq)
        while freq > Float(noteFrequencies[noteFrequencies.count - 1]){
            freq /= 2.0
        }
        
        while freq < Float(noteFrequencies[0]){
            freq *= 2.0
        }
        print("after freq",freq)
        var minDistance: Float = 10000.0
        var index = 0
        
        for possibleIndex in 0 ..< noteFrequencies.count{
            let distance = fabsf(Float(noteFrequencies[possibleIndex]) - freq)
            if distance < minDistance{
                index = possibleIndex
                minDistance = distance
            }
        }
        
        let octave = Int(log2f(pitch / freq))
                noteNameWithSharps = "\(noteNamesWithSharps[index])\(octave)"
                noteNameWithFlats = "\(noteNamesWithFlats[index])\(octave)"
        
        print("pitch = \(pitch), sharps = \(noteNameWithSharps), flats = \(noteNameWithFlats)")
    }
    
    
}
