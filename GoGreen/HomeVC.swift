//
//  HomeVC.swift
//  GoGreen
//
//  Created by Sonu on 05/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import AKSideMenu
import Alamofire
import AlamofireImage
import MBProgressHUD
import PullToRefresh

class HomeVC: UIViewController
{
    
    @IBOutlet weak var scrolltableview: UITableView!
    @IBOutlet weak var usernamelbl: UILabel!
    @IBOutlet weak var headerview: UIView!
    @IBOutlet weak var welcomelbl: UILabel!
    @IBOutlet weak var upperconstraints: NSLayoutConstraint!
    @IBOutlet var topview : UIView!
    @IBOutlet var adview : UIView!
    @IBOutlet var pendingview : UIView!
    @IBOutlet var nextview : UIView!
    
    @IBOutlet var adinnerview : UIView!
    @IBOutlet var pendinginnerview : UIView!
    @IBOutlet var nextinnerview : UIView!
    
    @IBOutlet var upperview : UIView!
    @IBOutlet var upperinnerview : UIView!
    @IBOutlet var addImagePageControl : UIPageControl!
    
    @IBOutlet var addcollectionview : UICollectionView!
    @IBOutlet var pendingcollectionview : UICollectionView!
    @IBOutlet var nextservicecollectionview : UICollectionView!
    @IBOutlet var selectcitylbl : UILabel!
    @IBOutlet var lblcellnumber : UILabel!
    @IBOutlet var lblcellPendingnumber : UILabel!
    var imagelistScrolltimer : Timer!
    
    @IBOutlet weak var addViewHC: NSLayoutConstraint!
    var timer = Timer()
    
    var returncell : Int = 4
    var pendingrenewalsarr : [Dictionary<String,AnyObject>] = []
    var servicerenewalsarr : [Dictionary<String,AnyObject>] = []
    var coupenarr : [Dictionary<String,AnyObject>] = []
    //var upcomingrenwalsarr : [Dictionary<String,AnyObject>] = []
    let refresher = PullToRefresh()
    var pendingindexpath = Int()
    let picker = UIDatePicker()
    
    
    var datePicker:UIDatePicker = UIDatePicker()
    let toolBar = UIToolbar()
    
