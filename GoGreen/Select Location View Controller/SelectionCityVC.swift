//
//  SelectionCityVC.swift
//  GoGreen
//
//  Created by Sonu on 20/06/18.
//  Copyright © 2018 Sonu. All rights reserved.

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import IQKeyboardManagerSwift
import MessageUI
import PullToRefresh

class SelectionCityVC: UIViewController , UITextFieldDelegate , MFMailComposeViewControllerDelegate , addobserverdelegate , addrefresherdelegate
{
    func refrteshercall(completionHandler: @escaping (Bool?) -> ())
    {
            if self.Collectionviewindex == 0
            {
                self.HitserviceForGetCity(completionHandler: { (staus) in
                    completionHandler(true)
                })
            }
            else if self.Collectionviewindex == 1
            {
                self.HitserviceForGetlocality(cityid: GoGreenManeger.instance.Cityid, completionHandler: { (staus) in
                    completionHandler(true)
                })
                
            }else if self.Collectionviewindex == 2
            {
                self.HitserviceForGetTower(localityid: GoGreenManeger.instance.LocalityId,completionHandler: { (staus) in
                    completionHandler(true)
                })
            }
    }
    
   
    
   
    
    @IBOutlet weak var constraint_bottomview: NSLayoutConstraint!
    @IBOutlet weak var constraint_searchview_leading: NSLayoutConstraint!
    
    var localitylistarr :[Dictionary<String,String>] = []
    var towerlistarr :[Dictionary<String,String>] = []
    var CitylistArr :[Dictionary<String,String>] = []
    var filteredArray =  [Dictionary<String,String>]()
    var Collectionviewindex = 0
    var citynamestr = ""
    let refresher = PullToRefresh()
   
    
    @IBOutlet weak var animationvw: UIView!
    @IBOutlet weak var animationinnervw: UIView!

    @IBOutlet var searchtextf : UITextField!
    @IBOutlet var Scrollbasedcollectionview : UICollectionView!
    @IBOutlet var citynamelbl : UILabel!
    @IBOutlet var searchbtn : UIButton!
    @IBOutlet var backbtn : UIButton!
    @IBOutlet var Cannotfindcitylbl : UILabel!
    var apartmentpopup = ApartmentView()
   
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //HitserviceForGetCity()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.Scrollbasedcollectionview.frame.size.width, height: self.Scrollbasedcollectionview.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        Scrollbasedcollectionview!.collectionViewLayout = layout
        Scrollbasedcollectionview.reloadData()
        
        // shadow
        self.animationvw.layer.shadowColor = UIColor.black.cgColor
        self.animationvw.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.animationvw.layer.shadowOpacity = 0.5
        self.animationvw.layer.shadowRadius = 10
        self.animationinnervw.layer.cornerRadius = 10.0
        self.animationinnervw.layer.masksToBounds = true
        self.searchtextf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        if GoGreenManeger.instance.islocationselected == true
        {
            self.backbtn.isHidden = false
        }else
        {
            self.backbtn.isHidden = true
            
        }
        self.HitserviceForGetCity { (status) in}
        
//        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
         // not required when using UITableViewController
    }
    
