//
//  Segment+Functions.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 10/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import Segment
import AVKit

enum TrackingType {
    case identify
    case screen
    case track
}

class SegmentTracking {
    
    static var shared = SegmentTracking()
    
    static var screenNames = ScreenNames()
    static var eventNames = EventNames()
    
    var isConfigured = false
    
    // Segment Write Keys
    // segmentWriteKey = "43bAg2MDfphRaYWFqZvWo7nxNhVtg8jt" // dhruvit@qltech.com.au
    // segmentWriteKeySapna = "MpDOpy9WI8Kt86nteyY5aNAML5F9PMTd" // sapna@qltech.com.au
    var segmentWriteKey : String {
        get {
            return UserDefaults.standard.string(forKey: "segmentWriteKey") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "segmentWriteKey")
            UserDefaults.standard.synchronize()
        }
    }
    
    var userIdentityTracked : Bool {
        get {
            return UserDefaults.standard.bool(forKey: "userIdentityTracked")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userIdentityTracked")
            UserDefaults.standard.synchronize()
        }
    }
    
    func configureSegment(launchOptions : [AnyHashable : Any]? = nil) {
        if segmentWriteKey.trim.count > 0 {
            isConfigured = true
            
            segmentWriteKey = "MpDOpy9WI8Kt86nteyY5aNAML5F9PMTd"
            
            let configuration = AnalyticsConfiguration(writeKey: segmentWriteKey)
            configuration.trackApplicationLifecycleEvents = true
            configuration.trackDeepLinks = true
            configuration.trackPushNotifications = true
            configuration.recordScreenViews = false
            if launchOptions != nil {
                configuration.launchOptions = launchOptions
            }
            Analytics.setup(with: configuration)
            Analytics.debug(true)
        }
    }
    
    func trackEvent(name : String, traits : [String:Any]?, trackingType : TrackingType) {
        if isConfigured == false {
            return
        }
        
        var newTraits = [String:Any]()
        if let oldTraits = traits {
            for (key,value) in oldTraits {
                newTraits[key] = value
            }
        }
        
        newTraits["deviceType"] = "iOS"
        newTraits["appVersion"] = APP_VERSION
        newTraits["deviceID"] = DEVICE_UUID
        newTraits["batteryLevel"] = NSString(format: "%0.0f",APPDELEGATE.batteryLevel)
        newTraits["batteryState"] = APPDELEGATE.batteryState
        
        if name == "Audio Interrupted" || name == "Disclaimer Interrupted" {
            self.callAudioInterruptionAPI(parameters: newTraits)
        }
        
        switch trackingType {
        case .identify:
            Analytics.shared().identify(name, traits: traits)
            break
        case .screen:
            Analytics.shared().screen(name, properties: newTraits)
            break
        case .track:
            Analytics.shared().track(name, properties: newTraits)
            break
        }
    }
    
    func identifyUser() {
        if let userDetails = CoUserDataModel.currentUser {
            userIdentityTracked = true
            
            let userName = userDetails.Name.trim.count > 0 ? userDetails.Name : "Guest"
            
            var dictUserDetails : [String:Any] = [
                "userId":CoUserDataModel.currentUserId,
                "userGroupId":LoginDataModel.currentMainAccountId,
                "isAdmin":userDetails.isAdminUser,
                "id":CoUserDataModel.currentUserId,
                "deviceId":DEVICE_UUID,
                "deviceType":"iOS",
                "name":userName,
                "email":userDetails.Email,
                "phone":userDetails.Mobile,
                "dob":userDetails.DOB,
                "profileImage":userDetails.Image,
                "isProfileCompleted":userDetails.isProfileCompleted,
                "isAssessmentCompleted":userDetails.isAssessmentCompleted,
                "wellnessScore":userDetails.indexScore,
                "scoreLevel":userDetails.ScoreLevel,
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            dictUserDetails["areaOfFocus"] = areaOfFocusArray
            
            // "Plan":userDetails.planDetails,
            // "PlanStatus":userDetails.PlanStatus,
            // "planStartDt":userDetails.PlanStartDt,
            // "planExpiryDt":userDetails.PlanExpiryDate,
            // "countryCode":userDetails.CountryCode,
            // "countryName":userDetails.CountryName]
            
            SegmentTracking.shared.trackEvent(name: CoUserDataModel.currentUserId, traits: dictUserDetails, trackingType: .identify)
        }
    }
    
    func coUserEvent(name : String, trackingType : TrackingType) {
        if let userDetails = CoUserDataModel.currentUser {
            
            let userName = userDetails.Name.trim.count > 0 ? userDetails.Name : "Guest"
            
            var dictUserDetails : [String:Any] = [
                "userId":CoUserDataModel.currentUserId,
                "userGroupId":LoginDataModel.currentMainAccountId,
                "isAdmin":userDetails.isAdminUser,
                "id":CoUserDataModel.currentUserId,
                "deviceId":DEVICE_UUID,
                "deviceType":"iOS",
                "name":userName,
                "email":userDetails.Email,
                "phone":userDetails.Mobile,
                "dob":userDetails.DOB,
                "profileImage":userDetails.Image,
                "isProfileCompleted":userDetails.isProfileCompleted,
                "isAssessmentCompleted":userDetails.isAssessmentCompleted,
                "wellnessScore":userDetails.indexScore,
                "scoreLevel":userDetails.ScoreLevel,
                "avgSleepTime":userDetails.AvgSleepTime
            ]
            
            var areaOfFocusArray = [[String:Any]]()
            
            for areaOfFocus in userDetails.AreaOfFocus {
                let objAreaOfFocus = ["MainCat":areaOfFocus.MainCat,"RecommendedCat":areaOfFocus.RecommendedCat]
                areaOfFocusArray.append(objAreaOfFocus)
            }
            
            dictUserDetails["areaOfFocus"] = areaOfFocusArray
            
            // "Plan":userDetails.planDetails,
            // "PlanStatus":userDetails.PlanStatus,
            // "planStartDt":userDetails.PlanStartDt,
            // "planExpiryDt":userDetails.PlanExpiryDate,
            // "countryCode":userDetails.CountryCode,
            // "countryName":userDetails.CountryName]
            
            SegmentTracking.shared.trackEvent(name: name, traits: dictUserDetails, trackingType: trackingType)
        }
    }
    
    func reset() {
        Analytics.shared().reset()
    }
    
    func flush() {
        Analytics.shared().flush()
    }
    
}
