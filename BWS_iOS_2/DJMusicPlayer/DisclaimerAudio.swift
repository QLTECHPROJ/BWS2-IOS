//
//  DisclaimerAudio.swift
//  BWS
//
//  Created by Dhruvit on 13/10/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation

class DisclaimerAudio {
    
    // MARK: - Properties
    public static let shared = DisclaimerAudio()
    
    func fetchDisclaimerAudio(data : AudioDetailsDataModel) -> AudioDetailsDataModel {
        
        self.saveDisclaimerAudioToDownloads()
        
        let audioData = AudioDetailsDataModel()
        audioData.ID = data.ID
        audioData.Name = "Disclaimer"
//        audioData.AudioFile = fetchDisclaimerAudioFile()
        audioData.AudioFile = "https://brainwellnessspa.com.au/Bws-consumer-panel/html/audio_file/Brain_Wellness_Spa_Declaimer.mp3"
        audioData.ImageFile = ""
        audioData.AudioDuration = "00:48"
        audioData.AudioDirection = "The audio shall start playing after the disclaimer"
        audioData.AudioDescription = ""
        audioData.Audiomastercat = ""
        audioData.AudioSubCategory = ""
        audioData.Like = ""
        audioData.IsLock = ""
        audioData.IsPlay = ""
        
        audioData.PlaylistID = data.PlaylistID
        audioData.Download = data.Download
        audioData.isSingleAudio = data.isSingleAudio
        audioData.CategoryName = data.CategoryName
        
        audioData.isDisclaimer = true
        
        return audioData
    }
    
    func fetchDisclaimerImageFile() -> String {
        let stringPath = Bundle.main.path(forResource: "Declaimer", ofType: "jpeg")
        return stringPath ?? ""
    }
    
    func fetchDisclaimerAudioFile() -> String {
        let stringPath = Bundle.main.path(forResource: "Brain_Wellness_Spa_Declaimer", ofType: "mp3")
        let urlPath = URL(fileURLWithPath: stringPath!)
        
        print("stringPath :- ",stringPath)
        print("relativeString :- ",urlPath.relativeString)
        print("relativePath :- ",urlPath.relativePath)
        
        return urlPath.relativeString
    }
    
    func saveDisclaimerAudioToDownloads() {
        let bundlePath = Bundle.main.path(forResource: "Brain_Wellness_Spa_Declaimer", ofType: "mp3")
        
        let directoryName = DJDownloadManager.shared.directoryName
        
        let directoryCreationResult = SDFileUtils.createDirectoryIfNotExists(withName: directoryName)
        guard directoryCreationResult.0 else {
            return
        }
        
        let fileManager = FileManager.default
        let documentsURL = SDFileUtils.documentDirectoryPath().appendingPathComponent(directoryName).appendingPathComponent("Brain_Wellness_Spa_Declaimer.mp3")

        do {
            try fileManager.copyItem(atPath: bundlePath!, toPath: documentsURL.path)
        }
        catch {
            print("\n")
            print(error)
        }
    }
    
}
