//
//  RecorderViewController.swift
//  violinista
//
//  Created by Srinidhi Sasidharan on 5/22/24.
//

import UIKit
import AudioKit
import AudioKitEX
import AudioKitUI
import AVFoundation
import AudioToolbox
import SoundpipeAudioKit


class Recorder: ObservableObject, HasAudioEngine{
    let engine = AudioEngine()
    var recorder: NodeRecorder?
    let player = AudioPlayer()
    var silencer: Fader?
    let mixer = Mixer()
    var isRecording = false
    var isPlaying = false
    var tracker: PitchTap!
    
    func recordData(){
        if isRecording {
            do{
                try recorder?.record()
            }catch let err{
                print("isRecording error ",err)
            }
        }
        else {
             recorder?.stop()
        }
        
       
    }
    func playingData(){
        if isPlaying {
            if let file = recorder?.audioFile {
                try? player.load(file: file)
                player.play()
            }
            else{
                player.stop()
            }
        }
    }
    
    init(){
        guard let input = engine.input else{
            fatalError()
        }
        
        do{
            recorder = try NodeRecorder(node: input)
        }catch let err{
            fatalError("error \(err)")
        }
        let silencer = Fader(input, gain:0)
        player.volume = 2
        self.silencer = silencer
        mixer.addInput(silencer)
        mixer.addInput(player)
        engine.output = mixer
        tracker = PitchTap(input){
            pitch,amp in DispatchQueue.main.async{
                print("pitch and amp",pitch[0],amp[0])
            }
        }
        tracker.start()
        
        do {
                  try engine.start()
              } catch let error{
                  fatalError("Failed to start audio engine: \(error)")
              }
    }
    
    
}
