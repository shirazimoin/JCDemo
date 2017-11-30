
import UIKit
import Alamofire
import SwiftyJSON

class AFWrapper: NSObject {
     class func requestGETURL(_ strURL: String, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void) {
          Alamofire.request(strURL).responseJSON { (responseObject) -> Void in
               
               print(responseObject)
               
               if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
               }
               if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
               }
          }
     }
     
     class func requestPOSTURL(_ strURL : String, params : [String : AnyObject]?, headers : [String : String]?, success:@escaping (JSON) -> Void, failure:@escaping (Error) -> Void){
        
        print(strURL)
          Alamofire.request(strURL, method: .post, parameters: params, headers: headers).responseJSON { (responseObject) -> Void in
               
               print(responseObject)
               
               if responseObject.result.isSuccess {
                    let resJson = JSON(responseObject.result.value!)
                    success(resJson)
               }
               if responseObject.result.isFailure {
                    let error : Error = responseObject.result.error!
                    failure(error)
               }
          }
     }
    
    
}
