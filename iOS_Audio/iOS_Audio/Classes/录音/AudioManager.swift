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

@objc protocol AudioPlayerDelegate : NSObjectProtocol {
    /** 开始播放 */
    @available(iOS 9.0, *)
    @objc optional func playerDidStart()
    /** 当前播放时间 */
    @objc optional func player(currentTime:TimeInterval)
    /** 当前播放时间 分 秒 */
    @objc optional func player(min:Int ,sec:Int)
    /** 暂停播放 */
    @objc optional func playerPause()
    /** 结束播放 */
    @objc optional func playerDidFinish()
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
        state = .Recording
        
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
  
    /// 开始录制
    ///
    /// - Parameters:
    ///   - url: 录制文件保存路径
    ///   - delegate: 代理
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
    
    /// 暂停录制
    func pause() {
        recorder?.pause()
        recorderTimer?.fireDate = Date.distantFuture
        powerTimer?.fireDate = Date.distantFuture
        recorderDelegate?.recorderPause?()
    }
    
    /// 结束录制
    func finish() {
        recorder?.stop()
    }
    
    // 定时器
    @objc func recorderTime()  {
        recorderDelegate?.recorder?(currentTime: (recorder?.currentTime)!)
        // 代理返回时间 分 秒
        recorderDelegate?.recorder?(min: Int((recorder?.currentTime)! / 60), sec: Int((recorder?.currentTime.truncatingRemainder(dividingBy: 60))!))
    }
    @objc func power()  {
        recorder?.updateMeters()// -160 -
        let peakPower = recorder?.peakPower(forChannel: 0)
        let averagePower = recorder?.averagePower(forChannel: 0)
        print("录音强度 \(String(format: "%.6f", peakPower!)) \(String(format: "%.6f", averagePower!))")
    }
    
    
    /// 请求权限
    ///
    /// - Parameter setup: 是否需要初始化录制器
    func recordWithPermission(_ setup: Bool) {
        AVAudioSession.sharedInstance().requestRecordPermission {
            [unowned self] granted in
            if granted {
                
                DispatchQueue.main.async {
                    print("Permission to record granted")
                    self.setSessionPlayAndRecord()
                    if setup {
                        self.setupRecorder()
                        // 开始录制
                        if (self.recorder?.record())! {
                            self.setTimer()
                            self.recorderTimer?.fire()
                            self.powerTimer?.fire()
                            self.recorderDelegate?.recorderDidStart?()
                        }
                    }else{
                        // 恢复录制
                        if (self.recorder?.record())! {
                            self.recorderTimer?.fireDate = Date.distantPast
                            self.powerTimer?.fireDate = Date.distantPast
                            self.recorderDelegate?.recorderDidStart?()
                        }
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
    
    //MARK: - 播放
    var player:AVAudioPlayer?
    var playerDelegate:AudioPlayerDelegate?
    var playerTimer: Timer?
    func setPlayerTimer() {
        let playerTimer = Timer(timeInterval: 1, target: self, selector: #selector(playerTime), userInfo: nil, repeats: true)
        RunLoop.main.add(playerTimer, forMode: .commonModes)
        self.playerTimer = playerTimer
    }
    
    /// 播放
    ///
    /// - Parameters:
    ///   - url: url
    ///   - delegate: 代理
    func play(url: URL,delegate:AudioPlayerDelegate) {
        if self.player != nil {
            player?.play()
            playerTimer?.fireDate = Date.distantPast
            playerDelegate?.playerDidStart?()
            return;
        }
        playerDelegate = delegate
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.delegate = self
            player?.prepareToPlay()
            player?.volume = 1.0
            if (player?.play())! {
                setPlayerTimer()
                state = .Playing
                playerDelegate?.playerDidStart?()
            }
        } catch {
            player = nil
            print(error.localizedDescription)
        }
    }
    
    /// 暂停
    func pausePlay() {
        player?.pause()
        playerTimer?.fireDate = Date.distantFuture
        playerDelegate?.playerPause?()
    }
    
    /// 结束播放
    func stop() {
        player?.stop()
        playerTimer?.invalidate()
        playerTimer = nil
        self.player = nil
        self.playerDelegate = nil
        state = .Idle
        playerDelegate?.playerDidFinish?()
    }
    
    @objc func playerTime() {
        playerDelegate?.player?(currentTime: (player?.currentTime)!)
        // 代理返回时间 分 秒
        playerDelegate?.player?(min: Int((player?.currentTime)! / 60), sec: Int((player?.currentTime.truncatingRemainder(dividingBy: 60))!))
    }
    
    //MARK: - 通知
    func notifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillResignActive(_:)),
                                               name: Notification.Name.UIApplicationWillResignActive,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(applicationWillEnterForeground(_:)),
                                               name: Notification.Name.UIApplicationWillEnterForeground,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(audioSessionRouteChange(_:)),
                                               name: Notification.Name.AVAudioSessionRouteChange,
                                               object: nil)
    }
    
    @objc func applicationWillResignActive(_ notification: Notification) {
        print("\(#function)")
    }
    
    @objc func applicationWillEnterForeground(_ notification: Notification) {
        print("\(#function)")
    }
    
    
    @objc func audioSessionRouteChange(_ notification: Notification) {
        
        if let userInfo = notification.userInfo {
            if let reason = userInfo[AVAudioSessionRouteChangeReasonKey] {
                switch AVAudioSessionRouteChangeReason(rawValue: reason as! UInt)! {
                case AVAudioSessionRouteChangeReason.newDeviceAvailable:
                    print("NewDeviceAvailable")
                    print("did you plug in headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.oldDeviceUnavailable:
                    print("OldDeviceUnavailable")
                    print("did you unplug headphones?")
                    checkHeadphones()
                case AVAudioSessionRouteChangeReason.categoryChange:
                    print("CategoryChange")
                case AVAudioSessionRouteChangeReason.override:
                    print("Override")
                case AVAudioSessionRouteChangeReason.wakeFromSleep:
                    print("WakeFromSleep")
                case AVAudioSessionRouteChangeReason.unknown:
                    print("Unknown")
                case AVAudioSessionRouteChangeReason.noSuitableRouteForCategory:
                    print("NoSuitableRouteForCategory")
                case AVAudioSessionRouteChangeReason.routeConfigurationChange:
                    print("RouteConfigurationChange")
                    
                }
            }
        }
    }
    
    func checkHeadphones() {
        // check NewDeviceAvailable and OldDeviceUnavailable for them being plugged in/unplugged
        let currentRoute = AVAudioSession.sharedInstance().currentRoute
        if !currentRoute.outputs.isEmpty {
            for description in currentRoute.outputs {
                if description.portType == AVAudioSessionPortHeadphones {
                    print("headphones are plugged in")
                    break
                } else {
                    print("headphones are unplugged")
                }
            }
        } else {
            print("checking headphones requires a connection to a device")
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
        self.recorderDelegate = nil
        state = .Idle
        setSessionDefault()// 重置会话
        recorderDelegate?.recorderDidFinish?()
        print("录制完成 \(flag)")
    }
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("编码错误 \(String(describing: error?.localizedDescription))")
    }
}

extension AudioManager : AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        playerTimer?.invalidate()
        playerTimer = nil
        self.player = nil
        self.playerDelegate = nil
        state = .Idle
        playerDelegate?.playerDidFinish?()
    }
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("编码错误 \(String(describing: error?.localizedDescription))")
    }
}
