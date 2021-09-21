//
//  CleverTap.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 03/09/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation
import CleverTapSDK

class CleverTapTracking {
    
    static var shared = CleverTapTracking()
    
    func identifyUser() {
        if let userDetails = CoUserDataModel.currentUser {
            
            let userName = userDetails.Name.trim.count > 0 ? userDetails.Name : "Guest"
            
            var dictUserDetails : [String:Any] = [
                "userId":CoUserDataModel.currentUserId,
                "userGroupId":LoginDataModel.currentMainAccountId,
                "isAdmin":userDetails.isAdminUser,
                "deviceId":DEVICE_UUID,
                "deviceType":"iOS",
                "Identity":CoUserDataModel.currentUserId,
                "Name":userName,
                "Email":userDetails.Email,
                "Phone":"+" + userDetails.CountryCode + userDetails.Mobile,
                "DOB":userDetails.DOB,
                "Photo":userDetails.Image,
                "mobile":userDetails.Mobile,
                "countryCode":userDetails.CountryCode,
                "isProfileCompleted":userDetails.isProfileCompleted == "1" ? true : false,
                "isAssessmentCompleted":userDetails.isAssessmentCompleted == "1" ? true : false,
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
            
            if let planDetails = userDetails.planDetails.first {
                var dictPlanDetails = [String:Any]()
                dictPlanDetails["PlanId"] = planDetails.PlanId
                dictPlanDetails["PlanStatus"] = planDetails.PlanStatus
                dictPlanDetails["OriginalTransactionId"] = planDetails.OriginalTransactionId
                dictPlanDetails["TransactionId"] = planDetails.TransactionId
                dictPlanDetails["PlanPurchaseDate"] = planDetails.PlanPurchaseDate
                dictPlanDetails["PlanExpireDate"] = planDetails.PlanExpireDate
                dictPlanDetails["TrialPeriodStart"] = planDetails.TrialPeriodStart
                dictPlanDetails["TrialPeriodEnd"] = planDetails.TrialPeriodEnd
                
                dictUserDetails["planDetails"] = dictPlanDetails
            }
            
            dictUserDetails["deviceType"] = "iOS"
            dictUserDetails["appVersion"] = APP_VERSION
            dictUserDetails["deviceID"] = DEVICE_UUID
            dictUserDetails["batteryLevel"] = NSString(format: "%0.0f",APPDELEGATE.batteryLevel)
            dictUserDetails["batteryState"] = APPDELEGATE.batteryState
            dictUserDetails["fcmToken"] = FCM_TOKEN
            dictUserDetails["deviceToken"] = DEVICE_TOKEN
            
            // optional fields. controls whether the user will be sent email, push etc.
            dictUserDetails["MSG-push"] = true                      // Enable push notifications
            dictUserDetails["MSG-email"] = true                     // Enable email notifications
            dictUserDetails["MSG-sms"] = true                       // Enable SMS notifications
            dictUserDetails["MSG-whatsapp"] = true                  // Enable WhatsApp notifications
            
            CleverTap.sharedInstance()?.onUserLogin(dictUserDetails)
            CleverTap.sharedInstance()?.profilePush(dictUserDetails)
            // CleverTap.sharedInstance()?.recordEvent("CleverTap SDK Integrated")
            print("CleverTap Events")
        }
    }
    
    func trackEvent(name : String) {
        CleverTap.sharedInstance()?.recordEvent(name)
    }
    
    func trackScreen(name : String) {
        CleverTap.sharedInstance()?.recordScreenView(name)
    }
    
}
