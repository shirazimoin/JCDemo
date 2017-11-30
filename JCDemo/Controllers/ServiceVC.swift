
import UIKit

// Protocal defination to send data to previous VC
protocol ServiceVCDelegate {
    func serviceData(S1: String!, S2: String!, S3: String!, index: Int!)
}

class ServiceVC: UIViewController {

    var sharedManager : Globals = Globals.sharedInstance
    var currItem : ItemM!
    var index : Int!
    var delegate : ServiceVCDelegate?

    @IBOutlet var topview : UIView!

    @IBOutlet var ivitem: UIImageView!
    @IBOutlet var lblname: UILabel!
    
    @IBOutlet var lblserv1P: UILabel!
    @IBOutlet var lblserv2P: UILabel!
    @IBOutlet var lblserv3P: UILabel!

    @IBOutlet var lblserv1Q: UILabel!
    @IBOutlet var lblserv2Q: UILabel!
    @IBOutlet var lblserv3Q: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sharedManager.setGradient(topView: topview)
        setUpPage()
        // Do any additional setup after loading the view.
    }
    
    // Page setup with required values
    func setUpPage(){
        
        self.lblname.text = currItem.name
        
        let imgURL = currItem.imageUrl
        let url = URL(string: imgURL)
        self.ivitem.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        self.lblserv1P.text = currItem.service1 + " KWD"
        self.lblserv2P.text = currItem.service2 + " KWD"
        self.lblserv3P.text = currItem.service3 + " KWD"
        
        self.lblserv1Q.text = String(currItem.service1Q)
        self.lblserv2Q.text = String(currItem.service2Q)
        self.lblserv3Q.text = String(currItem.service3Q)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnPlus(sender:UIButton){
        
        if sender.tag == 1 {
            self.lblserv1Q.text = String(Int(self.lblserv1Q.text!)! + 1)
        }
        else if sender.tag == 2 {
            self.lblserv2Q.text = String(Int(self.lblserv2Q.text!)! + 1)
        }
        else{
            self.lblserv3Q.text = String(Int(self.lblserv3Q.text!)! + 1)
        }
    }
    
    @IBAction func btnMinus(sender:UIButton){
        
        if sender.tag == 1 {
            if Int(self.lblserv1Q.text!)! > 0{
            self.lblserv1Q.text = String(Int(self.lblserv1Q.text!)! - 1)
            }
        }
        else if sender.tag == 2 {
            if Int(self.lblserv2Q.text!)! > 0{
            self.lblserv2Q.text = String(Int(self.lblserv2Q.text!)! - 1)
            }
        }
        else{
            if Int(self.lblserv3Q.text!)! > 0{
            self.lblserv3Q.text = String(Int(self.lblserv3Q.text!)! - 1)
            }
        }
    }
    
    @IBAction func btnBack(){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnAddBasket(){

        self.delegate?.serviceData(S1: self.lblserv1Q.text, S2: self.lblserv2Q.text, S3: self.lblserv3Q.text, index: index)
        _ = self.navigationController?.popViewController(animated: true)

    }
}
