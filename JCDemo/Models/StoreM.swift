
import UIKit
import ObjectMapper

@objcMembers
class StoreM: NSObject, Mappable  {
    
    var id = ""
    var createdAt = 0
    var name = ""
    var imageUrl = ""
    var areaId = ""
    var hasSubscription = false
    var rating = ""
    var email = ""
    var isActive = false
    var isTrackingEnabled = false
    var hasSpecialsServices = false
    var hasNormalServices = false
    var minOrderAmount = 0
  
    required init?(map: Map){
        
        id <- map["id"]
        createdAt <- map["createdAt"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        areaId <- map["areaId"]
        hasSubscription <- map["hasSubscription"]
        rating <- map["rating"]
        email <- map["email"]
        isActive <- map["isActive"]
        isTrackingEnabled <- map["isTrackingEnabled"]
        hasSpecialsServices <- map["hasSpecialsServices"]
        hasNormalServices <- map["hasNormalServices"]
        minOrderAmount <- map["minOrderAmount"]
        
    }
    func mapping(map: Map) {
        
        id <- map["id"]
        createdAt <- map["createdAt"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        areaId <- map["areaId"]
        hasSubscription <- map["hasSubscription"]
        rating <- map["rating"]
        email <- map["email"]
        isActive <- map["isActive"]
        isTrackingEnabled <- map["isTrackingEnabled"]
        hasSpecialsServices <- map["hasSpecialsServices"]
        hasNormalServices <- map["hasNormalServices"]
        minOrderAmount <- map["minOrderAmount"]
    }
}