    var datetextfield : UITextField?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        self.scrolltableview.addPullToRefresh(refresher)
        {
            self.HitserviceForupcomingRenewals()
        }
        if(imagelistScrolltimer != nil)
        {
            imagelistScrolltimer.invalidate()
        }
        datePicker.minimumDate = Date()
        datePicker.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 60, to: Date(), options: [])!
        NotificationCenter.default.addObserver(self, selector:  #selector(didReceivedPushNofication(_:)), name: .didReceivedPushNofication, object: nil)
    }
    
    deinit
    {
        if(imagelistScrolltimer != nil)
        {
            imagelistScrolltimer.invalidate()
        }
    }
    
    @objc func didReceivedPushNofication(_ notification:Notification) {
        if self.navigationController!.viewControllers.count > 1{
        for controller in self.navigationController!.viewControllers as Array {
                if controller.isKind(of: HomeVC.self) {
                    _ =  self.navigationController!.popToViewController(controller, animated: true)
                    break
                }
            }
        }
        if let orderID = notification.userInfo?["gcm.notification.order_id"] as? String{
           print(orderID)
            let CashOnDeleveryVC = self.storyboard?.instantiateViewController(withIdentifier: "CashOnDeleveryVC") as! CashOnDeleveryVC
            CashOnDeleveryVC.isPushNoficationSelected = true
            CashOnDeleveryVC.pushOrderID = orderID
            self.navigationController?.pushViewController(CashOnDeleveryVC, animated: true)
        }
    
       
    }
    
    
    @objc func dateChanged(_ sender: UIDatePicker)
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.dateFormat = "yyyy-MM-dd"
        let Datestr = formatter.string(from: sender.date)
        self.datetextfield?.text = Datestr
    }
    
    
    override func viewWillDisappear(_ animated: Bool)
    {
        timer.invalidate()
    }
    
    func SetupUI()
    {
        pendingcollectionview.dataSource = self
        pendingcollectionview.delegate = self
        nextservicecollectionview.dataSource = self
        nextservicecollectionview.delegate = self
        
        //first view
        self.adview.layer.shadowColor = UIColor.black.cgColor
        self.adview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.adview.layer.shadowOpacity = 0.3
        self.adview.layer.shadowRadius = 10
        self.adinnerview.layer.cornerRadius = 15.0
        self.adinnerview.layer.masksToBounds = true
        
        // selected package view
        self.pendingview.layer.shadowColor = UIColor.black.cgColor
        self.pendingview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.pendingview.layer.shadowOpacity = 0.3
        self.pendingview.layer.shadowRadius = 10
        self.pendinginnerview.layer.cornerRadius = 15.0
        self.pendinginnerview.layer.masksToBounds = true
        
        // selected package type view
        self.nextview.layer.shadowColor = UIColor.black.cgColor
        self.nextview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.nextview.layer.shadowOpacity = 0.3
        self.nextview.layer.shadowRadius = 10
        self.nextinnerview.layer.cornerRadius = 15.0
        self.nextinnerview.layer.masksToBounds = true
        
        self.upperview.layer.shadowColor = UIColor.black.cgColor
        self.upperview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.upperview.layer.shadowOpacity = 0.3
        self.upperview.layer.shadowRadius = 10
        self.upperinnerview.layer.cornerRadius = 15.0
        self.upperinnerview.layer.masksToBounds = true
        self.nextservicecollectionview.layer.cornerRadius = 15.0
        self.nextservicecollectionview.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        print(GoGreenManeger.instance.selectstreet)
        GoGreenManeger.instance.islocationselected = true
        SetupUI()
        self.HitserviceForupcomingRenewals()
        GoGreenManeger.instance.issetdidemenu = true
        var citynames = ""
        var selectstreet = UserDefaults.standard.object(forKey: "streetname") as? String
        if UserDefaults.standard.object(forKey: "apartmentname") != nil
        {
            if let cityname = UserDefaults.standard.object(forKey: "cityname")
            {
                citynames = cityname as! String
                GoGreenManeger.instance.selectedcity = cityname as! String
            }
            if let localityname = UserDefaults.standard.object(forKey: "localityname")
            {
                citynames +=  " , "
                citynames +=   localityname as! String
                GoGreenManeger.instance.selectedlocalityname = localityname as! String
            }
            if let selectstreet = UserDefaults.standard.object(forKey: "streetname")
            {
                GoGreenManeger.instance.selectstreet = selectstreet as! String
            }
            
            
            if let Apartmentname = UserDefaults.standard.object(forKey: "apartmentname")
            {
                GoGreenManeger.instance.Apartmentname = Apartmentname as! String
                GoGreenManeger.instance.islocationselected = true
            }
            
            if citynames == ""
            {
                selectcitylbl.text = "Select Your City"
                
            }else
            {
                selectcitylbl.text = citynames
            }
            
        }else {
            
            selectcitylbl.text = "Select Your City"
        }
        
        
        if let pendingpaymentdata =  UserDefaults.standard.object(forKey: "pt_transaction_id")
        {
            if GoGreenManeger.instance.ispaymentservicecall == true
            {
                GoGreenManeger.instance.HitserviceForPaymentgateway()
            }
        }
        
        let result = UserDefaults.standard.object(forKey: "logindict_info") as!
            Dictionary<String,AnyObject>
        let usernamestr = result["name"] as! String
        self.usernamelbl.text = usernamestr
        if GoGreenManeger.instance.isuserlogin == true
        {
            self.usernamelbl.isHidden = false
            self.welcomelbl.isHidden = false
            upperconstraints.constant = 100
            headerview.frame.size.height = 950
            
        }else
        {
            headerview.frame.size.height = 880
            self.usernamelbl.isHidden = true
            self.welcomelbl.isHidden = true
            upperconstraints.constant = 10
        }
    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        self.presentLeftMenuViewController(sender)
    }
    
    @IBAction func taptobooknow(sender : UIButton)
    {
        
        let EnterCarDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterCarDetailVC") as! EnterCarDetailVC
        self.navigationController?.pushViewController(EnterCarDetailVC, animated: true)
    }
    
    @IBAction func taptolocationbtnnow(sender : UIButton)
    {
        GoGreenManeger.instance.islocationedit = true
        let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "citylistnav")
        appDelegate.window?.rootViewController = citylistnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func HitserviceForupcomingRenewals()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = [
            "method":"upcoming_renewals",
            "app_key":"123456",
            "user_id":user_id
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.scrolltableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let statuscode = dict1["resCode"] as! NSNumber
                    if statuscode == 1
                    {
                        if let result = dict1["result"]!["services"] as? [Dictionary<String,AnyObject>]
                        {
                            self.servicerenewalsarr = result
                            print(self.servicerenewalsarr)
                            self.nextservicecollectionview.reloadData()
                        }
                        if let upcomingrenewals = dict1["result"]!["upcoming_renewals"] as? [Dictionary<String,AnyObject>]
                        {
                            self.pendingrenewalsarr = upcomingrenewals
                            print(self.pendingrenewalsarr)
                            self.pendingcollectionview.reloadData()
                        }
                        
                        if let coupansarr = dict1["result"]!["coupans"] as? [Dictionary<String,AnyObject>]
                        {
                            if coupansarr.count == 0{
                                self.addViewHC.constant = 0
                                self.view.layoutIfNeeded()
                            }else{
                                self.addViewHC.constant = 180
                                self.view.layoutIfNeeded()
                                self.addcollectionview.dataSource = self
                                self.addcollectionview.delegate = self
                                self.coupenarr = coupansarr
                                print(self.coupenarr)
                                self.addcollectionview.reloadData()
                            }
                            
                        }
                        
                    }
                    else
                    {
                        if let msgstr = dict1["message"] as? String
                        {
                            let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
                else
                {
                    
                }
            }
        }
        
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
}




