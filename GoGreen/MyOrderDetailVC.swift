//
//  MyOrderDetailVC.swift
//  GoGreen
//
//  Created by Sonu on 02/08/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import PullToRefresh
import IQKeyboardManagerSwift


class MyOrderDetailVC: UIViewController , StardatasentDelegate , UITextViewDelegate
{
     @IBOutlet var topview : UIView!
     @IBOutlet var packageview : UIView!
     @IBOutlet var crewview : UIView!
     @IBOutlet var activityview : UIView!
     @IBOutlet var uperview : UIView!
    
     @IBOutlet var packagebtn : UIButton!
     @IBOutlet var crewbtn : UIButton!
     @IBOutlet var activitybtn : UIButton!
     @IBOutlet var OrderDetilstableview : UITableView!
    
     @IBOutlet var carmodellbl : UILabel!
     @IBOutlet var parkinglbl : UILabel!
     @IBOutlet var vwnodata : UIView!

    
     var typecell = ""
     var ratepopview = RatereView()
     var packagearr = ["Package Type" , "Service Date" , "Expires On" , "Package Price"]
     var receivedarr : [Dictionary<String,AnyObject>] = []
     var packagedataarr : [Dictionary<String,AnyObject>] = []
     var crewdataarr : [Dictionary<String,AnyObject>] = []
     var activityarr : [Dictionary<String,AnyObject>] = []
     var cleanerid = ""
     var userimage_string = ""
     var activityid = ""
     var packegeid = ""
     var isactive = true
    
     let refresher = PullToRefresh()

    override func viewDidLoad() 
    {
        super.viewDidLoad()
        print(self.receivedarr)
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        var modelbrandstr = ""
        if let parnkingnumber = receivedarr[0]["reg_no"] as? String
        {
            parkinglbl.text = parnkingnumber as! String
        }
        if let brand = receivedarr[0]["brand"] as? String
        {
            modelbrandstr = brand as! String
        }
         if let model = receivedarr[0]["model"] as? String
         {
            
            //modelbrandstr += " " +model as! String
              modelbrandstr += " " + (model )
         }
         carmodellbl.text = modelbrandstr
          setupui()
        HitserviceForOrderDetail()
    }
    
    
    func setupui()
    {
        OrderDetilstableview.rowHeight = 100
        uperview.layer.shadowColor = UIColor.lightGray.cgColor
        uperview.layer.shadowOpacity = 1
        uperview.layer.shadowOffset = CGSize.zero
        uperview.layer.shadowRadius = 5
        
        packageview.layer.shadowColor = UIColor.lightGray.cgColor
        packageview.layer.shadowOpacity = 1
        packageview.layer.shadowOffset = CGSize.zero
        packageview.layer.shadowRadius = 5
        
        crewview.layer.shadowColor = UIColor.lightGray.cgColor
        crewview.layer.shadowOpacity = 1
        crewview.layer.shadowOffset = CGSize.zero
        crewview.layer.shadowRadius = 5
        
        activityview.layer.shadowColor = UIColor.lightGray.cgColor
        activityview.layer.shadowOpacity = 1
        activityview.layer.shadowOffset = CGSize.zero
        activityview.layer.shadowRadius = 5
        packagebtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
        crewbtn.backgroundColor = UIColor.white
        activitybtn.backgroundColor = UIColor.white
        packagebtn.setTitleColor(UIColor.white, for: .normal)
        crewbtn.setTitleColor(UIColor.black, for: .normal)
        activitybtn.setTitleColor(UIColor.black, for: .normal)
    }
    
    
    
