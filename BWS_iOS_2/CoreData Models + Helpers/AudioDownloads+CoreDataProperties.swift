//
//  AudioDownloads+CoreDataProperties.swift
//  
//
//  Created by Dhruvit on 22/09/20.
//
//

import Foundation
import CoreData


extension AudioDownloads {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AudioDownloads> {
        return NSFetchRequest<AudioDownloads>(entityName: "AudioDownloads")
    }

    @NSManaged public var audioDescription: String?
    @NSManaged public var audioDirection: String?
    @NSManaged public var audioDuration: String?
    @NSManaged public var audioFile: String?
    @NSManaged public var audiomastercat: String?
    @NSManaged public var audioSubCategory: String?
    @NSManaged public var bitrate: String?
    @NSManaged public var download: String?
    @NSManaged public var downloadLocation: String?
    @NSManaged public var id: String?
    @NSManaged public var imageFile: String?
    @NSManaged public var isSingleAudio: String?
    @NSManaged public var like: String?
    @NSManaged public var name: String?
    @NSManaged public var playlistID: String?
    @NSManaged public var selfCreated: String?
    @NSManaged public var sortId: String?

}
