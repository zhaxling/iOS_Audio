//
//  AudioManager.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/12.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit
import AVFoundation

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

let AVSampleRate = 44100.0 // 采样率
let AVChannels = 1 // 采样通道
let AVLinearPCMBitDepth = 16 // 采样位数 默认16

// 定时器返回时间频率
let AVTimerRate = 0.1 / 1

class AudioManager: NSObject {
    
    deinit {
        print("录制器销毁了")
    }
    
    // 当前状态
    var state:AudioState = .Idle
    static let manager:AudioManager = AudioManager.init()
    
    
    //MARK: - 录音
    var recorderDelegate:AudioRecorderDelegate?
    var recorderUrl:URL?
    var recorder: AVAudioRecorder?
    
    
    /// 初始化录音器
    func setupRecorder() {
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatAppleLossless,
            AVEncoderAudioQualityKey: AVAudioQuality.max.rawValue,
            AVEncoderBitRateKey: 32000,
            AVNumberOfChannelsKey: AVChannels,
            AVSampleRateKey: AVSampleRate
        ]
        
        do {
            recorder = try AVAudioRecorder(url: recorderUrl!, settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord() // creates/overwrites the file at soundFileURL
        } catch {
            print("创建录音失败 - \(error.localizedDescription)")
        }
    }
    
    var recorderTimer: Timer?
    var powerTimer: Timer?
    func setTimer() {
        let recorderTimer = Timer(timeInterval: 1, target: self, selector: #selector(recorderTime), userInfo: nil, repeats: true)
        RunLoop.main.add(recorderTimer, forMode: .commonModes)
        self.recorderTimer = recorderTimer
        
        let powerTimer = Timer(timeInterval: 1, target: self, selector: #selector(power), userInfo: nil, repeats: true)
        RunLoop.main.add(powerTimer, forMode: .commonModes)
        self.powerTimer = powerTimer
    }
  
    func start(url:URL, delegate:AudioRecorderDelegate) {
        recorderDelegate = delegate
        recorderUrl = url
        
        // 请求权限
        if recorder == nil {
            recordWithPermission(true)
        }
        else {
            recordWithPermission(false)
        }
    }
    
    func pause() {
        recorder?.pause()
        recorderTimer?.fireDate = Date.distantFuture
        powerTimer?.fireDate = Date.distantFuture
        recorderDelegate?.recorderPause?()
    }
    
    func finish() {
        recorder?.stop()
        setSessionDefault()// 充值会话
    }
    
    // 定时器
    @objc func recorderTime()  {
        recorderDelegate?.recorder?(currentTime: (recorder?.currentTime)!)
        // 代理返回时间 分 秒
        recorderDelegate?.recorder?(min: Int((recorder?.currentTime)! / 60), sec: Int((recorder?.currentTime.truncatingRemainder(dividingBy: 60))!))
    }
    @objc func power()  {
        
    }
    
    
    /// 请求权限
    ///
    /// - Parameter setup: 是否需要初始化录制器
    func recordWithPermission(_ setup: Bool) {
        print("\(#function)")
        
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                    }
                    
                    if (self.recorder?.record())! {
                        self.setTimer()
                        self.recorderTimer?.fire()
                        self.powerTimer?.fire()
                        self.recorderDelegate?.recorderDidStart?()
                    }
                }
            } else {
                print("Permission to record not granted")
            }
        }
        
        if AVAudioSession.sharedInstance().recordPermission() == .denied {
            print("permission denied")
        }
    }
    
    
    func setSessionPlayback() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback, with: .defaultToSpeaker)
            
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayAndRecord() {
        print("\(#function)")
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        } catch {
            print("could not set session category")
            print(error.localizedDescription)
        }
        
        do {
            try session.setActive(true)
        } catch {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionDefault() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryRecord)
        } catch {
            print("录音器会话设置错误")
        }
        do {
            try session.setActive(false)
        } catch {
            print("录音器会话设置错误")
        }
    }
}


extension AudioManager : AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        recorderTimer?.invalidate()
        powerTimer?.invalidate()
        recorderTimer = nil
        powerTimer = nil
        self.recorder = nil
        recorderDelegate?.recorderDidFinish?()
        print("录制完成 \(flag)")
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("编码错误 \(String(describing: error?.localizedDescription))")
    }
}
