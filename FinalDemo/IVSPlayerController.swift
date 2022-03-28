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

        NotificationCenter.default.addObserver(self,
            selector: #selector(applicationDidEnterBackground(_:)),
            name: UIApplication.didEnterBackgroundNotification,
            object: nil)
    }

    @objc func applicationDidEnterBackground(_ notification: NSNotification) {
        playerView?.player?.pause()
    }

    // Assumes this view controller is already loaded.
    // For example, this could be called by a button tap.
    func playVideo(url videoURL: URL) {
        let player = IVSPlayer()
        player.delegate = self
        playerView.player = player
        player.load(videoURL)
    }
    
    @IBAction func play() {
        self.playVideo(url: URL(string: "https://c7de521ac11f.us-west-2.playback.live-video.net/api/video/v1/us-west-2.533032379413.channel.pW8qbswW0rTw.m3u8")!)
    }
}

extension IVSPlayerController: IVSPlayer.Delegate {
    func player(_ player: IVSPlayer, didChangeState state: IVSPlayer.State) {
        if state == .ready {
            player.play()
        }
    }
}
