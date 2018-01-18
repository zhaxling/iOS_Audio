//
//  STVoiceViewController.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/12.
//  Copyright © 2018年 zxl. All rights reserved.
//

import UIKit



class STVoiceViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 添加按钮
        view.addSubview(self.startButton)
        view.addSubview(self.endButton)
        view.addSubview(self.listButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let recorder = AudioManager.manager
    
    
    /**
     * 0 开始录音 没有录音
     * 1 录音中 暂停录音
     */
    var _type: UInt8 = 0
    var type : UInt8 {
        get {
            return _type
        }
        set {
            _type = newValue
            if _type == 0 {
                self.startButton.setTitle("开始录音", for: .normal)
            }
            else if _type == 1 {
                self.startButton.setTitle("暂停录音", for: .normal)
            }
        }
    }
    
    let screenBounds = UIScreen.main.bounds
    lazy var startButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("开始录音", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(startAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.4, y: screenBounds.height - screenBounds.width * 0.2 - 28, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    lazy var endButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("结束录音", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(endAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.7, y: screenBounds.height - screenBounds.width * 0.2 - 28, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    lazy var listButton: UIButton = {
        let btn = UIButton(type: UIButtonType.custom)
        btn.setTitle("录音列表", for: UIControlState.normal)
        btn.backgroundColor = UIColor.red
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(listAction), for: UIControlEvents.touchUpInside)
        btn.frame = CGRect(x: screenBounds.width * 0.1, y: screenBounds.height - screenBounds.width * 0.2 - 28, width: screenBounds.width * 0.2, height: screenBounds.width * 0.2)
        btn.layer.cornerRadius = screenBounds.width * 0.1
        return btn
    }()
    
    @objc func startAction() {
        print("\(#function)")
        if type == 0 {
            print("开始录音")
            
            //根据时间设置存储文件名
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "ddMMyyyyHHmmss"
            let recordingName = formatter.string(from: currentDateTime)+".m4a"
            
            let fileManager = FileManager.default
            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
            let documentDirectory = urls[0] as NSURL
            let audioPath = documentDirectory.appendingPathComponent("audio", isDirectory: true)
            let soundURL = audioPath?.appendingPathComponent(recordingName)//将音频文件名称追加在可用路径上形成音频文件的保存路径
            print(soundURL as Any)
            
            
            let isRecording = recorder.start(url: soundURL!, delegate: self)
            if isRecording {
                self.type = 1
            }
        } else if type == 1 {
            print("暂停录音")
            recorder.pause()
        }
    }
    
    @objc func endAction() {
        recorder.finish()
    }
    
    @objc func listAction() {
        let listVC = STListsViewController(style: .grouped)
        self.navigationController?.pushViewController(listVC, animated: true)
    }
}

extension STVoiceViewController : AudioRecorderDelegate{
    func recorderDidStart() {
        print("录制开始")
    }
    func recorderPause() {
        print("录制暂停")
    }
    func recorder(currentTime: TimeInterval) {
        //print("录制时间 \(currentTime)")
    }
    func recorder(min: Int, sec: Int) {
        let s = String(format: "%02d:%02d", min, sec)
        print("录制时间 \(s)")
    }
    func recorderDidFinish() {
        print("录制完成")
    }
}
