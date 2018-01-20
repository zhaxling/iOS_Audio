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

let INPUT_BUS = AudioUnitElement(bitPattern: 1)
let OUTPUT_BUS = AudioUnitElement(bitPattern: 0)

class AUManager: NSObject {

    // AudioUnit
    let audioUnit:AudioUnit? = nil
    var buffList:AudioBufferList? = nil
    
    
    override init() {
        super.init()
        
        AudioUnitInitialize(audioUnit!)
        self.initRemoteIO()
    }
    
    func initRemoteIO() {
        
        do {
            try initAudioSession()
        } catch {
            customLog("初始化 AVAudioSession 发生错误 \(error.localizedDescription)")
        }
        
        initBuffer()
        
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
        let flagSize:UInt32 = UInt32(MemoryLayout.size(ofValue: flag))
        
        AudioUnitSetProperty(audioUnit!,
                             kAudioUnitProperty_ShouldAllocateBuffer,
                             kAudioUnitScope_Output,
                             INPUT_BUS,
                             &flag,
                             flagSize)
        
        //buffList = AudioBufferList(malloc(MemoryLayout.size(ofValue: AudioBufferList)))
    }
    
    func initAudioComponent() {
        var audioDesc = AudioComponentDescription()
        audioDesc.componentType = kAudioUnitType_Output
        audioDesc.componentSubType = kAudioUnitSubType_RemoteIO
        audioDesc.componentManufacturer = kAudioUnitManufacturer_Apple
        audioDesc.componentFlags = 0
        audioDesc.componentFlagsMask = 0
        
        var inputComponent = AudioComponentFindNext(nil, &audioDesc)
        AudioComponentInstanceNew(inputComponent!, &inputComponent)
    }
}
