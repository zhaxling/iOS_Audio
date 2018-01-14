//
//  AudioManager.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/12.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit
import AVFoundation

let AVSampleRate = 44100.0 // 采样率
let AVChannels = 1 // 采样通道
let AVLinearPCMBitDepth = 16 // 采样位数 默认16

// 定时器返回时间频率
let AVTimerRate = 0.1 / 1


@objc protocol AudioRecorderDelegate {
    
    /** 开始录音 */
    @objc optional func recorderDidStart()
    /** 当前录音时间 */
    @objc optional func recorder(currentTime:TimeInterval)
    /** 当前录音时间 分 秒 */
    @objc optional func recorder(min:Int ,sec:Int)
    /** 暂停录音 */
    @objc optional func recorderPause()
    /** 结束录音 */
    @objc optional func recorderDidFinish()
    
}

// 闲时 录音 播放
enum AudioState {
    case Idle
    case Recording
    case Playing
}

class AudioManager: NSObject {
    
    // 当前状态
    var state:AudioState = .Idle
    //let manager:AudioManager = AudioManager()
    
    
    //MARK: - 录音
    var recorderDelegate:AudioRecorderDelegate?
    var recorderPath:String?
    
    init(path:String,delegate:AudioRecorderDelegate) {
        //super.init()
        recorderDelegate = delegate
        recorderPath = path
    }
    
    lazy var recorder: AVAudioRecorder? = {
        
        let url = URL(fileURLWithPath: recorderPath!)
        
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: AVChannels,
            AVSampleRateKey: AVSampleRate
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            
            let recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder.delegate = self
            recorder.isMeteringEnabled = true
            recorder.prepareToRecord()
            return recorder
        } catch {
            print("创建录音失败 - \(error.localizedDescription)")
            return nil
        }
    }()
    
    lazy var recorderTimer: Timer = {
        let timer = Timer(timeInterval: 0.1, target: self, selector: #selector(recorderTime), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: .commonModes)
        return timer
    }()
    var currentTime:TimeInterval = 0
    
    
    func start() {
        if (recorder?.isRecording)! {
            print("正在录制")
            return
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            if (recorder?.record())! {
                currentTime = 0
                recorderTimer.fire()
                recorderDelegate?.recorderDidStart?()
            }
        } catch {
        }
        

    }
    
    func pause() {
        recorder?.pause()
        recorderTimer.invalidate()
        recorderDelegate?.recorderPause?()
    }
    
    func stop() {
        recorder?.stop()
    }
    
    // 定时器
    @objc func recorderTime()  {
        recorderDelegate?.recorder?(currentTime: (recorder?.currentTime)!)
        // 代理返回时间 分 秒
        recorderDelegate?.recorder?(min: Int((recorder?.currentTime)! / 60), sec: Int((recorder?.currentTime.truncatingRemainder(dividingBy: 60))!))
    }
}


extension AudioManager : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        
        recorderTimer.invalidate()
        recorderDelegate?.recorderDidFinish?()
        print("录制完成 \(flag)")
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("编码错误 \(String(describing: error?.localizedDescription))")
    }
}
