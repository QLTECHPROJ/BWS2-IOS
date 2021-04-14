//
//  DJDownloadManager.swift
//  BWS
//
//  Created by Dhruvit on 23/09/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation

class DJDownloadManager {
    
    public static let shared = DJDownloadManager()
    
    private let downloadManager = SDDownloadManager.shared
    
    let directoryName : String = "BWS_Downloads"
    var isDownloading : Bool = false
    
    var downloadProgress : Double = 0
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(refreshDownloadData), name: NSNotification.Name.refreshDownloadData, object: nil)
    }
    
    @objc func refreshDownloadData() {
        
        let downloadKeys = SDDownloadManager.shared.currentDownloads()
        var currentKeys = [String]()
        for key in downloadKeys {
            if let newKey = "\(key)".removingPercentEncoding {
                if CoreDataHelper.shared.checkAudioFileInDatabase(filePath: newKey) == false {
                    currentKeys.append(newKey)
                }
            }
        }
        
        for cancelDownloadKey in currentKeys {
            SDDownloadManager.shared.cancelDownload(forUniqueKey: cancelDownloadKey)
        }
    }
    
    func clearDocumentDirectory() {
        let fileManager = FileManager.default
        let documentDirectoryPath = SDFileUtils.documentDirectoryPath()
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
    
    func fetchAllFiles() -> [URL] {
        let fileManager = FileManager.default
        let documentsURL = SDFileUtils.documentDirectoryPath().appendingPathComponent(directoryName)
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            print("fileURLs :- ",fileURLs)
            return fileURLs
        }
        catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
        
        return [URL]()
    }
    
    func checkFileExists(fileName : String) -> Bool {
        guard let strUrl = fileName.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            return false
        }
        
        guard let url = URL(string: strUrl) else {
            return false
        }
        
        let fileManager = FileManager.default
        let documentsURL = SDFileUtils.documentDirectoryPath().appendingPathComponent(directoryName).appendingPathComponent(url.lastPathComponent)
        
        if fileManager.fileExists(atPath: documentsURL.path) {
            return true
        }
        return false
    }
    
    func isCurrentlyDownloading(audioFile : String) -> Bool {
        
        if SDDownloadManager.shared.currentDownloads().count == 0 {
            return false
        }
        
        guard let strUrl = audioFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return false
        }
        
        if SDDownloadManager.shared.currentDownloads().contains(strUrl) {
            return true
        }
        
        return false
    }
    
    func deleteFileExists(fileName : String) {
        
        if CoreDataHelper.shared.checkAudioFileInDatabase(filePath: fileName) {
            return
        }
        
        guard let strUrl = fileName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let downloadUrl = URL(string: strUrl) else {
            return
        }
        
        let fileManager = FileManager.default
        let documentsURL = SDFileUtils.documentDirectoryPath().appendingPathComponent(directoryName).appendingPathComponent(downloadUrl.lastPathComponent)
        do {
            try fileManager.removeItem(at: documentsURL)
        }
        catch {
            debugPrint("Error while deleting file: \(error)")
        }
    }
    
    func getFileFromDirectory(fileName : String) -> URL? {
        let fileManager = FileManager.default
        let documentsURL = SDFileUtils.documentDirectoryPath().appendingPathComponent(directoryName).appendingPathComponent(fileName)
        
        if fileManager.fileExists(atPath: documentsURL.path) {
            return documentsURL
        }
        return nil
    }
    
    func fetchNextDownload() {
        let audios = CoreDataHelper.shared.fetchAllAudios()
        var downloadArray = [AudioDetailsDataModel]()
        
        for audioData in audios {
            if let strUrl = audioData.AudioFile.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
                let url = URL(string: strUrl) {
                if DJDownloadManager.shared.checkFileExists(fileName: url.lastPathComponent) == false {
                    downloadArray.append(audioData)
                }
            }
        }
        
        if downloadArray.count > 0 {
            backgroundDownloadDemo(audioData: downloadArray[0])
        }
    }
    
    func backgroundDownloadDemo(audioData : AudioDetailsDataModel) {
        
        if SDDownloadManager.shared.currentDownloads().count > 0 {
//            if SDDownloadManager.shared.currentDownloads().count > 1 {
//                SDDownloadManager.shared.cancelAllDownloads()
//                self.fetchNextDownload()
//                return
//            }
            return
        }
        
//        if isDownloading {
//            return
//        }
        
        DJDownloadManager.shared.downloadProgress = 0
        
        guard let strUrl = audioData.AudioFile.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let downloadUrl = URL(string: strUrl) else {
            return
        }
        
        if checkFileExists(fileName: downloadUrl.lastPathComponent) {
            return
        }
        
//        isDownloading = true
        let request = URLRequest(url: downloadUrl)
        
        self.downloadManager.showLocalNotificationOnBackgroundDownloadDone = true
//        self.downloadManager.localNotificationText = "\(downloadUrl.lastPathComponent) - Download completed"
        self.downloadManager.localNotificationText = "\(downloadUrl.lastPathComponent)"
        
        let downloadKey = self.downloadManager.downloadFile(withRequest: request, inDirectory: directoryName, withName: downloadUrl.lastPathComponent, shouldDownloadInBackground: true, onProgress: { (progress) in
            let percentage = String(format: "%.1f %", (progress * 100))
            DJDownloadManager.shared.downloadProgress = Double(progress)
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadProgress, object: nil)
            debugPrint("Background progress \(downloadUrl.lastPathComponent) : \(percentage)")
        }) { (error, url) in
            if let error = error {
                print("Error is \(error as NSError)")
                DJDownloadManager.shared.downloadProgress = 0
                self.isDownloading = false
                self.fetchNextDownload()
            }
            else {
                DJDownloadManager.shared.downloadProgress = 0
                self.isDownloading = false
                self.fetchNextDownload()
                if let fileUrl = url {
                    print("Downloaded file's url is \(fileUrl.path)")
                    // CoreDataHelper.shared.updateDownloadLocation(filePath: fileUrl)
                    NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
                    // showAlertToast(message: "Audio download complete and added to your downloads")
                    
                    if let urlPath = request.url?.absoluteString {
                        self.showDownloadSuccessMessage(fileUrl: urlPath)
                    }
                }
            }
        }
        
        print("The key is \(downloadKey!)")
    }
    
    func showDownloadSuccessMessage(fileUrl : String) {
        // let downloadedAudios = CoreDataHelper.shared.fetchAudios(filePath: fileUrl)
        var downloadedAudios = CoreDataHelper.shared.fetchAllAudios()
        downloadedAudios = downloadedAudios.filter { $0.AudioFile == fileUrl }
        let singleAudios = downloadedAudios.filter { $0.isSingleAudio == "1" }
        
        var isSingleAudio = singleAudios.count > 0
        
        var isPlaylistDownloaded = false
        
        var arrayPlaylistIDs = downloadedAudios.map { (audio) -> String in
            return audio.PlaylistID
        }
        
        arrayPlaylistIDs = Array(Set(arrayPlaylistIDs.filter { $0 != "" }))
        
        var arrayDownloadedPlaylists = [PlaylistDetailsModel]()
        
        for playlistId in arrayPlaylistIDs {
            let playlistDownloadProgress = CoreDataHelper.shared.updatePlaylistDownloadProgress(playlistID: playlistId)
            if playlistDownloadProgress == 1 {
                isPlaylistDownloaded = true
                isSingleAudio = false
                if let playlistData = CoreDataHelper.shared.fetchPlaylistDetails(playlistID: playlistId) {
                    arrayDownloadedPlaylists.append(playlistData)
                }
            }
            else if playlistDownloadProgress > 0 {
                isSingleAudio = false
            }
        }
        
        if isSingleAudio {
            showAlertToast(message: "Audio download complete and added to your downloads")
        }
        
        if isPlaylistDownloaded == true {
            showAlertToast(message: "Playlist download complete and added to your downloads")
        }
        
    }
    
}
