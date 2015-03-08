//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chuck Bradley on 3/5/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // sets the sound to always play on the Speakers
        let session = AVAudioSession.sharedInstance()
        var error: NSError?
        session.setCategory(AVAudioSessionCategoryPlayback, error: &error)
        session.overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker, error: &error)
        session.setActive(true, error: &error)
        
        // assign instance of AVAudioEngine for the sound effects
        audioEngine = AVAudioEngine()
        // assign instance of AVAudioFile referencing received audio
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        playAudioAtRate(2)
    }

    
    @IBAction func playSlowAudio(sender: UIButton) {
        playAudioAtRate(0.5)
    }


    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
    }

    @IBAction func playDarthVaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }

    // TODO: combine the rate and pitch functions?
    
    // plays audio at specified rate
    func playAudioAtRate(rate: Float) {
        audioEngine.stop()
        audioEngine.reset()
        
        // basic audio player node
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // a AVAudioUnitTimePitch instance for a rate adjustment
        var changeRateEffect = AVAudioUnitTimePitch()
        changeRateEffect.rate = rate
        audioEngine.attachNode(changeRateEffect)
        
        // connect nodes basic > effect > output
        audioEngine.connect(audioPlayerNode, to: changeRateEffect, format: nil)
        audioEngine.connect(changeRateEffect, to: audioEngine.outputNode, format: nil)
        
        // set the received audio to play as adjusted when called
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)

        audioPlayerNode.play()
        
    }

    
    // plays audio at specified pitch
    func playAudioWithVariablePitch(pitch: Float){
        audioEngine.stop()
        audioEngine.reset()
        
        // basic audio player node
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        // a AVAudioUnitTimePitch instance for a pitch adjustment
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        // connect nodes basic > effect > output
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        // set the received audio to play as adjusted when called
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    
    
    @IBAction func stopAudio(sender: UIButton) {
        audioEngine.stop()
    }

}
