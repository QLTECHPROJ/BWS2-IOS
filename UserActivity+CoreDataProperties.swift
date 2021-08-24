//
//  UserActivity+CoreDataProperties.swift
//  BWS_iOS_2
//
//  Created by Mac Mini on 24/08/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//
//

import Foundation
import CoreData


extension UserActivity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserActivity> {
        return NSFetchRequest<UserActivity>(entityName: "UserActivity")
    }

    @NSManaged public var audioId: String?
    @NSManaged public var completedTime: String?
    @NSManaged public var playlistId: String?
    @NSManaged public var startTime: String?
    @NSManaged public var userId: String?
    @NSManaged public var volume: String?

}