    func HitserviceForGetActivity()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_car_activity",
                     "app_key":"123456",
                     "car_id":receivedarr[0]["car_id"]!,
                     "id": receivedarr[0]["payment_key"]!] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: Orderdetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.OrderDetilstableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
                            {
                                 self.activityarr = result
                                 print(self.activityarr)
                                 self.OrderDetilstableview.reloadData()
                             }
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    
    func HitserviceForGetcrew()
    {
        print(receivedarr[0])
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_crew_detail",
                     "app_key":"123456",
                     "user_id": user_id,
                     "car_id":receivedarr[0]["car_id"]!,
                     "order_id":receivedarr[0]["payment_key"]!] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: Orderdetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.OrderDetilstableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
                            {
                                
                                self.crewdataarr = result
                                print(self.crewdataarr)
                                self.OrderDetilstableview.reloadData()
                              
                            }
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    
   

    
    func HitserviceForRatereview(ratingstring : String , feedback : String)
    {
       let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"rate_cleaner",
                     "app_key":"123456",
                     "user_id":user_id,
                     "cleaner_id": self.cleanerid,
                     "rating":ratingstring,
                     "car_id":receivedarr[0]["car_id"]!,
                     "feedback" : feedback,
                     "order_id" : receivedarr[0]["id"],
                      "activity_id":self.activityid,
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: Orderdetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.OrderDetilstableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            let alert = UIAlertController(title: AppName, message: "Thank you for providing feedback", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
//                            if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
//                            {
////                                self.typecell = "Packagecell"
////                                self.packagedataarr = result
////                                self.OrderDetilstableview.reloadData()
//                            }
                            
                            
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            
                        }
                    }
                }
            }
        }
    }
   
    @objc func tapToStopBtn(sender : UIButton) {
        if sender.title(for: .normal) == "Pause Package"{
            let alert = UIAlertController(title: AppName, message: "Are you sure you want to Pause Package ?" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in  self.hitServiceForStopStartPackageStatus(mode: "2", sender: sender)}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
//            hitServiceForStopStartPackageStatus(mode: "2", sender: sender)   // To Stop package
        }else{
            let alert = UIAlertController(title: AppName, message: "Are you sure you want to Resume Package ?" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in   self.hitServiceForStopStartPackageStatus(mode: "1", sender: sender)}))
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
//             hitServiceForStopStartPackageStatus(mode: "1", sender: sender) // To start package
        }
  
    }
    
    @objc func tapToCancelSubscription(sender : UIButton) {
        
        let alert = UIAlertController(title: AppName, message: "Are you sure you want to Cancel your subscription ?" , preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: {(alert: UIAlertAction!) in self.hitServiceForCancelSubscription()}))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    
    func HitserviceForOrderDetail()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_order_package_detail",
                     "app_key":"123456",
                     "user_id": user_id,
                     "order_id":receivedarr[0]["payment_key"]!,
                     "car_id":receivedarr[0]["car_id"]!] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: Orderdetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.OrderDetilstableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
                            {
                                self.typecell = "Packagecell"
                                self.packagedataarr = result
                                self.OrderDetilstableview.reloadData()
                            }                            
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    func numbercountofstar(numberofstar : String , feedback : String)
    {
        HitserviceForRatereview(ratingstring: numberofstar, feedback: feedback)
    }
   
    
    @IBAction func taptouperbtn(sender : UIButton)
    {
         typecell = ""
         if sender.tag == 101
        {
             typecell = "Packagecell"
             OrderDetilstableview.rowHeight = 100
             packagebtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
             crewbtn.backgroundColor = UIColor.white
             activitybtn.backgroundColor = UIColor.white
             packagebtn.setTitleColor(UIColor.white, for: .normal)
             crewbtn.setTitleColor(UIColor.black, for: .normal)
             activitybtn.setTitleColor(UIColor.black, for: .normal)
             self.OrderDetilstableview.reloadData()
             HitserviceForOrderDetail()
            
        }else if sender.tag == 102
        {
            typecell = ""
            OrderDetilstableview.rowHeight = 260
            crewbtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            packagebtn.backgroundColor = UIColor.white
            activitybtn.backgroundColor = UIColor.white
            crewbtn.setTitleColor(UIColor.white, for: .normal)
            packagebtn.setTitleColor(UIColor.black, for: .normal)
            activitybtn.setTitleColor(UIColor.black, for: .normal)
            HitserviceForGetcrew()
            self.OrderDetilstableview.reloadData()
            
        }else if sender.tag == 103
        {
             typecell = "ActivityCell"
             OrderDetilstableview.rowHeight = 100
             activitybtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
             crewbtn.backgroundColor = UIColor.white
             packagebtn.backgroundColor = UIColor.white
             activitybtn.setTitleColor(UIColor.white, for: .normal)
             packagebtn.setTitleColor(UIColor.black, for: .normal)
             crewbtn.setTitleColor(UIColor.black, for: .normal)
             HitserviceForGetActivity()
             self.OrderDetilstableview.reloadData()
        }
        
    }
    
    
    
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool{
        
        if  textView.text.characters.count == 0
        {
            self.ratepopview.ratelbl.isHidden = false
        }
        else
        {
            self.ratepopview.ratelbl.isHidden = true
        }
       return true
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject?
    {
        if value is NSNull
        {
            return nil
        }
        else
        {
            return value
        }
    }

    func popviewshow()
    {
        var Array: [Any] = Bundle.main.loadNibNamed("Rateview", owner: self, options: nil)!
        self.ratepopview = Array[0] as! RatereView
        self.ratepopview.Delegate = self
        self.ratepopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        self.ratepopview.floatdelegatecall()
        self.ratepopview.feedbacktextview.delegate = self
        self.ratepopview.ratelbl.isHidden = false
         IQKeyboardManager.sharedManager().enable = true
        if let decodedData = Data(base64Encoded: self.userimage_string, options: .ignoreUnknownCharacters)
        {
            if self.userimage_string == ""
            {
                ratepopview.userimage.image = #imageLiteral(resourceName: "user_placeholder_medium")
            }
            else
            {
                ratepopview.userimage.image = UIImage(data: decodedData)
            }
        }
         self.view.addSubview(self.ratepopview)
    }
    
}

