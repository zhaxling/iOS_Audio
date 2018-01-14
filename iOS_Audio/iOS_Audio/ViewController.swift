//
//  ViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2017/12/20.
//  Copyright © 2017年 zxl. All rights reserved.
//

import UIKit
import AudioKit

class ViewController: UIViewController {
    
    let gcdTimer: DispatchSourceTimer = {
        
        var times:UInt64 = 0
        func timerAction() {
            
            print("调用 \(times)")
            
            times += 1
        }
        
        let timer = DispatchSource.makeTimerSource(flags: DispatchSource.TimerFlags(), queue: DispatchQueue.global())
        // 500毫秒执行一次
        timer.schedule(deadline: DispatchTime.now(), repeating: DispatchTimeInterval.milliseconds(500), leeway: DispatchTimeInterval.never)
        timer.setEventHandler {
            timerAction()
        }
        return timer
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func random(min: UInt32, max: UInt32) -> Double {
        let temp = arc4random() % (max - min) + min
        return Double(temp)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func tapAction(_ sender: Any) {
        
        print(" ------ ")
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        /**
        if AudioKit.output != nil {
            let oldOscillator:AKOscillator? = AudioKit.output as? AKOscillator
            if (oldOscillator?.isStarted)! {
                print("振荡器启动")
                oldOscillator?.stop()
                return;
            }
        }
        
        
        // 创建音频生成器-振荡器 是AKNode子类
        let oscillator:AKOscillator = AKOscillator()
        // 设置AudioKit输出 并开启 - 音频引擎
        AudioKit.output = oscillator
        //AudioKit.start()
        // 设置频率 - 决定音符的音高
        let frequency = self.random(min: 200, max: 280)
        print(frequency)
        oscillator.frequency = frequency
        // 设置振幅 0-1 决定音量
        oscillator.amplitude = 0.5;
        // 允许振荡器在属性值之间平滑过渡（比如频率或振幅）
        oscillator.rampTime = 0.2;
        // 开启音频生成器
        oscillator.start()
        */

        
    }
    @IBAction func envelopeAction(_ sender: Any) {
        // - 声音封皮
        /**
         Attack 上升: 在这个阶段声音上行至最大音量。
         Decay 下行: 这个时候声音下滑到 Sustain 水平。
         Sustain 维持: 这个阶段声音会维持在退败终止时的音量，一直到开始松开。
         Release 松开: 这个阶段音量开始下滑到 0。
         */
        // 创建振荡器
        let oscillator = AKOscillator()
        // 创建ADSR封皮
        let envelope = AKAmplitudeEnvelope(oscillator)
        envelope.attackDuration = 0.01;
        envelope.decayDuration = 0.1
        envelope.sustainLevel = 0.1
        envelope.releaseDuration = 0.3
        // 设置AudioKit
        AudioKit.output = envelope
        // 开启引擎 封皮
        AudioKit.start()
        oscillator.start()
        
        gcdTimer.setEventHandler {
            if envelope.isStarted {
                envelope.stop()
            }else{
                envelope.start()
            }
        }
        gcdTimer.resume()
        
        
    }
    @IBAction func stopAction(_ sender: Any) {
        gcdTimer.cancel()
    }
    
    @IBAction func soundTouchAction(_ sender: UIButton) {
        
        let stVC = STVoiceViewController()
        self.navigationController?.pushViewController(stVC, animated: true)
        
        
    }
}

