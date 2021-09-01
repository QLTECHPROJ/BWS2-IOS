//
//  Segment+EventsNames.swift
//  BWS_iOS_2
//
//  Created by Dhruvit on 19/05/21.
//  Copyright © 2021 Dhruvit. All rights reserved.
//

import Foundation

struct ScreenNames {
    
    // Authentication Related Screens
    let launch = "Launch Screen Viewed"
    let signUp = "SignUp Screen Viewed"
    let countryList = "Country List Viewed"
    let login = "Login Screen Viewed"
    let emailSent = "Email Sent Screen Viewed"
    let forgotPassword = "Forgot Password Screen Viewed"
    
    let assessmentStart = "Assessment Start Screen Viewed"
    let assessmentForm = "Assessment Screen Viewed"
    let wellnessScore = "Wellness Score Screen Viewed"
    
    let enhancePlanList = "Enhance Plan Screen Viewed"
    let orderSummary = "Order Summary Viewed"
    let thankYou = "Thank You Screen Viewed"
    
    let setupPin = "Set Up Pin Screen Viewed"
    let addUser = "Add User Screen Viewed"
    let invite_friend = "Invite Friends Screen Viewed"
    let coUserList = "Couser List Viewed"
    let forgotPin = "Forgot Pin Screen Viewed"
    
    let profile_form_start = "Profile Step Start Screen Viewed"
    let profile_query_screen = "Profile Query Screen viewed"
    let profileForm = "Profile Form Screen Viewed"
    
    let sleepTime = "Sleep Time Screen Viewed"
    let areaOfFocus = "Area of  Focus Screen Viewed"
    let preparingPlaylist = "Preparing Playlist Screen Viewed"
    let playlist_ready = " Playlist Ready Screen Viewed"
    
    let home = "Home Screen Viewed"
    let userListPopup = "User List Popup Viewed"
    let notificationList = "Notification List Viewed"
    
    let enhance = "Enhance Screen Viewed"
    
    let search_screen = "Search Screen Viewed"
    let suggested_audio_list = "Suggested Audios List Viewed"
    let suggested_playlist_list = "Suggested Playlist List Viewed"
    
    // Audio Related Screens
    let audio_view_all = "Audio ViewAll Screen Viewed"
    let recentlyPlayed = "Recently Played Viewed"
    let myDownloads = "My Downloads Viewed"
    let libraryList = "Library List Viewed"
    let getInspiredList = "Get Inspired List Viewed"
    let popularList = "Popular List Viewed"
    let topCategoriesItem = "Top Categories Item Viewed"
    
    let audio_details = "Audio Details Viewed"
    let add_to_playlist = "Add to Playlist Screen Viewed"
    
    // Playlist Related Screens
    let playlist = "Playlist Screen Viewed"
    let playlist_view_all = "View All Playlist Screen Viewed"
    let playlist_viewed = "Playlist Viewed"
    let playlist_details_viewed = "Playlist Details Viewed"
    
    // Reminder Related Screens
    let reminder = "Reminder Screen Viewed"
    let editReminder = "Add/Edit Reminder Screen Viewed"
    
    // Resources Related Screens
    let resourceScreen = "Resources Screen Viewed"
    let resourceDetails = "Resource Details Viewed"
    
    // Account Section Related Screens
    let account = "Account Screen Viewed"
    let account_info = "Account Info Screen Viewed"
    let edit_profile = "Edit Profile Screen Viewed"
    let change_pin = "Change Pin Screen Viewed"
    let delete_account = "Delete Account Screen Viewed"
    let change_password = "Change Password Screen Viewed"
    let cancel_subscription =  "Cancel Subscription Screen Viewed"
    let my_downloads_screen = "My Download Screen Viewed"
    let manage_user = "Manage User Screen Viewed"
    let faq_screen = "FAQ Viewed"
    
    let Billing_Order = "Billing & Order Screen Viewed"
    let Upgrade_Plan_Screen_Viewed = "Upgrade Plan Screen Viewed"
}


struct EventNames {
    
    // Push Notification Related Events
    let Push_Notification_Received = "Push Notification Received"
    let Push_Notification_Tapped = "Push Notification Tapped"
    
    // Authentication Related Events
    let Send_OTP_Clicked = "Send OTP Clicked"
    let Resend_OTP_Clicked = "Resend OTP Clicked"
    let OTP_Entered = "OTP Entered"
    let User_Sign_up = "User Sign up"
    let User_Login = "User Login"
    
    let Assessment_Form_Submitted = "Assessment Form Submitted"
    let Checkout_Proceeded = "Checkout Proceeded"
    let Checkout_Completed = "Checkout Completed"
    
