//
//  IVSPlayerController.swift
//  FinalDemo
//
//  Created by Jake on 3/26/22.
//

import Foundation
import AmazonIVSPlayer

class IVSPlayerController: UIViewController {
    // Connected in Interface Builder
    @IBOutlet var playerView: IVSPlayerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        //Adds an observer for then the user goes home to pause the stream
        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
        
        //Play the live stream
        self.playVideo(url: URL(string: "https://c7de521ac11f.us-west-2.playback.live-video.net/api/video/v1/us-west-2.533032379413.channel.pW8qbswW0rTw.m3u8")!)
    }

    //Pause the video when the app is closed
    @objc func applicationDidEnterBackground(_ notification: NSNotification) {
        playerView?.player?.pause()
    }

    // Plays a video with a given URL on playerView
    func playVideo(url videoURL: URL) {
        let player = IVSPlayer()
        player.delegate = self
        print("Setting playerView")
        playerView.player = player
        print("Loading stream")
        player.load(videoURL)
        print("done!")
    }
}

extension IVSPlayerController: IVSPlayer.Delegate {
    func player(_ player: IVSPlayer, didChangeState state: IVSPlayer.State) {
        if state == .ready {
            player.play()
        }
    }
}
