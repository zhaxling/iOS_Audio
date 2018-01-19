//
//  AUViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/18.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class AUViewController: UIViewController {

    @IBOutlet weak var recorderButton: UIButton!
    let recorder:AURecorder = AURecorder()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /**
         https://www.jianshu.com/p/5d18180c69b8
         Low-Level
         
         该主要在MAC上的音频APP实现中并且需要最大限度的实时性能的情况下使用，大部分音频APP不需要使用该层的服务。而且，在iOS上也提供了具备较高实时性能的高层API达到你的需求。例如OpenAL，在游戏中具备与I/O直接调用的实时音频处理能力
         I/O Kit, 与硬件驱动交互
         Audio HAL, 音频硬件抽象层，使API调用与实际硬件相分离，保持独立
         Core MIDI, 为MIDI流和设备提供软件抽象工作层
         Host Time Services, 访问电脑硬件时钟
         
         Mid-Level
         
         该层功能比较齐全，包括音频数据格式转换，音频文件读写，音频流解析，插件工作支持等
         Audio Convert Services 负责音频数据格式的转换
         Audio File Services 负责音频数据的读写
         Audio Unit Services 和 Audio Processing Graph Services 支持均衡器和混音器等数字信号处理的插件
         Audio File Scream Services 负责流解析
         Core Audio Clock Services 负责音频音频时钟同步
         
         High-Level
         
         是一组从低层接口组合起来的高层应用，基本上我们很多关于音频开发的工作在这一层就可以完成
         Audio Queue Services 提供录制、播放、暂停、循环、和同步音频它自动采用必要的编解码器处理压缩的音频格式
         AVAudioPlayer 是专为IOS平台提供的基于Objective-C接口的音频播放类，可以支持iOS所支持的所有音频的播放
         Extended Audio File Services 由Audio File与Audio Converter组合而成，提供压缩及无压缩音频文件的读写能力
         OpenAL 是CoreAudio对OpenAL标准的实现，可以播放3D混音效果
         */
        
        /**
         Audio Unit
         
         iOS提供了混音、均衡、格式转换、实时IO录制、回放、离线渲染、语音对讲(VoIP)等音频处理插件，它们都属于不同的AudioUnit，支持动态载入和使用。
         */
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recorderButtonClick(_ sender: Any) {
        recorder.start()
    }
    @IBAction func stopButtonClick(_ sender: Any) {
        recorder.stop()
    }
    
}
