
import UIKit
import ObjectMapper
import Toast_Swift
import Kingfisher

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIActionSheetDelegate{

    var sharedManager : Globals = Globals.sharedInstance
    var StoreList : [StoreM]!
    var actStoreList : [StoreM]!
   
    @IBOutlet var tvStoreList :  UITableView!
    @IBOutlet var sbSearchBar : UISearchBar?

    @IBOutlet var vwfilter : UIView!
    @IBOutlet var vwblur : UIView!

    @IBOutlet var btnTracking : UIButton!
    @IBOutlet var btnSub : UIButton!
    @IBOutlet var btnSpecial : UIButton!
    @IBOutlet var btnNormal : UIButton!

    @IBOutlet var topview : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tvStoreList.delegate = self
        tvStoreList.dataSource = self
        sbSearchBar?.delegate = self

        tvStoreList.rowHeight = UITableViewAutomaticDimension
        tvStoreList.estimatedRowHeight = 200
        tvStoreList.tableFooterView = UIView()
       
        sbSearchBar?.isTranslucent = true
        sbSearchBar?.backgroundImage = UIImage()
        sbSearchBar?.scopeBarBackgroundImage = UIImage()
        sbSearchBar?.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.sharedManager.setGradient(topView: topview)
        topview.layoutIfNeeded()
        loadDataFromLocal()

    }
    
    func loadDataFromLocal(){
        
        setUI()
        if self.sharedManager.storeList != nil {
            
            onLoadDetailWith(progress: false)
        }
        else{
            
            onLoadDetailWith(progress: true)
        }
    }
    
    // set UI with local data 
    func setUI(){
        
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: Constants.KEYS.STORELIST) != nil {
            
            let storeList  = userDefaults.object(forKey: Constants.KEYS.STORELIST)
            self.sharedManager.storeList = Mapper<StoreM>().mapArray(JSONObject: storeList)
            
            self.StoreList = self.sharedManager.storeList
            self.actStoreList = self.sharedManager.storeList
            self.tvStoreList.reloadData()
        }
    }
    
    // Call webservice
    func onLoadDetailWith(progress: Bool){
        
        if progress == true {
            
            sharedManager.showLoadingHub(onView: view)
        }
        
          AFWrapper.requestGETURL(Constants.URLS.StoreList, success: { (JSONResponse) in
           
            self.sharedManager.storeList = Mapper<StoreM>().mapArray(JSONObject: JSONResponse.rawValue)
            
            let userDefaults = UserDefaults.standard
            userDefaults.set(JSONResponse.rawValue, forKey: Constants.KEYS.STORELIST)
            userDefaults.synchronize()
            
            self.sharedManager.hideLoadingHub(fromView: self.view)
            self.setUI()
            
        }) { (error) in
           
            print(error.localizedDescription)
            self.view.makeToast(Constants.Errors.SERVER_ERROR, duration: 3, position: .bottom)
        }
    }
    
    // Display tableview data
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard  ((self.actStoreList) != nil) else {
            return 0
        }
        return  (self.actStoreList?.count)!;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! StoreListCell
        cell.lblname.text = self.actStoreList?[indexPath.row].name
        cell.lblminord.text =   "\(self.actStoreList?[indexPath.row].minOrderAmount ?? 0)" + " KWD"
        cell.ratstore.rating = Double((self.actStoreList?[indexPath.row].rating)!)!
        
        if self.actStoreList?[indexPath.row].isTrackingEnabled == true{
            
            cell.imgtrack.isHidden = false
        }
        else{
            cell.imgtrack.isHidden = true
        }
        
        let imgURL = self.actStoreList?[indexPath.row].imageUrl
        let url = URL(string: imgURL!)
        cell.ivstore.kf.setImage(with: url, placeholder: nil , options: nil, progressBlock: nil, completionHandler: nil)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objVC: ItemListVC? = storyboard?.instantiateViewController(withIdentifier: "ItemListVC") as? ItemListVC

        self.navigationController?.pushViewController(objVC!, animated: true)
    }
    
    // Code for Sorting
    @IBAction func btnSort(){
        
        let actionSheetController = UIAlertController(title: "Sort by", message: "Select any option", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { action -> Void in
        }
        actionSheetController.addAction(cancelActionButton)
        
        let saveActionButton = UIAlertAction(title: "Rating", style: .default) { action -> Void in
            self.actStoreList = self.actStoreList.sorted { $0.rating > $1.rating }
            self.StoreList = self.StoreList.sorted { $0.rating > $1.rating }

            self.tvStoreList.reloadData()
        }
        actionSheetController.addAction(saveActionButton)
        
        let deleteActionButton = UIAlertAction(title: "Minimum Order Value", style: .default) { action -> Void in
            self.actStoreList = self.actStoreList.sorted { $0.minOrderAmount < $1.minOrderAmount }
            self.StoreList = self.StoreList.sorted { $0.minOrderAmount < $1.minOrderAmount }

            self.tvStoreList.reloadData()
        }
        actionSheetController.addAction(deleteActionButton)
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    // Code for Search
    @IBAction func btnSearch(){
        
        if sbSearchBar?.isHidden == true {
            
            sbSearchBar?.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
            let predicate: NSPredicate = NSPredicate(format: "name Contains [c] %@", searchText)
            if (searchBar.text?.count)! > 0
            {
                self.actStoreList = ((self.StoreList! as NSArray).filtered(using: predicate) as? [StoreM])!
                if(actStoreList!.count == 0){
                    self.tvStoreList!.isHidden = true;
                    self.view.makeToast(Constants.Errors.NO_SEARCH_DATA, duration: 2, position: .bottom)
                } else {
                    self.tvStoreList!.isHidden = false;
                }
            }
            else
            {
                self.actStoreList = self.StoreList
                self.tvStoreList!.isHidden = false;
                sbSearchBar?.isHidden = true
            }

        self.tvStoreList!.reloadData()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    
    // Code for Filter
    @IBAction func btnFilter(){
        
        UIView.transition(with: self.vwfilter, duration: 0.325, options: UIViewAnimationOptions.transitionFlipFromBottom, animations: {
            
            self.vwfilter.isHidden = false
            self.vwblur.isHidden = false
            
        }, completion: nil)
    }
    
    @IBAction func btnSubmit(){
        
        self.actStoreList = self.StoreList
        if btnSpecial.isSelected == true{
             self.actStoreList = actStoreList.filter{ $0.hasSpecialsServices == true }
        }
        
        if btnSub.isSelected == true{
            self.actStoreList = actStoreList.filter{ $0.hasSubscription == true }
        }
        
        if btnTracking.isSelected == true{
            self.actStoreList = actStoreList.filter{ $0.isTrackingEnabled == true }
        }
        
        if btnNormal.isSelected == true{
            self.actStoreList = actStoreList.filter{ $0.hasNormalServices == true }
        }
        
        self.vwblur.isHidden = true
        self.vwfilter.isHidden = true
        tvStoreList.reloadData()
        
    }
  
    @IBAction func btnCancel(){
        
        self.vwblur.isHidden = true
        self.vwfilter.isHidden = true

    }
    
    @IBAction func btnNormalA(){
        
        if self.btnNormal.isSelected == true{
            
            self.btnNormal.isSelected = false
        }
        else{
            self.btnNormal.isSelected = true
        }
    }
    

    @IBAction func btnTrackingA(){
        
        if self.btnTracking.isSelected == true{
            
            self.btnTracking.isSelected = false
        }
        else{
            self.btnTracking.isSelected = true
        }
    }
    
    @IBAction func btnSubA(){
        
        if self.btnSub.isSelected == true{
            
            self.btnSub.isSelected = false
        }
        else{
            self.btnSub.isSelected = true
        }
    }
    
    @IBAction func btnSpecialA(){
        
        if self.btnSpecial.isSelected == true{
            
            self.btnSpecial.isSelected = false
        }
        else{
            self.btnSpecial.isSelected = true
        }
    }
}