//    @objc func refresh(sender:AnyObject)
//    {
//        // Code to refresh table view
//        if self.Collectionviewindex == 0
//        {
//            self.Scrollbasedcollectionview.reloadData()
//            self.HitserviceForGetCity()
//
//        }else if self.Collectionviewindex == 1
//        {
//            self.Scrollbasedcollectionview.reloadData()
//            self.HitserviceForGetlocality(cityid: GoGreenManeger.instance.Cityid)
//
//        }else if self.Collectionviewindex == 2
//        {
//            self.Scrollbasedcollectionview.reloadData()
//            self.HitserviceForGetlocality(cityid: GoGreenManeger.instance.LocalityId)
//        }
//    }

        
   
        
    
    func observeradd()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        HitserviceForGetTower(localityid: GoGreenManeger.instance.LocalityId) { (staus) in}
        Collectionviewindex = 2
        self.Scrollbasedcollectionview.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.searchtextf.isHidden = true
        IQKeyboardManager.sharedManager().enable = false
        GoGreenManeger.instance.citydataflush()
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if GoGreenManeger.instance.islocationselected == true
        {
            self.backbtn.isHidden = false
        }
    }
    
    @objc func textFieldDidChange(textField: UITextField)
    {
        if(textField == searchtextf)
        {
            if self.searchtextf.text == ""
            {
                self.searchtextf.text = ""
                self.filteredArray.removeAll()
                self.Scrollbasedcollectionview.reloadData()
            }
        }
    }

  
    
    
    func SetUI()
    {
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.lightGray,
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        searchtextf.attributedPlaceholder = NSAttributedString(string: "Select Your City", attributes:attributes)
        self.searchtextf.layer.cornerRadius = 3.0
        let imageView1 = UIImageView();
        imageView1.image = #imageLiteral(resourceName: "white_serachicon");
        imageView1.frame = CGRect(x: 10, y: 8, width: 18, height: 20)
        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        vw.addSubview(imageView1)
        searchtextf.leftView = vw;
        searchtextf.leftViewMode = UITextFieldViewMode.always
        searchtextf.leftViewMode = .always
        self.searchtextf.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    
    @IBAction func taptoclicklink(sender : UIButton)
    {
        var subject = ""
        if Collectionviewindex == 0
        {
            subject = "Add City"
        }else if Collectionviewindex == 1
        {
            subject = "Add Locality"
            
        }else if Collectionviewindex == 2
        {
            subject = "Add Street"
        }
        
          if MFMailComposeViewController.canSendMail()
          {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            mail.setSubject(subject) // set add locality
            mail.setToRecipients(["info@gogreen-uae.com"])
            present(mail, animated: true) {() -> Void in }
        }
        else {
            print("This device cannot send email")
        }
    }
    
    
   
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?)
    {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func taptosearchbtn(sender : UIButton)
    {
        IQKeyboardManager.sharedManager().enable = false
        self.citynamelbl.isHidden = true
        self.searchtextf.isHidden = false
        self.searchbtn.isHidden = true
        
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 11)! // Note the !
        ]
        searchtextf.attributedPlaceholder = NSAttributedString(string: "  Search Your City", attributes:attributes)
        self.searchtextf.backgroundColor = UIColor(red: 136.0 / 255.0, green: 185.0 / 255.0, blue: 54.0 / 255.0, alpha: 1.0)
        self.searchtextf.layer.cornerRadius = 20
        self.searchtextf.layer.masksToBounds = true
        let crossbtn = UIButton()
        crossbtn.setTitle("X", for: .normal)
        crossbtn.frame = CGRect(x: 10, y: 8, width: 20, height: 20)
        crossbtn.setTitleColor(UIColor.white, for: .normal)
        crossbtn.layer.masksToBounds = true
        crossbtn.layer.cornerRadius = crossbtn.frame.width/2

        let vw = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        vw.addSubview(crossbtn)
        crossbtn.addTarget(self, action: #selector(crossbtntap), for: .touchUpInside)
        searchtextf.rightView = vw;
        searchtextf.rightViewMode = UITextFieldViewMode.always
        searchtextf.rightViewMode = .always
        self.searchtextf.delegate = self
        self.searchtextf.becomeFirstResponder()
        UIView.animate(withDuration: 0.25, animations:
        {
               self.constraint_searchview_leading.constant = 10
               self.view.layoutIfNeeded()
        })
    }
    
    
    @objc func crossbtntap()
    {
        IQKeyboardManager.sharedManager().enable = false
        self.searchtextf.text = ""
        self.filteredArray.removeAll()
        self.Scrollbasedcollectionview.reloadData()
        UIView.animate(withDuration: 0.25, animations:
            {
                self.constraint_searchview_leading.constant = self.searchtextf.frame.size.width + self.constraint_searchview_leading.constant - 50
                self.searchtextf.isHidden = true
                self.constraint_bottomview.constant = 0
                self.searchbtn.isHidden = false
                self.view.layoutIfNeeded()
                
        }, completion: { (status) in
            
        })
     }
    
    
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
           
            self.Scrollbasedcollectionview.reloadData()
            UIView.animate(withDuration: 0.25, animations:
            {
                  self.constraint_bottomview.constant = keyboardSize.height
                   self.view.layoutIfNeeded()

            }, completion: { (status) in
                
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
              self.citynamelbl.isHidden = false
              self.crossbtntap()
              UIView.animate(withDuration: 0.25, animations:
             {
                 self.constraint_searchview_leading.constant = self.searchtextf.frame.size.width + self.constraint_searchview_leading.constant - 50
                 self.searchtextf.isHidden = true
                 self.constraint_bottomview.constant = 0
                 self.searchbtn.isHidden = false
                 self.view.layoutIfNeeded()
             })
        }
    }
    
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if(textField == searchtextf)
        {
       self.citynamestr = ""
       let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        searchtextf.attributedPlaceholder = NSAttributedString(string: "Search Your City", attributes:attributes)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textField == searchtextf)
        {
        self.searchtextf.text = ""
        self.filteredArray.removeAll()
        self.Scrollbasedcollectionview.reloadData()
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == searchtextf)
        {
        if Collectionviewindex == 0
        {
               filteredArray = self.CitylistArr.filter({ (dict) -> Bool in
                let tmp: NSString = dict["name"]! as NSString
                let range = tmp.range(of: (textField.text?.appending(string))!, options: NSString.CompareOptions.caseInsensitive)
                return (range.location != NSNotFound)
             
                
            }) as [Dictionary<String, String>]
            
        } else if Collectionviewindex == 1
        {
                filteredArray = self.localitylistarr.filter({ (dict) -> Bool in
                let tmp: NSString = dict["name"]! as NSString
                let range = tmp.range(of: (textField.text?.appending(string))!, options: NSString.CompareOptions.caseInsensitive)
                return (range.location != NSNotFound)
              
                
            }) as [Dictionary<String, String>]
        } else if Collectionviewindex == 2
        {
                filteredArray = self.towerlistarr.filter({ (dict) -> Bool in
                let tmp: NSString = dict["name"]! as NSString
                let range = tmp.range(of: (textField.text?.appending(string))!, options: NSString.CompareOptions.caseInsensitive)
                return (range.location != NSNotFound)
                
                }) as [Dictionary<String, String>]
            
        }
           self.Scrollbasedcollectionview.reloadData()
        }
        return true

    }
    
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        if Collectionviewindex != 0
        {
            if let coll  = self.Scrollbasedcollectionview
            {
                self.backbtn.isHidden = false
                for cell in coll.visibleCells
                {
                    let indexPath: IndexPath? = coll.indexPath(for: cell)
                    self.Collectionviewindex = ((indexPath?.row)! - 1)
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! - 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .left, animated: true)
                    self.Scrollbasedcollectionview.reloadData()
                }
            }
            
        }else
        {
            if GoGreenManeger.instance.islocationselected == true
            {
                self.backbtn.isHidden = false
                GoGreenManeger.instance.SetSlidemenuhome()
            }
            self.Scrollbasedcollectionview.reloadData()
         }
        if Collectionviewindex == 1
        {
            self.citynamelbl.text = "Select Your Location"
        }
    }

    // webservice for city
    func HitserviceForGetCity(completionHandler: @escaping (_ success:Bool?) -> ())
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_city",
                     "app_key":"123456",] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: get_city, parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            completionHandler(true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let DataCityArr = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                            {
                                self.CitylistArr = DataCityArr as! [Dictionary<String, String>]
                                print(self.CitylistArr)
                                self.Scrollbasedcollectionview.reloadData()
                            }
                        }
                        if let msgstr = dict1["message"] as? String
                        {
//                            let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                    
                }
                
            }
        }
    }

