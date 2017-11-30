
import UIKit

struct Constants {
    
    static let buildName = "JCDemo"
    
    struct ScreenSize
    {
        static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
        static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
        static let SCREEN_MAX_LENGTH = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
        static let SCREEN_MIN_LENGTH = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
    }
    
    struct DeviceType
    {
        static let IS_IPHONE_4_OR_LESS =  UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
        static let IS_IPHONE_5 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
        static let IS_IPHONE_6 = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
        static let IS_IPHONE_6P = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
        static let IS_IPHONE_X = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 812.0
        static let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
    }
    
    struct URLS {
        //web api urls
        
        static let BASE_URL = "https://5a12745f748faa001280a746.mockapi.io/v1/stores/"
       
        static let StoreList = BASE_URL + "storelist"
        static let ItemList = BASE_URL + "item"
    }
    
    struct Errors {
        // Static messages for the app
        static let SERVER_ERROR = "Server error. Please try again later"
       static let NO_SEARCH_DATA = "No Search Result Found."
    }
    
    struct  KEYS {
        
        // keys to remember
        static let ITEMLIST = "itemList"
        static let STORELIST = "storeList"
    }

    
    enum ErrorTypes: Error {
        case Empty
        case Short
    }
    
    
    

}
