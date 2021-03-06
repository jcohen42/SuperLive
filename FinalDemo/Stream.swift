//
//  Stream.swift
//  FinalDemo
//  this class will handle the initilization of the stream, and receive/ send audio/video buffers
//  Created by Alexis Ponce on 7/14/21.
//

import Foundation
import HaishinKit
import AVFoundation
import AVKit
import VideoToolbox
import AudioToolbox
class Stream:NSObject{
    
    var rtmpConnection = RTMPConnection();// instance of the RTMP connection from haishinkit
    var rtmpStream:RTMPStream!;// instance of the stream to handle the audio and video
    var Channels:Int?// audio channels used
    override init(){
        super.init()
        self.rtmpStream = RTMPStream(connection: self.rtmpConnection);// initializes the RTMP connection isntance
        self.rtmpStream.audioSettings = [
            .muted: false,
            .bitrate: 32 * 1000,
            .sampleRate: 0
        ]
    }
    
    func beginStream(){// method will be call to setup the stream settings and setup the connection
        let session = AVAudioSession.sharedInstance()
        do {
            //https://stackoverflow.com/questions/51010390/avaudiosession-setcategory-swift-4-2-ios-12-play-sound-on-silent
            if #available(iOS 10.0, *) {
                try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker, .allowBluetooth])
            } else {
                session.perform(NSSelectorFromString("setCategory:withOptions:error:"), with: AVAudioSession.Category.playAndRecord, with: [
                    AVAudioSession.CategoryOptions.allowBluetooth,
                    AVAudioSession.CategoryOptions.defaultToSpeaker]
                )
                try session.setMode(.default)
            }
            try session.setActive(true)
        } catch {
            print(error)
        }
        
        self.rtmpStream.attachAudio(AVCaptureDevice.default(for: AVMediaType.audio), automaticallyConfiguresApplicationAudioSession: false) { error in
            // print(error)
        }
        
        self.rtmpStream.receiveAudio = true;
        self.rtmpStream.recorderSettings = [// sets up the recording settings
            AVMediaType.audio: [
                AVNumberOfChannelsKey: 0,
                AVSampleRateKey: 0
            ]
        ]
        let streamURL = "rtmps://030c054ffef4.global-contribute.live-video.net:443/app/"// url where the stream will be sent to
        let pub = "sk_us-east-1_16ljk3USbOn7_z2d6omAoUMH20hSZFMdQ6vgvXu55Tm"// the key for the account where the stream is being sent
        self.rtmpConnection.connect(streamURL, arguments: nil)// connects to the stream url
        self.rtmpStream.publish(pub)// sends the public key
        self.rtmpStream.attachCamera(nil)
    }
    
    func endStream() {
        self.rtmpStream.close()
        print("Stream has ended")
    }
    
    func samples(sample:CMSampleBuffer?){// method to send the video samples
        guard let recievedSample = sample else{// checks to see if the passed bufer is not nil
            print("The sample buffers were NULL");
            return;
        }
        if let description = CMSampleBufferGetFormatDescription(recievedSample){// stores the sample buffer format description
            let dimensions = CMVideoFormatDescriptionGetDimensions(description)// stores the dimensions of the sample buffer
            self.rtmpStream.videoSettings = [
                .width: dimensions.width,// stores the width
                .height: dimensions.height,// stored the heigh
                .profileLevel: kVTProfileLevel_H264_Baseline_AutoLevel// sets the profile of the video
            ]
        }
        self.rtmpStream.appendSampleBuffer(recievedSample, withType: .video);// sends the buffere to the stream
    }
}
