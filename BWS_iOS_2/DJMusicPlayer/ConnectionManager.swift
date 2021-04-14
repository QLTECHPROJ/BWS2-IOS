//
//  ConnectionManager.swift
//  BWS
//
//  Created by Dhruvit on 29/10/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation

class ConnectionManager {
    
    static let sharedInstance = ConnectionManager()
    private var reachability : DJMusicPlayerReachability!
    
    func observeReachability() {
        self.reachability = DJMusicPlayerReachability()
        NotificationCenter.default.addObserver(self, selector:#selector(self.reachabilityChanged), name: NSNotification.Name.reachabilityChanged, object: nil)
        do {
            try self.reachability.startNotifier()
        }
        catch(let error) {
            print("Error occured while starting reachability notifications : \(error.localizedDescription)")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! DJMusicPlayerReachability
        switch reachability.connection {
        case .cellular:
            print("Network available via Cellular Data.")
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
            if DJMusicPlayer.shared.isStoppedBecauseOfNetwork {
                DJMusicPlayer.shared.currentlyPlaying = DJMusicPlayer.shared.currentlyPlaying
                DJMusicPlayer.shared.isStoppedBecauseOfNetwork = false
            }
            break
        case .wifi:
            print("Network available via WiFi.")
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
            if DJMusicPlayer.shared.isStoppedBecauseOfNetwork {
                DJMusicPlayer.shared.currentlyPlaying = DJMusicPlayer.shared.currentlyPlaying
                DJMusicPlayer.shared.isStoppedBecauseOfNetwork = false
            }
            break
        case .none:
            print("Network is not available.")
            NotificationCenter.default.post(name: NSNotification.Name.refreshDownloadData, object: nil)
            break
        }
    }
    
}