extension MyOrderDetailVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if typecell == "Packagecell"
        {
            self.vwnodata.isHidden = self.packagearr.count > 0 ? true : false
            self.OrderDetilstableview.isHidden = self.packagearr.count > 0 ? false : true
            var packageCount = self.packagearr.count
            if self.isactive{
            if self.packagedataarr.count > 0,  self.packagedataarr[0]["subscription"] as! String == "1"{
                packageCount = packageCount + 1
            }
            }
            return self.packagearr.count > 0 ? packageCount : self.packagearr.count
        }
        else if typecell == "ActivityCell"
        {
            self.vwnodata.isHidden = self.activityarr.count > 0 ? true : false
            self.OrderDetilstableview.isHidden = self.activityarr.count > 0 ? false : true
            return self.activityarr.count
        }
        else
        {
            self.vwnodata.isHidden = self.crewdataarr.count > 0 ? true : false
            self.OrderDetilstableview.isHidden = self.crewdataarr.count > 0 ? false : true
            return self.crewdataarr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        print(typecell)
        if typecell == "Packagecell"
        {
            var cell: UITableViewCell!
             cell = tableView.dequeueReusableCell(withIdentifier: "Packagecell", for: indexPath)
            
            let packagelbl : UILabel = cell.viewWithTag(101) as! UILabel
            let valuechangelbl : UILabel = cell.viewWithTag(102) as! UILabel
            if indexPath.row < packagearr.count {
            packagelbl.text = self.packagearr[indexPath.row]
            }
            if indexPath.row == 0
            {
                if let packagetype = self.packagedataarr[0]["package_type"]
                {
                        valuechangelbl.text = packagetype as? String
                }
                
            }
            else if indexPath.row == 1
            {
                
                if self.packagedataarr[0]["package_type"] as! String == "once"
                {
                    if let packagetype = self.packagedataarr[0]["one_time_service_date"]
                    {
                        valuechangelbl.text = packagetype as? String
                    }
                }
                else
                {
                    packagelbl.text = "Service Days"
                    if let packagetype = self.packagedataarr[0]["days"]
                    {
                        valuechangelbl.text = packagetype as? String
                    }
                }
                
                
            }
            else if indexPath.row == 2
            {
                
                if let packagetype = self.packagedataarr[0]["expiry_date"]
                {
                    valuechangelbl.text = packagetype as? String
                }
                
            }
            else if indexPath.row == 3
            {
                if let packagetype = self.packagedataarr[0]["amount"]
                {
                    valuechangelbl.text = packagetype as? String
                }
            }
            
            else if indexPath.row == 4
            {
                var cell: UITableViewCell!
                cell = tableView.dequeueReusableCell(withIdentifier: "PackageStopcell", for: indexPath)
                let btnStop : UIButton = cell.viewWithTag(110) as! UIButton
               
                btnStop.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                if (self.packagedataarr[0]["is_off"] as! String  == "1"){
                    btnStop.setTitle("Pause Package", for: .normal)
                }else{
                    btnStop.setTitle("Resume Package", for: .normal)
                }
                self.packegeid = self.packagedataarr[0]["id"] as! String
                btnStop.layer.shadowColor = UIColor.lightGray.cgColor
                btnStop.layer.shadowOpacity = 1
                btnStop.layer.shadowOffset = CGSize.zero
                btnStop.layer.shadowRadius = 3
                btnStop.addTarget(self, action:#selector(self.tapToStopBtn), for: .touchUpInside)
                
                let btnCencelSubs : UIButton = cell.viewWithTag(111) as! UIButton
                
                btnCencelSubs.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
               
               
                btnCencelSubs.layer.shadowColor = UIColor.lightGray.cgColor
                btnCencelSubs.layer.shadowOpacity = 1
                btnCencelSubs.layer.shadowOffset = CGSize.zero
                btnCencelSubs.layer.shadowRadius = 3
                btnCencelSubs.addTarget(self, action:#selector(self.tapToCancelSubscription), for: .touchUpInside)
                return cell
            }
          
         let mainBackground = cell.viewWithTag(104) as! UIView
         mainBackground.layer.cornerRadius = 8
         mainBackground.layer.masksToBounds = true
         mainBackground.layer.masksToBounds = false
         mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
         mainBackground.layer.shadowColor = UIColor.black.cgColor
         mainBackground.layer.shadowOpacity = 0.23
         mainBackground.layer.shadowRadius = 4
        return cell
        }
            
        else if typecell == "ActivityCell"
        {
            var cell: UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell", for: indexPath)
            let calenderlbl : UILabel = cell.viewWithTag(301) as! UILabel
            let statuslbl : UILabel = cell.viewWithTag(302) as! UILabel
            
             let maincurvedview : UIView = cell.viewWithTag(601) as! UIView
             let curvedimage : UIImageView = cell.viewWithTag(602) as! UIImageView
             let midcurvedview : UIView = cell.viewWithTag(603) as! UIView
            
            if let datestr = self.activityarr[indexPath.row]["job_done_date"]
            {
                calenderlbl.text = datestr as! String
            }
            else
            {
                calenderlbl.text = ""
            }
            
            if let statusstr = self.activityarr[indexPath.row]["attendent"]
            {
                if statusstr as! String == "1"
                {
                    statuslbl.text = "Status Completed"
                    curvedimage.image = #imageLiteral(resourceName: "curved_edge")
                    maincurvedview.backgroundColor = UIColor(red: 77.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                    midcurvedview.backgroundColor = UIColor(red: 77.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                }else
                {
                        statuslbl.text = "Status Pending"
                        curvedimage.image = #imageLiteral(resourceName: "curved_edge_red")
                        maincurvedview.backgroundColor = UIColor.red
                        midcurvedview.backgroundColor = UIColor.red
                }
            }
            else
            {
                statuslbl.text = ""
            }
            
            let mainBackground = cell.viewWithTag(304) as! UIView
            mainBackground.layer.cornerRadius = 8
            mainBackground.layer.masksToBounds = true
            mainBackground.layer.masksToBounds = false
            mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
            mainBackground.layer.shadowColor = UIColor.black.cgColor
            mainBackground.layer.shadowOpacity = 0.23
            mainBackground.layer.shadowRadius = 4
            return cell
        }
        else
        {
            
            // crewcell
            var cell: UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "CrewCell", for: indexPath)
            let namelbl : UILabel = cell.viewWithTag(401) as! UILabel
            let ratinglbl : UILabel = cell.viewWithTag(402) as! UILabel
            //let timelbl : UILabel = cell.viewWithTag(403) as! UILabel
            let phonelbl : UILabel = cell.viewWithTag(1001) as! UILabel
            //let emaillbl : UILabel = cell.viewWithTag(404) as! UILabel
            
            var countrate = ""
            var username = ""
            if let name = self.crewdataarr[indexPath.row]["first_name"]
            {
                username = (name as? String)!
            }
            if let lastname = self.crewdataarr[indexPath.row]["last_name"] as? String
            {
                username = "\(username) \(lastname)"
            }
            namelbl.text = username
            if let email = self.crewdataarr[indexPath.row]["email"]
            {
                //emaillbl.text = email as? String
            }
            
            if let count = self.crewdataarr[indexPath.row]["count_who_rated"]
            {
               
                countrate = count as! String
            }
            
            if let phone_number = self.crewdataarr[indexPath.row]["phone_number"]
            {
                phonelbl.text = phone_number as? String
            }
            
            if let rating = nullToNil(value: self.crewdataarr[indexPath.row]["rating"])
            {
                print(rating)
                print(countrate)
                let userrate = Float(rating as! String)! / Float(countrate)!
                
                let formattedNumber = String(format: "%.02f", userrate)
                if formattedNumber == "nan"
                {
                     ratinglbl.text = String("\(0) star rating")
                    
                }else
                {
                     ratinglbl.text = String("\(formattedNumber) star rating")
                }
               
            }else
            {
                ratinglbl.text = String("\(0) star rating")
            }
            
            // UIVIEW SHADOWS
            let mainBackground = cell.viewWithTag(504) as! UIView
            mainBackground.layer.cornerRadius = 8
            mainBackground.layer.masksToBounds = true
            mainBackground.layer.masksToBounds = false
            mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
            mainBackground.layer.shadowColor = UIColor.black.cgColor
            mainBackground.layer.shadowOpacity = 0.23
            mainBackground.layer.shadowRadius = 4
            
            let firstview = cell.viewWithTag(31) as! UIView
            firstview.layer.cornerRadius = 8
            firstview.layer.masksToBounds = true
            firstview.layer.masksToBounds = false
            firstview.layer.shadowOffset = CGSize(width: -1, height: 1)
            firstview.layer.shadowColor = UIColor.black.cgColor
            firstview.layer.shadowOpacity = 0.23
            firstview.layer.shadowRadius = 4
            
            let secondview = cell.viewWithTag(32) as! UIView
            secondview.layer.cornerRadius = 8
            secondview.layer.masksToBounds = true
            secondview.layer.masksToBounds = false
            secondview.layer.shadowOffset = CGSize(width: -1, height: 1)
            secondview.layer.shadowColor = UIColor.black.cgColor
            secondview.layer.shadowOpacity = 0.23
            secondview.layer.shadowRadius = 4
            
//            let thirdview = cell.viewWithTag(33) as! UIView
//            thirdview.layer.cornerRadius = 8
//            thirdview.layer.masksToBounds = true
//            thirdview.layer.masksToBounds = false
//            thirdview.layer.shadowOffset = CGSize(width: -1, height: 1)
//            thirdview.layer.shadowColor = UIColor.black.cgColor
//            thirdview.layer.shadowOpacity = 0.23
//            thirdview.layer.shadowRadius = 4
            
            let fourthview = cell.viewWithTag(1002) as! UIView
            fourthview.layer.cornerRadius = 8
            fourthview.layer.masksToBounds = true
            fourthview.layer.masksToBounds = false
            fourthview.layer.shadowOffset = CGSize(width: -1, height: 1)
            fourthview.layer.shadowColor = UIColor.black.cgColor
            fourthview.layer.shadowOpacity = 0.23
            fourthview.layer.shadowRadius = 4
            return cell
     }
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if self.typecell == "ActivityCell"
        {
            if let Cleanerid = self.activityarr[indexPath.row]["cleaner_id"]
            {
                self.cleanerid = (Cleanerid as? String)!
             }
            if let image_string = self.activityarr[indexPath.row]["image_string"] as? String
            {
                self.userimage_string = image_string
            }
            var cleanername = ""
            if let firstnamecleaner = self.activityarr[indexPath.row]["first_name"]
            {
                cleanername = firstnamecleaner as! String
            }
            if let lastnamecleaner = self.activityarr[indexPath.row]["last_name"]
            {
                cleanername += " " + (lastnamecleaner as! String)
            }
            if let activity_id = self.activityarr[indexPath.row]["id"]
            {
                self.activityid = activity_id as! String
            }
            popviewshow()
            self.ratepopview.userlbl.text = cleanername
        }
    }
}


extension MyOrderDetailVC {
    
    func hitServiceForStopStartPackageStatus(mode : String, sender : UIButton)
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"stop_package",
                     "app_key":"123456",
                     "package_id": self.packegeid,
                     "user_id": user_id,
                     "mode": mode
            ] as [String : Any]
        
        print(param)
        ServiceManager.instance.request(method: .post, URLString: stop_package, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if (dict1["status"] as? NSNumber) != nil
                    {
                        if mode == "2"{
                            sender.setTitle("Resume Package", for: .normal)
                        }else{
                            sender.setTitle("Pause Package", for: .normal)
                        }
                    }
                }
            }
        }
    }
    
    func hitServiceForCancelSubscription()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"Cancell_subscription",
                     "app_key":"123456",
                     "user_id": user_id
            ] as [String : Any]
        
        print(param)
        ServiceManager.instance.request(method: .post, URLString: stop_package, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if (dict1["status"] as? NSNumber) != nil
                    {
                        self.HitserviceForOrderDetail()
                    }
                }
            }
        }
        
        
    }
    


}




//if (self.packagedataarr[0]["is_off"] as! String  == "2"){
//    btnStop.setTitle("Stop Package", for: .normal)
//}else{
//    btnStop.setTitle("Start Package", for: .normal)
//}
