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
    
    
    /// 获取M4A的音频路径
    /// 当前时间+M4A作为文件名
    /// - Returns: 文件全路径 添加audio文件夹
    static func getM4ATimePath() -> URL {
        // 根据时间设置存储文件名
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyyHHmmss"
        let recordingName = formatter.string(from: currentDateTime)+".m4a"

        // 获取Documents文件路径
        var docUrl = URL.getDocPath()
        // 添加audio文件夹
        docUrl.appendPathComponent("/audio")
        let fileManager = FileManager.default
        let exist = fileManager.fileExists(atPath: docUrl.path)
        if !exist {
            try! fileManager.createDirectory(at: docUrl, withIntermediateDirectories: true, attributes: nil)
        }
        // 添加 文件名
        let path = docUrl.appendingPathComponent(recordingName)
        return path
    }
    
    
    /// 获取所有audio文件夹下的录音文件
    ///
    /// - Returns: 文件数组
    static func getM4AAllFiles() -> [String] {
        // 获取Documents文件路径
        var docUrl = URL.getDocPath()
        // 添加audio文件夹
        docUrl.appendPathComponent("/audio")
        do {
            let files = try FileManager.default.contentsOfDirectory(atPath: docUrl.path)
            return files
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    
    /// 删除audio文件夹下的所有文件
    func deleteM4AAllFile() {
        // 获取Documents文件路径
        var docUrl = URL.getDocPath()
        // 添加audio文件夹
        docUrl.appendPathComponent("/audio")
        let fileArray = FileManager.default.subpaths(atPath: docUrl.path)
        for fn in fileArray!{
            try! FileManager.default.removeItem(atPath: docUrl.path + "/\(fn)")
        }
    }
}