extension HomeVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
//        self.addcollectionview.isHidden = true
        if (collectionView == self.addcollectionview)
        {
            if coupenarr.count == 0
            {
                addImagePageControl.numberOfPages = 0
                return 0
            }else
            {
//                self.addcollectionview.isHidden = false
                if(coupenarr.count > 1)
                {
//                    if(imagelistScrolltimer != nil)
//                    {
//                        imagelistScrolltimer.invalidate()
//                    }
//                    imagelistScrolltimer = Timer.scheduledTimer(timeInterval: 5, target:self, selector: #selector(HomeVC.ScrollTimer), userInfo: nil, repeats: true)
                }
                addImagePageControl.numberOfPages = coupenarr.count
                return coupenarr.count
                
            }
        }
        else if collectionView == self.pendingcollectionview
        {
            if pendingrenewalsarr.count == 0
            {
                lblcellPendingnumber.text = ""
                return 1
                
            }else
            {
                if(pendingrenewalsarr.count == 1)
                {
                    lblcellPendingnumber.text = ""
                }
                else
                {
                    lblcellPendingnumber.text = "1 / \(self.pendingrenewalsarr.count)"
                }
                return pendingrenewalsarr.count
                
            }
            
        }
        else if collectionView == self.nextservicecollectionview
        {
            
            if servicerenewalsarr.count == 0
            {
                lblcellnumber.text = ""
                return 1
                
            }else
            {
                if(servicerenewalsarr.count == 1)
                {
                    lblcellnumber.text = ""
                }
                else
                {
                    lblcellnumber.text = "1 / \(self.servicerenewalsarr.count)"
                }
                return servicerenewalsarr.count
            }
        }else {
            
            return 0
        }
        
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if(scrollView == self.nextservicecollectionview)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let indexPath = self.nextservicecollectionview.indexPathForItem(at: center)
            {
                lblcellnumber.text = "\(indexPath.row + 1) / \(self.servicerenewalsarr.count)"
            }
        }else if (scrollView == self.pendingcollectionview)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let indexPath = self.pendingcollectionview.indexPathForItem(at: center)
            {
                lblcellPendingnumber.text = "\(indexPath.row + 1) / \(self.pendingrenewalsarr.count)"
            }
        }
        else if (scrollView == self.addcollectionview)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let indexPath = self.addcollectionview.indexPathForItem(at: center)
            {
                addImagePageControl.currentPage = indexPath.row
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if (collectionView == self.addcollectionview)
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addcell", for: indexPath)
            cell.layoutIfNeeded()
            let adimg : UIImageView = cell.viewWithTag(501) as! UIImageView
            print(self.coupenarr[indexPath.row]["img_path"] ?? "nil")
            if let imgUrl = URL(string: self.coupenarr[indexPath.row]["img_path"] as! String)
            {
                adimg.af_setImage(withURL: imgUrl, placeholderImage:#imageLiteral(resourceName: "event_placeholderimage"), filter: nil, progress: nil, completion: { (res) in})
            }
            return cell
        }
        else if collectionView == self.pendingcollectionview
        {
            if self.pendingrenewalsarr.count == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "pendingCell", for: indexPath)
                cell.layoutIfNeeded()
                return cell
                
            }else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Nopendingcell", for: indexPath)
                cell.layoutIfNeeded()
                let carnamelbl : UILabel = cell.viewWithTag(101) as! UILabel
                let expirelbl : UILabel = cell.viewWithTag(108) as! UILabel
                let carparkingnolbl : UILabel = cell.viewWithTag(102) as! UILabel
                let cartypelbl : UILabel = cell.viewWithTag(103) as! UILabel
                let carpackaheamountlbl : UILabel = cell.viewWithTag(104) as! UILabel
                let cartyprimg : UIImageView = cell.viewWithTag(106) as! UIImageView
                let renewbtn : UIButton = cell.viewWithTag(107) as! UIButton
                renewbtn.addTarget(self, action: #selector(renewbtnclick), for: .touchUpInside)
                //renewbtnclick
                
                renewbtn.addTarget(self, action: #selector(renewbtnclick), for: .touchUpInside)
                
                if let carbrandname = self.pendingrenewalsarr[indexPath.row]["brand"]
                {
                    carnamelbl.text = carbrandname as? String
                }
                if let parking_number = self.pendingrenewalsarr[indexPath.row]["reg_no"]
                {
                    carparkingnolbl.text = parking_number as? String
                }
                if let type = self.pendingrenewalsarr[indexPath.row]["type"]
                {
                    cartypelbl.text = type as? String
                    if type as! String == "Saloon"
                    {
                        cartyprimg.image = #imageLiteral(resourceName: "small_saloon_image")
                    }else
                    {
                        cartyprimg.image = #imageLiteral(resourceName: "small_suv_image")
                    }
                    
                }
                if let amount = self.pendingrenewalsarr[indexPath.row]["amount"]
                {
                    carpackaheamountlbl.text = amount as? String
                }
                
                if let expiry_date = self.pendingrenewalsarr[indexPath.row]["expiry_date"] as? String
                {
                    expirelbl.text =  expiry_date != "" ? "Expired On \(expiry_date)" : ""
                }
                
                return cell
            }
            
            
        }else if collectionView == self.nextservicecollectionview
        {
            if self.servicerenewalsarr.count == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextServiceCell", for: indexPath)
                cell.layoutIfNeeded()
                return cell
            }else
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoServiceCell", for: indexPath)
                let carnamelbl : UILabel = cell.viewWithTag(201) as! UILabel
                
                let carparkingnolbl : UILabel = cell.viewWithTag(202) as! UILabel
                //let usernamelbl : UILabel = cell.viewWithTag(203) as! UILabel
                let phonenumberlbl : UILabel = cell.viewWithTag(2011) as! UILabel
                let carTypelbl : UILabel = cell.viewWithTag(212) as! UILabel
                if let carbrandname = self.servicerenewalsarr[indexPath.row]["brand"]
                {
                    carnamelbl.text = carbrandname as? String
                }
                if let parking_number = self.servicerenewalsarr[indexPath.row]["reg_no"] as? String
                {
                    carparkingnolbl.text = parking_number != "" ? parking_number : "N/A"
                }
                else
                {
                    carparkingnolbl.text = "N/A"
                }
                if let mobilenumber = self.servicerenewalsarr[indexPath.row]["expiry_date"] as? String
                {
                    phonenumberlbl.text =  mobilenumber != "" ? "Expires On \(mobilenumber)" : ""
                }
                else
                {
                    phonenumberlbl.text = ""
                }
                
                if let carType = self.servicerenewalsarr[indexPath.row]["type"] as? String
                {
                    carTypelbl.text = carType
                }
                else
                {
                    carTypelbl.text = ""
                }
                //                if let username = result["name"]
                //                {
                //                    usernamelbl.text =  username
                //                }
                cell.layoutIfNeeded()
                return cell
            }
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NextServiceCell", for: indexPath)
            cell.layoutIfNeeded()
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        if collectionView == addcollectionview
       {
//            if coupenarr.count == 0
//            {
//                return CGSize.zero
//            }else
//            {
                return CGSize(width: self.pendingview.frame.size.width, height: self.adview.frame.size.height)
                
//            }
        }
        
        return CGSize(width: self.pendingview.frame.size.width, height: self.pendingview.frame.size.height - 30)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        // self.pageController.currentPage = indexPath.row
        
        if collectionView == pendingcollectionview
        {
            self.pendingindexpath = indexPath.row
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        //self.pendingindexpath = indexPath.row
    }
    
    //    @objc func donePressed()
    //    {
    //        let formatter = DateFormatter()
    //        formatter.dateStyle = .medium
    //        formatter.timeStyle = .none
    //        let date = Date()
    //        formatter.dateFormat = "yyyy-MM-dd"
    //        var Datestr = formatter.string(from: date)
    //    //        let currentobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
    ////        currentobj.date = formatter.string(from: picker.date)
    ////        self.tableviewreloaddata()
    //        //let indexPath = IndexPath(row: 0, section: 0)
    //        //self.Bookserviectableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
    //        //self.view.endEditing(true)
    //    }
    //
    //    @objc func CancelPressed()
    //    {
    //        self.view.endEditing(true)
    //    }
    func doDatePicker()
    {
        // DatePicker
        // datePicker = UIDatePicker()
        self.datePicker = UIDatePicker(frame:CGRect(x: 0, y: self.view.frame.size.height - 220, width:self.view.frame.size.width, height: 216))
        self.datePicker.backgroundColor = UIColor.white
        datePicker.datePickerMode = .date
        datePicker.minimumDate = Date()
        datePicker.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 60, to: Date(), options: [])!
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        
        // ToolBar
        
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 92/255, green: 216/255, blue: 255/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(HomeVC.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(HomeVC.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        self.toolBar.isHidden = false
        
    }
    
    
    
    @objc func doneClick()
    {
        
        let formatter = DateFormatter()
        //// formatter.dateStyle = .medium
        // formatter.timeStyle = .none
        // let date = Date()
        //formatter.dateFormat = "yyyy-MM-dd"
        //var Datestr = formatter.string(from: picker.date)
        //print(Datestr)
        //datetextfield?.text = Datestr
        //let dateFormatter1 = DateFormatter()
        // dateFormatter1.dateStyle = .medium
        // dateFormatter1.timeStyle = .none
        datePicker.isHidden = true
        self.toolBar.isHidden = true
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        self.view.endEditing(true)
    }
    
    @objc func cancelClick()
    {
        datePicker.isHidden = true
        self.toolBar.isHidden = true
        self.datePicker.removeFromSuperview()
        self.toolBar.removeFromSuperview()
        self.view.endEditing(true)
    }
  
    @objc func renewbtnclick()
    {
        print([self.pendingrenewalsarr[self.pendingindexpath]])
        if let apartmentname = UserDefaults.standard.object(forKey: "apartmentname")
        {
            if self.pendingrenewalsarr[self.pendingindexpath]["package_type"] as? String == "once"
            {
                
                //1. Create the alert controller.
                let alert = UIAlertController(title: AppName, message: "Please Enter Date", preferredStyle: .alert)
                alert.addTextField { (textField) in
                    self.doDatePicker()
                    textField.inputView = self.datePicker
                    textField.inputAccessoryView = self.toolBar
                    let textField = alert.textFields![0]
                    let formatter = DateFormatter()
                    formatter.dateStyle = .medium
                    formatter.timeStyle = .none
                    let date = Date()
                    formatter.dateFormat = "yyyy-MM-dd"
                    var Datestr = formatter.string(from: self.picker.date)
                    print(Datestr)
                    self.datetextfield = textField
                }
                // 3. Grab the value from the text field, and print it when the user clicks OK.
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                    let textField = alert?.textFields![0]
                    // Force unwrapping because we know it exists.
                    if textField?.text != ""
                    {
                        print([self.pendingrenewalsarr[self.pendingindexpath]])
                        let CashOnDeleveryVC = self.storyboard?.instantiateViewController(withIdentifier: "CashOnDeleveryVC") as! CashOnDeleveryVC
                        CashOnDeleveryVC.pendingrenewarr = [self.pendingrenewalsarr[self.pendingindexpath]]
                        CashOnDeleveryVC.datestrpass = (textField?.text)!
                        self.navigationController?.pushViewController(CashOnDeleveryVC, animated: true)
                        print("Text field: \(textField?.text!)")
                        print("one Time tap to renew Text field: \([self.pendingrenewalsarr[self.pendingindexpath]])")
                    }else
                    {
                        
                    }
                }))
                
                // 4. Present the alert.
                self.present(alert, animated: true, completion: nil)
            }else
            {
                let CashOnDeleveryVC = self.storyboard?.instantiateViewController(withIdentifier: "CashOnDeleveryVC") as! CashOnDeleveryVC
                CashOnDeleveryVC.pendingrenewarr = [self.pendingrenewalsarr[self.pendingindexpath]]
                self.navigationController?.pushViewController(CashOnDeleveryVC, animated: true)
            }
            
            
        }else
        {
            GoGreenManeger.instance.islocationedit = true
            let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "citylistnav")
            appDelegate.window?.rootViewController = citylistnav
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    @objc func ScrollTimer()
    {
        var visibleItems = self.addcollectionview.indexPathsForVisibleItems
        var currentItem = visibleItems[0] as IndexPath
        var nextItem = IndexPath(item: currentItem.item + 1, section: currentItem.section)
        if(nextItem.row < self.addcollectionview.numberOfItems(inSection: 0))
        {
            self.addcollectionview.scrollToItem(at: nextItem, at: UICollectionViewScrollPosition.left, animated: true)
        }
        else
        {
            self.addcollectionview.scrollToItem(at: IndexPath(item: 0, section: currentItem.section), at: UICollectionViewScrollPosition.left, animated: true)
        }
    }
    
}


func handleDatePicker(sender: UIDatePicker)
{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    let date = Date()
    formatter.dateFormat = "yyyy-MM-dd"
    var Datestr = formatter.string(from: date)
}


extension HomeVC : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 835.0
    }
}
