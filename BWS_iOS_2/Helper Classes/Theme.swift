//
//  File.swift
//  BWS
//
//  Created by Dhruvit on 12/08/20.
//  Copyright © 2020 Dhruvit. All rights reserved.
//

import Foundation
import SVProgressHUD

// Theme Did Change notification object
extension Notification.Name {
    static let ThemeDidChangeNotification = Notification.Name("themeDidChangeNotfication")
    static let likedOrDownloadedAudio = Notification.Name("likedOrDownloadedAudio")
    static let refreshLikedList = Notification.Name("refreshLikedList")
}

// SET APP THEME
var isSystemDarkMode: Bool = false {
    didSet {
        NotificationCenter.default.post(name: .ThemeDidChangeNotification, object: nil)
        SVProgressHUD.setDefaultStyle( isSystemDarkMode ? .dark : .light)
    }
}

// MARK: - Application Theme Color Palette
class ColorPalette: NSObject {

    let isDark: Bool
    let name: String
    let statusBarStyle: UIStatusBarStyle
    let navigationbarColor: UIColor
    let navigationbarTextColor: UIColor
    let background: UIColor
    let oppBackground: UIColor
    let primaryTextColor: UIColor
    let secondnaryTextColor: UIColor
    let cellBackgroundA: UIColor
    let cellBackgroundB: UIColor
    let cellDetailTextColor: UIColor
    let cellTextColor: UIColor
    let lightTextColor: UIColor
    let sectionHeaderTextColor: UIColor
    let separatorColor: UIColor
    let borderColor: UIColor
    let mediaCategorySeparatorColor: UIColor
    let tabBarColor: UIColor
    let themeUI: UIColor
    let gradientBlueDark = UIColor(0x1E88E5)
    let gradientBlueLight = UIColor(0x26C6DA)
    let toolBarStyle: UIBarStyle

    init(isDark: Bool,
                name: String,
                statusBarStyle: UIStatusBarStyle,
                navigationbarColor: UIColor,
                navigationbarTextColor: UIColor,
                background: UIColor,
                oppBackground: UIColor,
                primaryTextColor: UIColor,
                secondnaryTextColor: UIColor,
                cellBackgroundA: UIColor,
                cellBackgroundB: UIColor,
                cellDetailTextColor: UIColor,
                cellTextColor: UIColor,
                lightTextColor: UIColor,
                sectionHeaderTextColor: UIColor,
                separatorColor: UIColor,
                borderColor: UIColor,
                mediaCategorySeparatorColor: UIColor,
                tabBarColor: UIColor,
                themeUI: UIColor,
                toolBarStyle: UIBarStyle) {
        self.isDark = isDark
        self.name = name
        self.statusBarStyle = statusBarStyle
        self.navigationbarColor = navigationbarColor
        self.navigationbarTextColor = navigationbarTextColor
        self.background = background
        self.oppBackground = oppBackground
        self.primaryTextColor = primaryTextColor
        self.secondnaryTextColor = secondnaryTextColor
        self.cellBackgroundA = cellBackgroundA
        self.cellBackgroundB = cellBackgroundB
        self.cellDetailTextColor = cellDetailTextColor
        self.cellTextColor = cellTextColor
        self.lightTextColor = lightTextColor
        self.sectionHeaderTextColor = sectionHeaderTextColor
        self.separatorColor = separatorColor
        self.borderColor = borderColor
        self.mediaCategorySeparatorColor = mediaCategorySeparatorColor
        self.tabBarColor = tabBarColor
        self.themeUI = themeUI
        self.toolBarStyle = toolBarStyle
    }
}
let brightPalette = ColorPalette(isDark: false,
                                 name: "Default",
                                 statusBarStyle: .autoDarkContent,
                                 navigationbarColor: UIColor(0xFFFFFF),
                                 navigationbarTextColor: UIColor(0x000000),
                                 background: UIColor(0xFFFFFF),
                                 oppBackground: UIColor(0x1C1C1C),
                                 primaryTextColor: UIColor(0x000000),
                                 secondnaryTextColor: UIColor(0x84929C),
                                 cellBackgroundA: UIColor(0xFFFFFF),
                                 cellBackgroundB: UIColor(0xE5E5E3),
                                 cellDetailTextColor: UIColor(0x84929C),
                                 cellTextColor: UIColor(0x000000),
                                 lightTextColor: UIColor(0x888888),
                                 sectionHeaderTextColor: UIColor(0x25292C),
                                 separatorColor: UIColor(0xDADADA),
                                 borderColor: UIColor(0x707070),
                                 mediaCategorySeparatorColor: UIColor(0xECF2F6),
                                 tabBarColor: UIColor(0xFFFFFF),
                                 themeUI: UIColor(0x2BBDDE),
                                 toolBarStyle: UIBarStyle.default)

