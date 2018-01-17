//
//  String+FileManager.swift
//  iOS_Audio
//
//  Created by Apple on 2018/1/15.
//  Copyright © 2018年 zxl. All rights reserved.
//

import Foundation

extension URL {
    
    static func getFilesPath(_ dirUrl: URL) -> [String]? {
        var filePaths = [String]()
        
        do {
            //let array = try FileManager.default.contentsOfDirectory(at: dirUrl, includingPropertiesForKeys: //<#T##[URLResourceKey]?#>, options: <#T##FileManager.DirectoryEnumerationOptions#>)
            
            let array = try FileManager.default.contentsOfDirectory(atPath: dirPath)
            
            for fileName in array {
                var isDir: ObjCBool = true
                
                let fullPath = "\(dirPath)/\(fileName)"
                
                if FileManager.default.fileExists(atPath: fullPath, isDirectory: &isDir) {
                    if !isDir.boolValue {
                        filePaths.append(fullPath)
                    }
                }
            }
            
        } catch let error as NSError {
            print("get file path error: \(error)")
        }
        
        return filePaths;
    }
}


