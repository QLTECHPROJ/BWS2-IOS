//
//  PlaylistDownloads+CoreDataProperties.swift
//  
//
//  Created by Dhruvit on 22/09/20.
//
//

import Foundation
import CoreData


extension PlaylistDownloads {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PlaylistDownloads> {
        return NSFetchRequest<PlaylistDownloads>(entityName: "PlaylistDownloads")
    }
    
    @NSManaged public var coUserID: String?
    @NSManaged public var created: String?
    @NSManaged public var download: String?
    @NSManaged public var playlistDesc: String?
    @NSManaged public var playlistID: String?
    @NSManaged public var playlistImage: String?
    @NSManaged public var playlistImageDetail: String?
    @NSManaged public var playlistMastercat: String?
    @NSManaged public var playlistName: String?
    @NSManaged public var playlistSubcat: String?
    @NSManaged public var selfCreated: String?
    @NSManaged public var totalAudio: String?
    @NSManaged public var totalDuration: String?
    @NSManaged public var totalhour: String?
    @NSManaged public var totalminute: String?
    
}
