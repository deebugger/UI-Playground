//
//  AudioViewController.swift
//  UI Playground
//
//  Created by Dror Ben-Gai on 31/07/2016.
//  Copyright © 2016 Dror Ben-Gai. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class AudioViewController: UIViewController, AVAudioPlayerDelegate {

    @IBOutlet weak var btnPlayPause: UIButton!
    @IBOutlet weak var sliderLocation: UISlider!
    
    @IBOutlet weak var btnSystemPlayPause: UIButton!
    
    private var tinyDancerPlayer: AVAudioPlayer = AVAudioPlayer()
    
    private var mpcontroller = MPMusicPlayerController.systemMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let audioPath = NSBundle.mainBundle().pathForResource("Tiny Dancer", ofType: "mp3")!
        try! tinyDancerPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: audioPath))
        tinyDancerPlayer.delegate = self
        tinyDancerPlayer.volume = 0.5
        sliderLocation.value = 0
        sliderLocation.maximumValue = Float(tinyDancerPlayer.duration)
        _ = NSTimer.scheduledTimerWithTimeInterval(
            0.1,
            target: self,
            selector: #selector(updateLocation),
            userInfo: nil,
            repeats: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        tinyDancerPlayer.pause()
        updateUI()
    }
    
    @IBAction func touchSystemPlayPause(sender: UIButton) {
        switch mpcontroller.playbackState {
        case .Playing:
            mpcontroller.pause()
            btnSystemPlayPause.setTitle("Play", forState: .Normal)
        case .Paused, .Stopped:
            mpcontroller.play()
            btnSystemPlayPause.setTitle("Pause", forState: .Normal)
        default:
            break
        }
        updateUI()
    }
    
    @IBAction func touchRewind(sender: UIButton) {
        tinyDancerPlayer.currentTime = 0
        updateUI()
    }
    
    @IBAction func touchPlayPause(sender: UIButton) {
        if tinyDancerPlayer.playing {
            tinyDancerPlayer.pause()
        } else {
            tinyDancerPlayer.play()
        }
        updateUI()
    }
    
    @IBAction func touchStop(sender: UIButton) {
        tinyDancerPlayer.stop()
        tinyDancerPlayer.currentTime = 0
        updateUI()
    }
    
    @IBAction func changeVolume(sender: UISlider) {
        tinyDancerPlayer.volume = sender.value
    }
    
    @IBAction func changeLocation(sender: UISlider) {
        tinyDancerPlayer.currentTime = NSTimeInterval(sender.value)
    }
    
    @objc private func updateLocation() {
        sliderLocation.setValue(Float(tinyDancerPlayer.currentTime), animated: true)
    }
    
    // MARK: AVPlayerDelegate
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        updateUI()
    }

    private func updateUI() {
        if tinyDancerPlayer.playing {
            btnPlayPause.setTitle("Pause", forState: .Normal)
        } else {
            btnPlayPause.setTitle("Play", forState: .Normal)
        }
    }
}
