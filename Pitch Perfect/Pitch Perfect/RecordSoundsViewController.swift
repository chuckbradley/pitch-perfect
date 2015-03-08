//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Chuck Bradley on 3/4/15.
//  Copyright (c) 2015 FreedomMind. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordingButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        stopButton.hidden=true
        recordingButton.enabled=true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingLabel.hidden=false
        stopButton.hidden=false
        recordingButton.enabled=false

        // get the directory to store the recording
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String

        // get date for unique naming
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        // create array with path and name to assign to the filePath:NSURL
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        // get shared instance of AVAudioSession and set its category to play and record:
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        // assign instance of AVAudioRecorder with the defined filePath
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)

        // define this class as a delegate so it can customize the audioRecorderDidFinishRecording handler
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.record()
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if(flag) {
            // if successful, save the recorded audio
            recordedAudio=RecordedAudio()
            recordedAudio.filePathUrl=recorder.url
            recordedAudio.title=recorder.url.lastPathComponent
            
            // perform the segue to the play sounds scene and specify the recorded audio as the sender
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            // unsuccesful recording
            println("The recording was not successful")
            stopButton.hidden=true
            recordingButton.enabled=true
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // if about to segue resulting from stop recording, send the recorded audio to the play sounds VC
        if(segue.identifier=="stopRecording"){
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as PlaySoundsViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }

    
    @IBAction func stopRecording(sender: UIButton) {
        recordingLabel.hidden = true
        stopButton.hidden=true
        // stop recording the user's voice
        audioRecorder.stop()
        // turn off the shared instance of the audio session
        AVAudioSession.sharedInstance().setActive(false, error: nil)
    }

    
}