// webservice for locality
func HitserviceForGetlocality(cityid : String, completionHandler: @escaping (_ success:Bool?) -> ())
{
    GoGreenManeger.instance.Cityid = cityid
    UserDefaults.standard.set(cityid, forKey: "cityid")
    self.localitylistarr.removeAll()
    self.Scrollbasedcollectionview.reloadData()
    MBProgressHUD.showAdded(to: self.view, animated: true)
    let headers: HTTPHeaders = ["Content-Type":"application/json"]
    let param = ["method":"get_locality",
                 "app_key":"123456",
                 "city_id": cityid] as [String : Any]
    print(param)
    ServiceManager.instance.request(method: .post, URLString: get_locality, parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
    { (success, dictionary, error) in
        print(dictionary ?? "no")
        MBProgressHUD.hide(for: self.view, animated: true)
        completionHandler(true)
        
        if(error == nil)
        {
            if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
            {
                if let statuscode = dict1["resCode"] as? NSNumber
                {
                    if statuscode == 1
                    {
                        if let DataCityArr = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                        {
                            self.localitylistarr = DataCityArr as! [Dictionary<String, String>]
                            print(self.localitylistarr)
                            self.Scrollbasedcollectionview.reloadData()
                        }
                    }
                    
                }
                
            }
            
        }
    }
}
 
    // webservice for tower(Street) list
      func HitserviceForGetTower(localityid : String, completionHandler: @escaping (_ success:Bool?) -> ())
     {
        GoGreenManeger.instance.LocalityId = localityid
        UserDefaults.standard.set(localityid, forKey: "LocalityId")
        
        self.towerlistarr.removeAll()
        self.Scrollbasedcollectionview.reloadData()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_street",
                     "app_key":"123456",
                     "locality_id": localityid] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: get_street, parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            completionHandler(true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let DataCityArr = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                            {
                                self.towerlistarr = DataCityArr as! [Dictionary<String, String>]
                                print(self.towerlistarr)
                                self.Scrollbasedcollectionview.reloadData()
                            }
                        }else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                self.towerlistarr.removeAll()
                                self.Scrollbasedcollectionview.reloadData()
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
}

