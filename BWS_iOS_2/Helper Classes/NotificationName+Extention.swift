//
//  NotificationName+Extention.swift
//  BWS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation

/************************ Application Notifications Model ************************/

extension NSNotification.Name {
    static let pauseYouTubeVideo = NSNotification.Name.init("pauseYouTubeVideo")
    static let refreshData = NSNotification.Name.init("refreshData")
    static let refreshPlaylist = NSNotification.Name.init("refreshPlaylist")
    static let refreshDownloadData = NSNotification.Name.init("refreshDownloadData")
    static let refreshDownloadProgress = NSNotification.Name.init("refreshDownloadProgress")
}
