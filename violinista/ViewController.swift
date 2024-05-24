//
//  ViewController.swift
//  violinista
//
//  Created by Srinidhi Sasidharan on 5/18/24.
//

import UIKit
import AVFoundation
class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {
    

  
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var recordingSession: AVAudioSession!
    
    @IBAction func record(_ sender: Any) {
        if (sender as AnyObject).titleLabel?.text == "Record"{
            print("Inside Recorder")
            audioRecorder.record()
            (sender as AnyObject).setTitle("Stop", for: .normal)
            
        }
        else{
            audioRecorder.stop()
            (sender as AnyObject).setTitle("Record", for: .normal)
        }
    }
    
    @IBAction func playAudio(_ sender: Any) {
        if let button = sender as? UIButton {
                    if button.titleLabel?.text == "play" {
                        print("Preparing to play audio")
                        preparePlayer()
                        if audioPlayer != nil {
                            audioPlayer.play()
                            button.setTitle("Stop", for: .normal)
                        }
                    } else {
                        print("Stopping playback")
                        if audioPlayer != nil {
                            audioPlayer.stop()
                            button.setTitle("play", for: .normal)
                        }
                    }
                }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecorder()
    }
    func setupRecorder() {
            recordingSession = AVAudioSession.sharedInstance()
            
            do {
                try recordingSession.setCategory(AVAudioSession.Category.record)
                try recordingSession.setActive(true)
                startRecordingSetup()
            } catch {
                print("Failed to set up recording session: \(error.localizedDescription)")
            }
        }
        
        func startRecordingSetup() {
            let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            let documentsDirectory = paths[0]
            let audioFilename = documentsDirectory.appendingPathComponent("audio.m4a")
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatAppleLossless),
                AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
                AVEncoderBitRateKey: 320000,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100.0
            ] as [String : Any]
            
            do {
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder.delegate = self
                audioRecorder.prepareToRecord()
                print("Audio Recorder prepared at path: \(audioFilename)")
            } catch {
                print("AVAudioRecorder error: \(error.localizedDescription)")
                audioRecorder = nil
            }
        }
//    func setupRecorder(){
//        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let documentsDirectory = paths[0]
//        print(paths[0])
//        
//        let audioFilename = documentsDirectory.appendingPathComponent("audio.m4a")
//        
//        let settings = [AVFormatIDKey: Int(kAudioFormatAppleLossless),
//                        AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
//                        AVEncoderBitRateKey: 320000,
//                        AVNumberOfChannelsKey: 2,
//                      AVSampleRateKey:44100.0] as [String : Any]
//        
//        var error: NSError?
//        
//        do{
//            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
//            print("Audio Recorded")
//        }catch let error1 as NSError{
//            error = error1
//            audioRecorder = nil
//        }
//        
//        if let err = error{
//            print("AVAudioRecorder error: \(err.localizedDescription)")
//        }
//        else{
//            audioRecorder.delegate = self
//            audioRecorder.prepareToRecord()
//        }
//        
//    }
    
    func preparePlayer(){
        recordingSession = AVAudioSession.sharedInstance()
                do{
                    try recordingSession.setCategory(AVAudioSession.Category.playback)
                }catch{
                    print("preparePlayer recorder error")
                }
        var error: NSError?
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: getFileURL())
            audioPlayer.delegate = self
            audioPlayer.volume = 1.0
        }catch let error1 as NSError{
            error = error1
            audioPlayer = nil
        }
        
        if let err = error{
            print("AVPlayerError: \(err.localizedDescription)")
        }
    }

    func getFileURL() -> URL{
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("audio.m4a")
        if fileManager.fileExists(atPath:"audio.m4a" ) {
            print("File exists")
        } else {
            print("File does not exist")
        }
        print("##########soundURL",soundURL)
        return soundURL
    }

}

