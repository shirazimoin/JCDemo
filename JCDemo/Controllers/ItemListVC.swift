
import UIKit
import ObjectMapper
import Toast_Swift
import Kingfisher

class ItemListVC: UIViewController,UITableViewDelegate, UITableViewDataSource, ServiceVCDelegate {
    
    var sharedManager : Globals = Globals.sharedInstance
    
    @IBOutlet var topview : UIView!
    @IBOutlet var tvItemList :  UITableView!
    @IBOutlet var lbltotcnt : UILabel!
    
    var totcnt = 0
    var ItemList : [ItemM]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tvItemList.delegate = self
        tvItemList.dataSource = self
    
        tvItemList.rowHeight = UITableViewAutomaticDimension
        tvItemList.estimatedRowHeight = 200
        tvItemList.tableFooterView = UIView()
        
        loadDataFromLocal()
  
        // Do any additional setup after loading the view.
    }
    
    // protocol implementation to get data back
    func serviceData(S1: String!, S2: String!, S3: String!, index: Int!) {
            print(S1)
            print(S2)
            print(S3)

        totcnt = totcnt + Int(S1)! + Int(S2)! + Int(S3)! - self.ItemList[index].service1Q - self.ItemList[index].service2Q - self.ItemList[index].service3Q
        
         self.ItemList[index].service1Q = Int(S1)!
         self.ItemList[index].service2Q = Int(S2)!
         self.ItemList[index].service3Q = Int(S3)!
        
        
        if totcnt == 0{
            self.lbltotcnt.isHidden = true
        }
        else{
            self.lbltotcnt.isHidden = false
            self.lbltotcnt.text = String(totcnt)
        }
        
        tvItemList.reloadData()
    }
   
    override func viewWillAppear(_ animated: Bool) {
        
        self.sharedManager.setGradient(topView: topview)
        topview.layoutIfNeeded()
        
    }
    
    // load services from local
    func loadDataFromLocal(){
        
        setUI()
        if self.sharedManager.itemList != nil {
            
            onLoadDetailWith(progress: false)
        }
        else{
            
            onLoadDetailWith(progress: true)
        }
    }
    
    // set UI from local dataaa if available
    func setUI(){
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: Constants.KEYS.ITEMLIST) != nil {
            
            let itemList  = userDefaults.object(forKey: Constants.KEYS.ITEMLIST)
            self.sharedManager.itemList = Mapper<ItemM>().mapArray(JSONObject: itemList)
            
            self.ItemList = self.sharedManager.itemList
            self.tvItemList.reloadData()
        }
    }
    
    // call webservice and get data, upfateto locals
    func onLoadDetailWith(progress: Bool){
        
        if progress == true {
            
            sharedManager.showLoadingHub(onView: view)
        }
        
        AFWrapper.requestGETURL(Constants.URLS.ItemList, success: { (JSONResponse) in
            
            self.sharedManager.itemList = Mapper<ItemM>().mapArray(JSONObject: JSONResponse.rawValue)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.ITEMLIST)
            userDefaults.synchronize()
            
            self.sharedManager.hideLoadingHub(fromView: self.view)
            self.setUI()
            
        }) { (error) in
            
            print(error.localizedDescription)
            self.view.makeToast(Constants.Errors.SERVER_ERROR, duration: 3, position: .bottom)
        }
    }
    
    // Display tableview with dataa
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard  ((self.ItemList) != nil) else {
            return 0
        }
        return  (self.ItemList?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemCell
        
        cell.lblname.text = self.ItemList?[indexPath.row].name
      
        let imgURL = self.ItemList?[indexPath.row].imageUrl
        let url = URL(string: imgURL!)
        cell.ivitem.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        if (self.ItemList?[indexPath.row].service1Q)! + (self.ItemList?[indexPath.row].service2Q)! + (self.ItemList?[indexPath.row].service3Q)! > 0{
            
            let cnt = (self.ItemList?[indexPath.row].service1Q)! + (self.ItemList?[indexPath.row].service2Q)! + (self.ItemList?[indexPath.row].service3Q)!
            
            cell.lblservicecnt.text = String(cnt)
            cell.lblservicecnt.isHidden = false
            
        }
        else{
            
            cell.lblservicecnt.isHidden = true
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objVC: ServiceVC? = storyboard?.instantiateViewController(withIdentifier: "ServiceVC") as? ServiceVC
        objVC?.currItem = self.ItemList?[indexPath.row]
        objVC?.index = indexPath.row
        objVC?.delegate = self
        self.navigationController?.pushViewController(objVC!, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Back btn logic if any service selected
    @IBAction func btnBack(){
        
        if totcnt > 0{
        let alert = UIAlertController(title: "Clear Basket?", message: "You have items in your basket, going back now will clear your basket", preferredStyle: UIAlertControllerStyle.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Clear", style: UIAlertActionStyle.default, handler: { action in
            
            _ = self.navigationController?.popViewController(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        }
        else{
            _ = self.navigationController?.popViewController(animated: true)

        }
    }
    
    // This is just the checkout button, with selected services
    @IBAction func btnBasket(){
    
         self.view.makeToast("Checkout under development", duration: 4, position: .bottom)
    }
}
