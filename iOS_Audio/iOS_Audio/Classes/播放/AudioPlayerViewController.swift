//
//  AudioPlayerViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/31.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit

class AudioPlayerViewController: BaseViewController {

    deinit {
        print("销毁了")
    }
    
    let manager = AudioManager.manager
    @IBOutlet weak var timeLabel: UILabel!
    var name:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "播放"
        
        // 获取url
        let url = URL.getAudioPath().appendingPathComponent(name!)
        
        manager.play(url: url, delegate: self)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        manager.stop()
    }
    
    @IBAction func pauseClick(_ sender: Any) {
        manager.pausePlay()
    }
    @IBAction func playClick(_ sender: Any) {
        // 获取url
        let url = URL.getAudioPath().appendingPathComponent(name!)
        
        manager.play(url: url, delegate: self)
    }
}

extension AudioPlayerViewController : AudioPlayerDelegate {
    func playerDidStart() {
        print("开始播放")
    }
    func playerPause() {
        print("暂停播放")
    }
    func player(currentTime: TimeInterval) {
        
    }
    func player(min: Int, sec: Int) {
        let s = String(format: "%02d:%02d", min, sec)
        self.timeLabel.text = s
        print("录制时间 \(s)")
    }
    func playerDidFinish() {
        print("播放结束")
    }
}
