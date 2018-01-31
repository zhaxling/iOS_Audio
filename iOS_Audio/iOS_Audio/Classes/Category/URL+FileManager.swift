//
//  String+FileManager.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/15.
//  Copyright © 2018年 zxl. All rights reserved.
//

import Foundation

extension URL {
    
    
    /// 获取Documents文件路径
    ///
    /// - Returns: Documents路径
    static func getDocPath() -> URL {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[0] as URL
    }
    
    
    /// 获取音频路径
    ///
    /// - Returns: 音频文件夹路径
    static func getAudioPath() -> URL {
        // 获取Documents文件路径
        var audioUrl = URL.getDocPath()
        // 添加audio文件夹
        audioUrl.appendPathComponent("audio")
        return audioUrl
    }
    
    
    /// 获取新M4A的音频路径
    /// 当前时间+M4A作为文件名
    /// - Returns: 文件全路径 添加audio文件夹
    static func getAudioTimePath() -> URL {
        // 根据时间设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".m4a"

        // 获取Audio文件路径
        let audioUrl = URL.getAudioPath()
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: audioUrl.path)
        if !exist {
            try! fileManager.createDirectory(at: audioUrl, withIntermediateDirectories: true, attributes: nil)
        }
        // 添加 文件名
        let path = audioUrl.appendingPathComponent(recordingName)
        return path
    }
    
    
    /// 获取所有audio文件夹下的录音文件
    ///
    /// - Returns: 文件数组
    static func getAudioAllFiles() -> [String] {
        // 获取Audio文件路径
        let audioUrl = URL.getAudioPath()
        do {
            let files = try FileManager.default.contentsOfDirectory(at: audioUrl,
                                                                    includingPropertiesForKeys: nil,
                                                                    options: .skipsHiddenFiles)
            //let files = try FileManager.default.contentsOfDirectory(atPath: docUrl.path)
            let recordings = files.filter({ (name: URL) -> Bool in
                return name.pathExtension == "m4a"
            })
            //let recordingStrArray = recordings.map({ (url) -> String in
             //   return url.path
            //})
            let recordingStrArray = recordings.map({($0).lastPathComponent})
            
            return recordingStrArray
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func deleteAudioFile(name: String) {
        // 获取Audio文件路径
        var audioUrl = URL.getAudioPath()
        audioUrl.appendPathComponent(name)
        if FileManager.default.fileExists(atPath: audioUrl.path) {
            do {
                try FileManager.default.removeItem(at: audioUrl)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    /// 删除audio文件夹下的所有文件
    func deleteAudioAllFile() {
        // 获取Audio文件路径
        let audioUrl = URL.getAudioPath()
        let fileArray = FileManager.default.subpaths(atPath: audioUrl.path)
        for fn in fileArray!{
            try! FileManager.default.removeItem(atPath: audioUrl.path + "/\(fn)")
        }
    }
}


