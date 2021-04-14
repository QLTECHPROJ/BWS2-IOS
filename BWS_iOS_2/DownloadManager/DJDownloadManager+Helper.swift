//
//  DJDownloadManager+Helper.swift
//  BWS
//
//  Created by Dhruvit on 25/02/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

extension DJDownloadManager {
    
    func clearCacheDirectory() {
        let fileManager = FileManager.default
        let documentDirectoryPath = SDFileUtils.cachesDirectoryPath()
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: documentDirectoryPath, includingPropertiesForKeys: nil)
            for file in directoryContents {
                do {
                    try fileManager.removeItem(at: file)
                }
                catch let error as NSError {
                    debugPrint("Error while deleting file: \(error)")
                }
            }
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func moveFiles(filesToMove : [URL], atDirectory documentDirectory : URL) {
        
        for audioFile in filesToMove {
            let newUrl = documentDirectory.appendingPathComponent(audioFile.lastPathComponent)
            do {
                try FileManager.default.moveItem(at: audioFile, to: newUrl)
            } catch {
                print("File Transfer Error :- ",error.localizedDescription)
            }
        }
    }
    
    func moveAudiosFromCachesDirectory() {
        guard let cachesDownloads = cachesDirectoryDownloadsPath() else {
            return
        }
        
        guard let documentDownloadsPath = documentDirectoryDownloadsPath() else {
            return
        }
        
        self.moveFiles(filesToMove: cachesDownloads, atDirectory: documentDownloadsPath)
    }
    
    func cachesDirectoryDownloadsPath() -> [URL]? {
        let directoryUrl = SDFileUtils.cachesDirectoryPath().appendingPathComponent(DJDownloadManager.shared.directoryName)
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: directoryUrl, includingPropertiesForKeys: nil)
            return fileURLs
        } catch {
            print("No audios found in Caches \(DJDownloadManager.shared.directoryName) Directory")
            return nil
        }
    }
    
    func documentDirectoryDownloadsPath() -> URL? {
        let directoryUrl = SDFileUtils.documentDirectoryPath().appendingPathComponent(DJDownloadManager.shared.directoryName)
        if FileManager.default.fileExists(atPath: directoryUrl.path) {
            return directoryUrl
        }
        
        do {
            try FileManager.default.createDirectory(at: directoryUrl, withIntermediateDirectories: true, attributes: nil)
            return directoryUrl
        } catch {
            print("documentDirectory Error :- ",error.localizedDescription)
        }
        
        return nil
    }
    
}