let darkPalette = ColorPalette(isDark: true,
                               name: "Dark",
                               statusBarStyle: .lightContent,
                               navigationbarColor: UIColor(0x1B1E21),
                               navigationbarTextColor: UIColor(0xFFFFFF),
                               background: UIColor(0x1C1C1C),
                               oppBackground: UIColor(0xFFFFFF),
                               primaryTextColor: UIColor(0xFFFFFF),
                               secondnaryTextColor: UIColor(0x84929C),
                               cellBackgroundA: UIColor(0x1B1E21),
                               cellBackgroundB: UIColor(0x494B4D),
                               cellDetailTextColor: UIColor(0x84929C),
                               cellTextColor: UIColor(0xFFFFFF),
                               lightTextColor: UIColor(0xB8B8B8),
                               sectionHeaderTextColor: UIColor(0x828282),
                               separatorColor: UIColor(0xDADADA),
                               borderColor: UIColor(0x707070),
                               mediaCategorySeparatorColor: UIColor(0x25292C),
                               tabBarColor: UIColor(0x25292C),
                               themeUI: UIColor(0x2BBDDE),
                               toolBarStyle: UIBarStyle.black)

// MARK: - Application Theme
struct Theme {
    
    static var shared = Theme()
    
    static var colors = AppColors()
    static var images = AppImages()
    static var strings = AppStrings()
    static var fonts = AppFonts()
    static var dateFormats = AppDateFormats()
    
    func changeTheme() {
        Theme.colors = AppColors()
        Theme.images = AppImages()
        Theme.strings = AppStrings()
        Theme.fonts = AppFonts()
        Theme.dateFormats = AppDateFormats()
    }
    
}


// MARK: - Application Images
struct AppImages {
    let btnBgWOShadow = UIImage(named: "btnBgWOShadow")
}


// MARK: - Application Colors
struct AppColors {
    
//    var themeColors: ColorPalette {
//        get {
//            if isSystemDarkMode {
//                return darkPalette
//            }
//            return brightPalette
//        }
//    }
    
    let white = UIColor.white
    let black = UIColor.black
    let blue = UIColor.blue
    let red = UIColor.red
    
    let white_40_opacity = UIColor.black.withAlphaComponent(0.4)
    let black_40_opacity = UIColor.black.withAlphaComponent(0.4)
    let gray_313131_80_opacity = UIColor(hex: "313131").withAlphaComponent(0.8)
    
    let indexScoreColor = UIColor(hex: "B8DAFF")
    
    let gray_313131 = UIColor(hex: "313131")
    let gray_DDDDDD = UIColor(hex: "DDDDDD")
    let gray_7E7E7E = UIColor(hex: "7E7E7E")
    let gray_707070 = UIColor(hex: "707070")
    let gray_999999 = UIColor(hex: "999999")
    let gray_EEEEEE = UIColor(hex: "EEEEEE")
    let gray_CDD4D9 = UIColor(hex: "CDD4D9")
    
    let off_white_F9F9F9 = UIColor(hex: "F9F9F9")
    
    let skyBlue = UIColor(hex: "72C2DD")
    let sky_blue_light_E4F3F3 = UIColor(hex: "E4F3F3")
    
    let red_CE5060 = UIColor(hex: "CE5060")
    
    let pink_FFDFEA = UIColor(hex: "FFDFEA")
    let magenta_C44B6C = UIColor(hex: "C44B6C")
    
    let green_008892 = UIColor(hex: "008892")
    let green_A2EEC5 = UIColor(hex: "A2EEC5")
    let green_27B86A = UIColor(hex: "27B86A")
    let green_36C2D6 = UIColor(hex: "36C2D6")
    let green_1597AA = UIColor(hex: "1597AA")
    
    let blue_B8E1F7 = UIColor(hex: "B8E1F7")
    let blue_38667E = UIColor(hex: "38667E")
    
    let orange_F89552 = UIColor(hex: "F89552")
    let orange_FE8D7D = UIColor(hex: "FE8D7D")
    let orange_F1646A = UIColor(hex: "F1646A")
    
    let purple = UIColor(hex: "6C63FF")
    
    let textColor = UIColor(hex: "313131")
}


// MARK: - Application Fonts
struct AppFonts {
    
    let MontserratLight = "Montserrat-Light"
    let MontserratRegular = "Montserrat-Regular"
    let MontserratMedium = "Montserrat-Medium"
    let MontserratSemiBold = "Montserrat-SemiBold"
    let MontserratBold = "Montserrat-Bold"
    
