//
//  MusicViewController.swift
//  UI Playground
//
//  Created by Dror Ben-Gai on 31/07/2016.
//  Copyright © 2016 Dror Ben-Gai. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

class MusicViewController: UIViewController {

    @IBOutlet weak var lblSong: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var imgPlayPause: UIImageView!

    private var mpc = MPMusicPlayerController.systemMusicPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mpc.prepareToPlay()
        
        mpc.beginGeneratingPlaybackNotifications()
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            MPMusicPlayerControllerPlaybackStateDidChangeNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) -> Void in
                self.updateUI()
            }
        )
        
        NSNotificationCenter.defaultCenter().addObserverForName(
            MPMusicPlayerControllerNowPlayingItemDidChangeNotification,
            object: nil,
            queue: nil,
            usingBlock: {
                (notification) -> Void in
                self.updateUI()
            }
        )
        
        updateUI()
    }
    
    @IBAction func tap(sender: UITapGestureRecognizer) {
        print("tap: \(getState())")
        switch mpc.playbackState {
        case .Playing:
            mpc.pause()
        case .Paused, .Stopped:
            mpc.prepareToPlay()
            mpc.play()
        default:
            break
        }
    }
    
    private func updateUI() {
        switch mpc.playbackState {
        case .Playing:
            imgPlayPause.image = UIImage(named: "pause icon")
        case .Paused, .Stopped:
            imgPlayPause.image = UIImage(named: "play icon")
        default:
            break
        }

        lblSong.text = mpc.nowPlayingItem?.title ?? ""
        lblArtist.text = mpc.nowPlayingItem?.artist ?? ""
        lblAlbum.text = mpc.nowPlayingItem?.albumTitle ?? ""
    }
    
    private func getState() -> String? {
        switch mpc.playbackState {
        case .Interrupted:
            return "Interrupted"
        case .Paused:
            return "Paused"
        case .Playing:
            return "Playing"
        case .SeekingBackward:
            return "SeekingBackward"
        case .SeekingForward:
            return "SeekingForward"
        case .Stopped:
            return "Stopped"
        }
    }
}