    let Couser_Added = "Couser Added"
    let contact_searched = "Contact Searched"
    let invite_friend_clicked = "Invite Friend Clicked"
    let Forgot_Pin_Clicked = "Forgot Pin Clicked"
    
    let Explore_App_Clicked = "Explore App Clicked"
    
    let Profile_Form_Submitted = "Profile Form Submitted"
    let Area_of_Focus_Saved = "Area of Focus Saved"
    
    // Audio Related Events
    let Audio_Searched = "Audio Searched"
    let Suggested_Audio_Clicked = "Suggested Audio Clicked"
    let Search_Audio_Clicked = "Search Audio Clicked"
    
    let Add_to_Playlist_Clicked = "Add to Playlist Clicked"
    let Audio_Removed_From_Playlist = "Audio Removed From Playlist"
    
    // Audio Playback Related Events
    let Disclaimer_Started = "Disclaimer Started"
    let Disclaimer_Playing = "Disclaimer Playing"
    let Disclaimer_Paused = "Disclaimer Paused"
    let Disclaimer_Resumed = "Disclaimer Resumed"
    let Disclaimer_Interrupted = "Disclaimer Interrupted"
    let Disclaimer_Completed = "Disclaimer Completed"
    
    let Audio_Playback_Started = "Audio Playback Started"
    let Audio_Started = "Audio Started"
    let Audio_Playing = "Audio Playing"
    let Audio_Paused = "Audio Paused"
    let Audio_Resumed = "Audio Resumed"
    let Audio_Interrupted = "Audio Interrupted"
    let Audio_Buffer_Started = "Audio Buffer Started"
    let Audio_Buffer_Completed = "Audio Buffer Completed"
    let Audio_Seek_Started = "Audio Seek Started"
    let Audio_Seek_Completed = "Audio Seek Completed"
    let Audio_Completed = "Audio Completed"
    let Audio_Playback_Completed = "Audio Playback Completed"
    
    let Audio_Forward = "Audio Forward"
    let Audio_Backward = "Audio Backward"
    
    // Playlist Related Events
    let Playlist_Started = "Playlist Started"
    let Playlist_Completed = "Playlist Completed"
    
    let Playlist_Created = "Playlist Created"
    let Playlist_Renamed = "Playlist Renamed"
    let Playlist_Deleted = "Playlist Deleted"
    
    let Create_Playlist_Clicked = "Create Playlist Clicked"
    let Playlist_Rename_Clicked = "Playlist Rename Clicked"
    let Delete_Playlist_Clicked = "Delete Playlist Clicked"
    let Playlist_Search_Clicked = "Playlist Search Clicked"
    let Playlist_Audio_Sorted = "Playlist Audio Sorted"
    let Suggested_Playlist_Clicked = "Suggested Playlist Clicked"
    let Search_Playlist_Clicked = "Search Playlist Clicked"
    
    // Account Section Related Events
    let Profile_Changes_Saved = "Profile Changes Saved"
    let Camera_Photo_Added = "Camera Photo Added"
    let Gallery_Photo_Added = "Gallery Photo Added"
    let Profile_Photo_Cancelled = "Profile Photo Cancelled"
    
    let Login_Pin_Changed = "Login Pin Changed"
    let Password_Changed = "Password Changed"
    
    let Account_Deleted = "Account Deleted"
    let Co_User_Removed = "Co User Removed"
    
    let User_Logged_Out = "User Logged Out"
    
    // Billing Order
    let User_Plan_Upgraded = "User Plan Upgraded"
    let Subscription_Cancelled = "Subscription Cancelled"
    
    // Download Related Events
    let Audio_Download_Started = "Audio Download Started"
    let Audio_Download_Completed = "Audio Download Completed"
    let Downloaded_Audio_Removed = "Downloaded Audio Removed"
    
    let Playlist_Download_Started = "Playlist Download Started"
    let Playlist_Download_Completed = "Playlist Download Completed"
    let Downloaded_Playlist_Removed = "Downloaded Playlist Removed"
    
    // Reminder Related Events
    let Playlist_Reminder_Clicked = "Playlist Reminder Clicked"
    let Set_Reminder_Pop_Up_Clicked = "Set Reminder Pop Up Clicked"
    
    // Resources Related Events
    let Resources_Filter_Clicked = "Resources Filter Clicked"
    let Resource_External_Link_Clicked = "Resource External Link Clicked"
    
    // FAQ Related Events
    let FAQ_Clicked = "FAQ Clicked"
    
}