extension SelectionCityVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: self.Scrollbasedcollectionview.frame.size.width, height: self.Scrollbasedcollectionview.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
       let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCell", for: indexPath) as! SelectcityCell
        //shadow on inner view of collection view
        cell.shadowview.layer.cornerRadius = 8
        cell.shadowview.layer.masksToBounds = true
        cell.shadowview.layer.masksToBounds = false
        cell.shadowview.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.shadowview.layer.shadowColor = UIColor.black.cgColor
        cell.shadowview.layer.shadowOpacity = 0.23
        cell.shadowview.layer.shadowRadius = 4
        cell.selectcitytableview.rowHeight = 100
        //cell.selectcitytableview.addSubview(refreshControl)
        cell.selectcitytableview.reloadData()
        cell.delegaterefresh = self
        cell.refreshdata()
                
        if indexPath.row == 0
        {
            cell.selectcitytableview.reloadData()
            
        }else if indexPath.row == 1
        {
            cell.selectcitytableview.reloadData()
           
            
        }else if indexPath.row == 2
        {
            cell.selectcitytableview.reloadData()
           
        }
        
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
       
        
    }
    
    
    // when tap on cell scroll cell
    func scrollAutomatically()
    {
        if let coll  = self.Scrollbasedcollectionview
        {
            for cell in coll.visibleCells
            {
                let indexPath: IndexPath? = coll.indexPath(for: cell)
                self.Collectionviewindex = ((indexPath?.row)! + 1)
                if (indexPath?.row)! < 2
                {
                    let indexPath1: IndexPath?
                    indexPath1 = IndexPath.init(row: (indexPath?.row)! + 1, section: (indexPath?.section)!)
                    coll.scrollToItem(at: indexPath1!, at: .right, animated: true)
                    self.Scrollbasedcollectionview.reloadData()
                }
                else
                {
                   

                }
            }
        }
    }
}



   // table view delegate methos
    extension SelectionCityVC : UITableViewDataSource , UITableViewDelegate
    {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
        {
            if filteredArray.count == 0 && self.searchtextf.text == ""
            {
                if Collectionviewindex == 0
                {
                    return CitylistArr.count
                }
                else if Collectionviewindex == 1
                {
                    return localitylistarr.count
                }
                else if Collectionviewindex == 2
                {
                    return towerlistarr.count
                }
            }
            else
            {
               return filteredArray.count
            }
            return 0
        }
            
        
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SelectCityCell", for: indexPath)
            let locationilbl = cell.viewWithTag(101) as! UILabel
            let survievinglbl = cell.viewWithTag(102) as! UILabel
            let mainBackground = cell.viewWithTag(104) as! UIView
            mainBackground.layer.cornerRadius = 8
            mainBackground.layer.masksToBounds = true
            mainBackground.layer.masksToBounds = false
            mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
            mainBackground.layer.shadowColor = UIColor.black.cgColor
            mainBackground.layer.shadowOpacity = 0.23
            mainBackground.layer.shadowRadius = 4
            
            if filteredArray.count == 0
            {
                if Collectionviewindex == 0
                {
                    self.Cannotfindcitylbl.text = "Can't Find Your City"
                    
                    if GoGreenManeger.instance.islocationselected == true
                    {
                        self.backbtn.isHidden = false
                    }else
                    {
                        self.backbtn.isHidden = true
                        
                    }
                    
                    self.citynamelbl.text = "Select Your City"
                    if self.CitylistArr.count >= indexPath.row, let cityname = self.CitylistArr[indexPath.row]["name"]
                    {
                        locationilbl.text = cityname
                      
                    }
                    if let servivingname = self.CitylistArr[indexPath.row]["serving"]
                    {
                            survievinglbl.text = "Serving \(servivingname) Localities"
                    }
                                        
                }else if Collectionviewindex == 1
                {
                    self.Cannotfindcitylbl.text = "Can't Find Your Location"
                    if self.localitylistarr.count >= indexPath.row, let localityname = self.localitylistarr[indexPath.row]["name"]
                    {
                        locationilbl.text = localityname
                        survievinglbl.text = ""
                    }
                                      
                }else if Collectionviewindex == 2
                {
                     self.Cannotfindcitylbl.text = "Can't Find Your Street"
                    if self.towerlistarr.count >= indexPath.row,  let towername = self.towerlistarr[indexPath.row]["name"]
                    {
                        locationilbl.text = towername
                        survievinglbl.text = ""
                    }
                }
                
                
            }else
            {
                if let citiesnames = self.filteredArray[indexPath.row]["name"]
                {
                    locationilbl.text = citiesnames
                }
            }
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
        {
            self.crossbtntap()
            self.backbtn.isHidden = false
            print("You tapped cell number \(indexPath.row).")
            scrollAutomatically()
            if filteredArray.count == 0
            {
                if self.Collectionviewindex == 1
                {
                    self.HitserviceForGetlocality(cityid: self.CitylistArr[indexPath.row]["id"]!, completionHandler: { (stus) in})
                    if let cityname = self.CitylistArr[indexPath.row]["name"]
                    {
                        self.citynamelbl.text = "Locations in \(cityname)"
                        self.citynamestr = cityname
                        GoGreenManeger.instance.selectedcity = cityname
                        UserDefaults.standard.set(cityname, forKey: "cityname")
                    }

                }else if self.Collectionviewindex == 2
                {
                    HitserviceForGetTower(localityid : self.localitylistarr[indexPath.row]["id"]!,completionHandler: { (stus) in})
                    if let cityname = self.localitylistarr[indexPath.row]["name"]
                    {
                        self.citynamelbl.text = "Streets in \(cityname)"
                        GoGreenManeger.instance.selectedlocalityname = cityname
                        UserDefaults.standard.set(cityname, forKey: "localityname")
                    }
                    if let end_time = self.localitylistarr[indexPath.row]["end_time"]
                    {
                       
                        GoGreenManeger.instance.endtime = end_time
                        UserDefaults.standard.set(end_time, forKey: "endtime")
                    }
                    if let start_time = self.localitylistarr[indexPath.row]["start_time"]
                    {
                        
                        GoGreenManeger.instance.starttime = start_time
                        UserDefaults.standard.set(start_time, forKey: "starttime")
                    }
                    
                }
                else
                {
                    //logout
                    if let streetid = self.towerlistarr[indexPath.row]["id"]
                    {
                         GoGreenManeger.instance.Streetid = streetid
                         UserDefaults.standard.set(streetid, forKey: "streetid")
                        
                    }
                    
                    if let streetname = self.towerlistarr[indexPath.row]["name"]
                    {
                        GoGreenManeger.instance.selectstreet = streetname
                        UserDefaults.standard.set(streetname, forKey: "streetname")
                    }
                    
                    if let payment_type = self.towerlistarr[indexPath.row]["payment_type"]
                    {
                        GoGreenManeger.instance.selectstreet = payment_type
                        UserDefaults.standard.set(payment_type, forKey: "payment_type")
                    }
                    self.popviewshow()
                    
                }
            }else
            {
                
                if self.Collectionviewindex == 1
                {
                    self.HitserviceForGetlocality(cityid: self.filteredArray[indexPath.row]["id"]!,completionHandler: { (stus) in})
                    if let cityname = self.filteredArray[indexPath.row]["name"]
                    {
                        self.citynamelbl.text = "Locations in \(cityname)"
                        self.citynamestr = cityname
                        GoGreenManeger.instance.selectedcity = cityname
                        UserDefaults.standard.set(cityname, forKey: "cityname")
                        
                    }
                    self.filteredArray.removeAll()
                    
                }else if self.Collectionviewindex == 2
                {
                    HitserviceForGetTower(localityid : self.filteredArray[indexPath.row]["id"]!,completionHandler: { (stus) in})
                    if let cityname = self.filteredArray[indexPath.row]["name"]
                    {
                        self.citynamelbl.text = "streets in \(cityname)"
                        GoGreenManeger.instance.selectedlocalityname = cityname
                        UserDefaults.standard.set(cityname, forKey: "localityname")
                    }
                    
                    if let end_time = self.localitylistarr[indexPath.row]["end_time"]
                    {
                        
                        GoGreenManeger.instance.endtime = end_time
                        UserDefaults.standard.set(end_time, forKey: "endtime")
                    }
                    if let start_time = self.localitylistarr[indexPath.row]["start_time"]
                    {
                        GoGreenManeger.instance.starttime = start_time
                        UserDefaults.standard.set(start_time, forKey: "starttime")
                    }
                    self.filteredArray.removeAll()
                }else
                {
                  //logout
                    if let streetid = self.filteredArray[indexPath.row]["id"]
                    {
                        GoGreenManeger.instance.Streetid = streetid
                         UserDefaults.standard.set(streetid, forKey: "streetid")
                    }
                    if let streetname = self.filteredArray[indexPath.row]["name"]
                    {
                        GoGreenManeger.instance.selectstreet = streetname
                        UserDefaults.standard.set(streetname, forKey: "streetname")
                    }
//                    let CarListVC = self.storyboard?.instantiateViewController(withIdentifier: "CarListVC") as! CarListVC
//                    self.navigationController?.pushViewController(CarListVC, animated: true)
                  
                    self.popviewshow()
                }
            }
        }
        
        
        
        // pop view
        func popviewshow()
        {
            IQKeyboardManager.sharedManager().enable = true
            NotificationCenter.default.removeObserver(self)
            var Array: [Any] = Bundle.main.loadNibNamed("Apartmenyview", owner: self, options: nil)!
            self.apartmentpopup = Array[0] as! ApartmentView
            self.apartmentpopup.delegate = self
            self.apartmentpopup.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.addSubview(self.apartmentpopup)
            
        }
        
}





