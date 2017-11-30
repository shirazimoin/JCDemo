
import UIKit
import ObjectMapper

@objcMembers
class ItemM: NSObject, Mappable  {
    
    var id = ""
    var name = ""
    var imageUrl = ""
    var service1 = ""
    var service2 = ""
    var service3 = ""
    var service1Q = 0
    var service2Q = 0
    var service3Q = 0
    
    required init?(map: Map){
        
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        service1 <- map["service1"]
        service2 <- map["service2"]
        service3 <- map["service3"]
        service1Q <- map["service1Q"]
        service2Q <- map["service2Q"]
        service3Q <- map["service3Q"]
    }
    func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        imageUrl <- map["imageUrl"]
        service1 <- map["service1"]
        service2 <- map["service2"]
        service3 <- map["service3"]
        service1Q <- map["service1Q"]
        service2Q <- map["service2Q"]
        service3Q <- map["service3Q"]
    }
}
