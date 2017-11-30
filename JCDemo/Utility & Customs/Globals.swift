
import UIKit
import RSLoadingView

class Globals {
    
    static let sharedInstance = Globals()
    var gradient = CAGradientLayer()

    var storeList : [StoreM]!
    var itemList : [ItemM]!

    
    private init() {

    }
    
    func setGradient(topView : UIView){
        
        gradient.startPoint = CGPoint(x: CGFloat(0), y: CGFloat(1))
        gradient.endPoint = CGPoint(x: CGFloat(1), y: CGFloat(0))
        gradient.frame = topView.bounds
        gradient.colors = [ UIColor(red: 42.0/255.0, green: 92.0/255.0, blue: 169.0/255.0, alpha: 1.0).cgColor,UIColor(red: 128.0/255.0, green: 77.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor]
        gradient.locations = [0.0, 0.8]
        topView.layer.insertSublayer(gradient, at: 0)
    }
   

    @IBAction func showLoadingHub(onView : UIView) {
        let loadingView = RSLoadingView()
        loadingView.show(on: onView)
    }
    
    @IBAction func showOnViewTwins(onView : UIView) {
        let loadingView = RSLoadingView(effectType: RSLoadingView.Effect.twins)
        loadingView.show(on: onView)
    }
    
    func hideLoadingHub(fromView : UIView) {
        RSLoadingView.hide(from: fromView)
    }
    
    @IBAction func showOnWindow() {
        let loadingView = RSLoadingView()
        loadingView.showOnKeyWindow()
    }
    
    func hideLoadingHubFromKeyWindow() {
        RSLoadingView.hideFromKeyWindow()
    }
    
}
