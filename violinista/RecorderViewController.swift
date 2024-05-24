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



class RecorderViewController: UIViewController{
    var rec:Recorder?
    @IBAction func recordMe(_ sender: Any) {
        if (sender as AnyObject).titleLabel?.text == "RecordMe"{
            print("Inside Recorder")
            rec?.isRecording = true
            (sender as AnyObject).setTitle("Stop", for: .normal)
            
        }
        else{
            rec?.isRecording = false
            (sender as AnyObject).setTitle("RecordMe", for: .normal)
        }
        rec?.recordData()
    }
    
    @IBAction func playMe(_ sender: Any) {
        if let button = sender as? UIButton {
                    if button.titleLabel?.text == "PlayMe" {
                        print("Preparing to play audio")
                        rec?.isPlaying = true
                        button.setTitle("Stop", for: .normal)
                    } else {
                        print("Stopping playback")
                        rec?.isPlaying=false
                        button.setTitle("PlayMe", for: .normal)
                    }
            rec?.playingData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rec = Recorder()
    }
    
}
