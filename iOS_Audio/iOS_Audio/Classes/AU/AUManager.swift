//
//  AUManager.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/18.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit
import AudioUnit
import AVFoundation

class AUManager: NSObject {

    // AudioUnit
    let audioUnit:AudioUnit = AudioUnit(bitPattern: 0)!
    
    func initRemoteIO() {
        
        do {
            try initAudioSession()
        } catch {
            customLog("初始化 AVAudioSession 发生错误")
        }
        
    }
    
    // 初始化 AVAudioSession
    func initAudioSession() throws {
        let audioSession = AVAudioSession.sharedInstance()
        
        try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
        try audioSession.setPreferredSampleRate(44100)
        try audioSession.setPreferredInputNumberOfChannels(1)
        try audioSession.setPreferredIOBufferDuration(0.022)
    }
    
    // 初始化 Buffer
    func initBuffer() {
        var flag:UInt32 = 0
        let element:AudioUnitElement = 0
        let flagSize:UInt32 = UInt32(MemoryLayout.size(ofValue: flag))
        
        AudioUnitSetProperty(audioUnit,
                             kAudioUnitProperty_ShouldAllocateBuffer,
                             kAudioUnitScope_Output,
                             element,
                             &flag,
                             flagSize)
    }
}