    func montserratFont(ofSize size : CGFloat, weight : UIFont.Weight) -> UIFont {
        switch weight {
        case .light:
            return UIFont(name: MontserratLight, size: size) ?? UIFont.systemFont(ofSize: size, weight: .light)
        case .medium:
            return UIFont(name: MontserratMedium, size: size) ?? UIFont.systemFont(ofSize: size, weight: .medium)
        case .semibold:
            return UIFont(name: MontserratSemiBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
        case .bold:
            return UIFont(name: MontserratBold, size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
        default:
            return UIFont(name: MontserratRegular, size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
        }
    }
    
}


// MARK: - Application Date Formats
struct AppDateFormats {
    let backend = "yyyy-MM-dd'T'HH:mm:ss.SSSXXX"
    let backend2 = "yyyy-MM-dd HH:mm:ss"
    let common = "dd/MM/yyyy"
    let navigationBarFormat = "EEEE, MMMM dd"
    let eventsFormat = "MMM dd, yyyy"
    let eventStartDateFormat = "yyyy-MM-dd hh:mm:ss"
    let comment = "MMM dd, yyyy, hh:mm a"
    let DOB_Backend = "yyyy-MM-dd"
    let DOB_App = "dd MMM, yyyy"
}


// MARK: - Application Strings
struct AppStrings {
    
    let disclaimer_title = "Disclaimer"
    let disclaimer_description = "The Brain Wellness App offers a unique, alternative and drug free method created by our founder Terri Bowman aimed to assist people encountering struggles in their daily lives, to find inner peace and overcome negative thoughts and emotions (the Brain Wellness App Method). \n\nThe Brain Wellness App Method is not a scientific method. \n\nThe testimonials of our clients speak for themselves and we are so proud of the incredible results they have achieved – we want to help you and are committed to assisting you find a way to live a better life. However, as with any service, we accept that it may not be right for everyone and that results may vary from client to client. Accordingly, we make no promises or representations that our service will work for you but we invite you to try it for yourself."
    
    /* UserDefault Keys */
    let logged_in_user = "logged_in_user"
    
    /* Button Titles */
    let ok = "OK"
    let cancel = "CANCEL"
    let yes = "YES"
    let no = "NO"
    let logout = "LOG OUT"
    
    /* App Update Popup */
    let update = "UPDATE"
    let not_now = "NOT NOW"
    
    let normal_update_title = "Update Brain Wellness App"
    let normal_update_subtitle = "Brain Wellness App recommends that you update to the latest version"
    
    let force_update_title = "Update Required"
    let force_update_subtitle = "To keep using Brain Wellness App, download the latest version"
    
    /* Common Strings */
    let please_wait = "Please wait"
    
    /* Screen Contents */
    let welcome_title = "The Brain Wellness Spa App"
    let welcome_subtitle = "Your one-stop solution for mental & emotional health challenges"
    
    let register_title = "Welcome to Brain wellness spa"
    let register_subtitle = "We just need few details to get you started!!"
    
    let login_title = "Welcome back..."
    let login_subtitle = "Hope you're feeling much better than you felt before!!"
    
    let forgot_password_title = "Forgot your password"
    let forgot_password_subtitle = "Give us your registered email ID and we'll send you everything that you'll need to change your password"
    
    let couser_listing_title = "Welcome to Brain wellness spa"
    let couser_listing_subtitle = "Simply sign-in to your account and continue your journey towards mental & emotional transformation"
    
    let couser_welcome_subtitle = "It's good to have you here..."
    
    let tap_anywhere_to_continue = "TAP anywhere to continue"
    let step_1_title = "Step 1"
    let step_2_title = "Step 2"
    let step_3_title = "Step 3"
    
    let step_1_subtitle = "Simply fill in your assessment form and we'll recommend the programs best suited for your needs"
    let step_2_subtitle = "Let's assess how you are \ncurrently doing"
    let step_3_subtitle = "we're analysing your inputs"
    
    let prev_drug_use_subtitle = "Have you ever taken any illicit drugs in your life?"
    
    let do_the_assessment_subtitle_one = "We're done with the first part."
    let do_the_assessment_subtitle_two = "In the next step, you will have to fill an assessment form which will help us assess your mental health."
    
    let index_score_subtitle = "The index score determines the intensity of your mental health challenge and based on your score we will recommend the programs to help you."
    
    let you_are_doing_good_title = "You are Doing Good"
    let you_are_doing_good_subtitle = "We are analysing the information you have provided and devising a personalised treatment plan for just for you."
    
    let manage_plan_list_access_audios = "Access More Than 75 Audio Programs."
    let manage_plan_list_introductory_session = "Self reported date of 2173 clients before and after the introductory session"
    let manage_plan_list_testimonials = "SEE REAL TESTIMONIALS \nFROM REAL CUSTOMERS"
    
    let enhance_program = "Enhance Program"
    
    let thank_you_subtitle = "Congratulations on joining the Brain Wellness Spa Membership"
    
    let recommended_category_subtitle = "You can select upto three areas of focus to further customise your journey towards mental transformation."
    
    let preparing_playlist_title = "Preparing your \npersonalised playlist"
    let preparing_playlist_subtitle = "Thank you for providing us with the information, We are preparing personlalised playlists for you."
    
    let you_playlist_is_ready_title = "You playlist is ready"
    let you_playlist_is_ready_subtitle = "We recommend that you listen to the audios while going to sleep to experience to get the maximum benefits from the program."
    
    /* Alert Strings */
    let alert_check_internet = "Internet connection seems to be offline."
    let alert_something_went_wrong = "Something went wrong"
    
    let alert_logout = "Are you sure want to logout?"
    let alert_blank_inputField_error = "Please fill required details"
    
    let alert_search_term_not_found = "Search term not found please use another one"
    let alert_country_search = "Sorry we are not available in this country yet"
    
    // Auth & Profile
    let alert_blank_mobile_error = "Please enter your mobile number"
    let alert_invalid_mobile_error = "Please provide a valid mobile number"
    let alert_invalid_otp = "Please enter the SMS code"
    
    let alert_blank_fullname_error = "Please provide a Name"
    let alert_blank_dob_error = "Date of Birth should not be blank"
    let alert_dob_error = "You must be 18 years of age to register"
    let alert_invalid_fullname_error = "Please enter valid Name"
    
    let alert_blank_email_error = "Email address is required"
    let alert_invalid_email_error = "Please provide a valid email address"
    let alert_camera_not_available = "Camera is not available on this device."
    
    let alert_blank_password_error = "Please enter password"
    let alert_invalid_password_error = "Password should contain at least one uppercase, one lowercase, one special symbol and minimum 8 character long"
    let alert_password_not_match = "Password and confirm password not match"
    
    let alert_select_login_user = "Please select atleast one to proceed"
    
    // Audio
    let alert_blank_search = "Please enter search text"
    
    // Playlist
    let alert_blank_playlist_name = "Playlist name is required"
    
    // Billing Current Plan
    let alert_plan_already_canceled = "Your membership plan has been already canceled."
    
    // Billing Address
    let alert_blank_country = "Please enter a valid country"
    let alert_blank_addressLine = "Address Line is required"
    let alert_blank_City = "Suburb / Town / City is required"
    let alert_blank_State = "State is required"
    let alert_blank_postalCode = "Postcode is required"
    
    let alert_reactivate_plan = "Please re-activate your membership plan"
    
    let alert_disclaimer_playing = "The audio shall start playing after the disclaimer."
    let alert_disclaimer_playlist_add = "The audio shall add after playing the disclaimer"
    let alert_disclaimer_playlist_sorting = "The audio shall sort after the disclaimer"
    let alert_disclaimer_playlist_remove = "Currently you play this playlist, you can't remove last audio"
    
    let alert_playing_playlist_remove = "Currently this playlist is in player,so you can't delete this playlist as of now."
    let alert_playing_audio_remove = "Currently this audio is in player,so you can't delete this audio as of now."
    
    let alert_select_category = "Please Select Category"
    let alert_max_category = "You can select maximum 3 categories"
    
    let alert_removed_from_downloads = "Removed from your downloads"
    
    // Download
    let alert_audio_already_downloaded = "Audio has been already added to download list."
    let alert_audio_download_started = "Audio download has been started."
    let alert_audio_downloaded = "Audio download complete and added to your downloads"
    let alert_redownload_audio = "Audio download was incomplete, will be downloaded automatically when online."
    let alert_audio_download_error = "An errored while downloading audio."
    let alert_audio_delete_error = "An error occured while deleting audio."
    let alert_audios_delete_error = "An error occured while deleting audios."
    
    let alert_playlist_removed = "Playlist has been removed."
    let alert_playlist_already_downloaded = "Playlist has been already added to download list."
    let alert_playlist_download_started = "Playlist download has been started."
    let alert_playlist_downloaded = "Playlist download complete and added to your downloads"
    let alert_redownload_playlist = "Playlist download was incomplete, will be downloaded automatically when online."
    let alert_playlist_download_error = "An errored while downloading playlist."
    let alert_playlist_delete_error = "An error occured while deleting playlist."
    let alert_playlists_delete_error = "An error occured while deleting playlists."
    
    let alert_select_day_and_time = "Please select days and Time"
}

// MARK: - UIStatusBarStyle - autoDarkContent

extension UIStatusBarStyle {
    static var autoDarkContent: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

@objc extension UIColor {

    convenience init(_ rgbValue: UInt32, _ alpha: CGFloat = 1.0) {
        let r = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((rgbValue & 0xFF00) >> 8) / 255.0
        let b = CGFloat(rgbValue & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b, alpha: 1.0)
    }

    private func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            assertionFailure()
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)

        if components.count == 4 {
            a = Float(components[3])
        }

        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }

    var toHex: String? {
        return toHex()
    }
}
