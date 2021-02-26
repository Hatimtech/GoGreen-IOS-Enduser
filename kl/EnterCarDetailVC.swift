//
//  EnterCarDetailVC.swift
//  GoGreen
//
//  Created by Sonu on 01/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import AlamofireImage
import MBProgressHUD
import IQKeyboardManagerSwift
import FacebookCore

class EnterCarDetailVC: UIViewController , Datavaluechangedelegate , UITextFieldDelegate
{
   
    @IBOutlet var topview : UIView!
    //@IBOutlet var carplatenotextf : UITextField!
    @IBOutlet var parkingbaynotextf : UITextField!
    @IBOutlet var ColordownButton: UIButton!
    @IBOutlet var Colordownlbl: UILabel!
    @IBOutlet var Carmodellbl: UILabel!
    @IBOutlet var Carbrandlbl: UILabel!
    @IBOutlet var Carbrandbottomview: UIView!
    @IBOutlet var Carmodelbottomview: UIView!
    @IBOutlet weak var Colourbottomview: UIView!
    @IBOutlet var Carplatetextf: UITextField!
    @IBOutlet var Carparkingbaytextf: UITextField!
    @IBOutlet var Cartypeimageview: UIImageView!
    
    @IBOutlet var saloonbtn : UIButton!
    @IBOutlet var suvbtn : UIButton!
    @IBOutlet var btnAutoRenew : UIButton!
    var carmodelpopview : CarModelview!
    var carbrandname =  ""
    var carmodelname = ""
    
    
    
    let Colourdropdown = DropDown()
    let CarBranddropdown = DropDown()
    let CarModeldropdown = DropDown()
    
    var cartype = ""
    var carmodelid = ""
    var carcolour = ""
    var carbrandid = ""
    
    var carbrandnamearr = [String]()
    var carModelnamearr = [String]()
    
    var carbrandindexarr = [String]()
    var carmodelindexarr = [String]()
    var receivededitarr : [Dictionary<String,AnyObject>] = []
    var doublePop = false
  
   
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 11)! // Note the !
        ]
       // carplatenotextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Car Plate Number", attributes:attributes)
       // carplatenotextf.delegate = self
        parkingbaynotextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Parking Bay Number", attributes:attributes)
        
        Colourdropdown.anchorView = Colourbottomview //colur
        Colourdropdown.direction = .bottom
        Colourdropdown.dataSource = ["Black","Blue","Brown","Burgundy","Gold","Gray","Orange", "Green","Purple","Red","Silver","White", "Tan", "Yellow", "Other Color"]
        self.HitwebservicegetcarBrandname()
        CarBranddropdown.anchorView = Carbrandbottomview // car brand
        CarBranddropdown.direction = .bottom
        CarBranddropdown.dataSource = carbrandnamearr
        
        CarModeldropdown.anchorView = Carmodelbottomview // car model
        CarModeldropdown.direction = .bottom
        self.cartype = "SUV"
        //self.Carplatetextf.autocapitalizationType = UITextAutocapitalizationType
        self.Carplatetextf.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.Carplatetextf.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SelectionCityVC.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        if receivededitarr.count > 0{
        hitServiceForChangeRenewStatus(mode: "3")
        btnAutoRenew.isHidden = false
        }else{
            btnAutoRenew.isHidden = true
        }
        
    }
    
    
    
    @objc func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            
            IQKeyboardManager.sharedManager().enable = true
            //self.Scrollbasedcollectionview.reloadData()
            UIView.animate(withDuration: 0.25, animations:
                {
                    
//                    self.constraint_bottomview.constant = keyboardSize.height
//                    self.view.layoutIfNeeded()
                    
            }, completion: { (status) in
                
            })
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification)
    {
        IQKeyboardManager.sharedManager().enable = true
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue
        {
//            self.citynamelbl.isHidden = false
//            self.crossbtntap()
            UIView.animate(withDuration: 0.25, animations:
                {
//                    self.constraint_searchview_leading.constant = self.searchtextf.frame.size.width + self.constraint_searchview_leading.constant - 50
//                    self.searchtextf.isHidden = true
//                    self.constraint_bottomview.constant = 0
//                    self.searchbtn.isHidden = false
                    self.view.layoutIfNeeded()
            })
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let ACCEPTABLE_CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
        if(textField == self.Carplatetextf || textField == self.parkingbaynotextf)
        {
            let cs = NSCharacterSet(charactersIn: ACCEPTABLE_CHARACTERS).inverted
            let filtered = string.components(separatedBy: cs).joined(separator: "")
            return (string == filtered)
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if(textField == self.Carplatetextf)
        {
            let charset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
            let numberset = CharacterSet(charactersIn: "0123456789")
            let char_done = self.Carplatetextf.text?.rangeOfCharacter(from: charset) != nil ? true  : false
            let num_done = self.Carplatetextf.text?.rangeOfCharacter(from: numberset) != nil ? true  : false

            if !(num_done && char_done)
            {
                self.Carplatetextf.text = ""
                let alert = UIAlertController(title: AppName, message: "Please enter a valid car plate number", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
   
   
    @objc func textFieldDidChange(textField: UITextField)
    {
        self.Carplatetextf.text = self.Carplatetextf.text?.uppercased()
    }

    override func viewWillAppear(_ animated: Bool)
    {
       
        IQKeyboardManager.sharedManager().enable = true
    
         print(receivededitarr)
         print(GoGreenManeger.instance.iseditcardetail)
      
        if GoGreenManeger.instance.iseditcardetail == true
        {
            saloonbtn.isUserInteractionEnabled = false
            suvbtn.isUserInteractionEnabled = false
            if receivededitarr[0]["type"] as? String == String("Saloon")
            {
                print("Saloon")
                self.Cartypeimageview.image = #imageLiteral(resourceName: "saloon_image")
                self.saloonbtn.setImage(#imageLiteral(resourceName: "select_check_done"), for: .normal)
                self.suvbtn.setImage(#imageLiteral(resourceName: "unselect_check_done"), for: .normal)
            
            }else
            {
                self.Cartypeimageview.image = #imageLiteral(resourceName: "suv_image")
                self.suvbtn.setImage(#imageLiteral(resourceName: "select_check_done"), for: .normal)
                self.saloonbtn.setImage(#imageLiteral(resourceName: "unselect_check_done"), for: .normal)
                
            }
            if let reg_no = receivededitarr[0]["reg_no"]
            {
                print(reg_no)
                self.Carplatetextf.text? = reg_no as! String
            }
            if let carcolour = receivededitarr[0]["color"]
            {
                print(carcolour)
                self.Colordownlbl.text = carcolour as! String
                self.carcolour = carcolour as! String
            }
            if let parking_number = receivededitarr[0]["parking_number"]
            {
               
                self.parkingbaynotextf.text = parking_number as? String
            }
            if let brand = receivededitarr[0]["brand"]
            {
                print(self.carbrandname)
                self.Carbrandlbl.text = brand as? String
                self.carbrandname = brand as! String
            }
            if let model = receivededitarr[0]["model"]
            {
                print(self.carmodelname)
                self.Carmodellbl.text = model as! String
                self.carmodelname = model as! String
            }
            
            if let model_id = receivededitarr[0]["model_id"] as? String
            {
                self.carmodelid = model_id
            }
            if let brand_id = receivededitarr[0]["brand_id"] as? String
            {
                self.carbrandid = brand_id
            }
            
            if let is_package = receivededitarr[0]["is_package"] as? String
            {
                if is_package == "2"{
                    btnAutoRenew.isHidden = false
                }else{
                    btnAutoRenew.isHidden = true
                }
            }
        }
    }
    
    
        
    
    // when popup value change then change the drop down values
    func changevalue(isvaluechange: Bool)
    {
        self.HitwebservicegetcarBrandname()
        if carbrandid == ""
        {
            
        }else
        {
            
           self.Hitwebservicegetmodel(brandid: self.carbrandid)
        }
        
        CarBranddropdown.anchorView = Carbrandbottomview // car brand
        CarBranddropdown.direction = .bottom
        CarBranddropdown.dataSource = carbrandnamearr
        
        CarModeldropdown.anchorView = Carmodelbottomview // car model
        CarModeldropdown.direction = .bottom
        CarModeldropdown.dataSource = carModelnamearr
    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        if(self.doublePop)
        {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        }
        else
        {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func HitwebservicegetcarBrandname()
    {
        self.carbrandindexarr.removeAll()
        self.carbrandnamearr.removeAll()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_car_brand",
                     "app_key":"123456"] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let result = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                            {
                                 print(result)
                                
                                for dic in result
                                {
                                    self.carbrandnamearr.append(dic["name"] as! String)
                                    self.carbrandindexarr.append(dic["id"] as! String)
                                    
                                }
                                //self.carbrandnamearr.append("Other")
                                self.CarBranddropdown.dataSource = self.carbrandnamearr
                                print(self.carbrandnamearr)
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
    
    func Hitwebservicegetmodel(brandid : String)
    {
        self.carbrandid = brandid
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_car_model",
                     "app_key":"123456",
                      "brand_id": brandid] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let result = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                            {
                                print(result)
                                self.carmodelindexarr.removeAll()
                                self.carModelnamearr.removeAll()
                                self.Carmodellbl.text = "Select Your Car Model"
                                for dic in result
                                {
                                    self.carModelnamearr.append(dic["name"] as! String)
                                    self.carmodelindexarr.append(dic["id"] as! String)
                                        print(self.carModelnamearr)
                                    print(self.carmodelindexarr)
                                }
                                 //self.carModelnamearr.append("Other")
                                 self.CarModeldropdown.dataSource = self.carModelnamearr
                                 print(self.carModelnamearr)
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
   
 
    @IBAction func taponCarBranddropdown(sender : UIButton)
    {
            self.CarBranddropdown.show()
            self.CarBranddropdown.selectionAction = { [unowned self] (index, item) in
            self.Carbrandlbl.text = item
            self.carbrandname = item
             self.carModelnamearr.removeAll()
              
//                if self.carbrandindexarr.count == index
//                {
//                   //show pop up
//                    self.carModelnamearr.removeAll()
//                    self.CarModeldropdown.dataSource = []
//                    var Array: [Any] = Bundle.main.loadNibNamed("CarModelview", owner: self, options: nil)!
//                    self.carmodelpopview = Array[0] as! CarModelview
//                    self.carmodelpopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
//                    self.view.addSubview(self.carmodelpopview)
//                    self.carmodelpopview.isbothfieldnil = true
//                    self.carmodelpopview.textcarbrand.isUserInteractionEnabled = true
//                    self.carmodelpopview.delegate = self
//
//                    //passData to Popupview
//
////                    self.Signuppopview.logintypepopup = self.logintype
////                    self.Signuppopview.socialidpopup = SocialId
////                    self.Signuppopview.textemail?.text = emailid
//
//                }else
//                {
                  let brandid = self.carbrandindexarr[index]
                  print(brandid)
                  self.Hitwebservicegetmodel(brandid: brandid)
                  self.carbrandid = brandid
                    print(self.carbrandid)
               // }
            
        }
    }
    
    @IBAction func taponEnterColour(sender : UIButton)
    {
       
                self.Colourdropdown.show()
                self.Colourdropdown.selectionAction = { [unowned self] (index, item) in
                self.Colordownlbl.text = item
                self.carcolour = item
            
        }
    }
    
    @IBAction func taponCarModeldropdown(sender : UIButton)
    {
                self.CarModeldropdown.show()
                self.CarModeldropdown.selectionAction = { [unowned self] (index, item) in
                self.Carmodellbl.text = item
                    self.carmodelname = item
                    print(self.carmodelindexarr.count)
                    if self.carmodelindexarr.count == index
                    {
                        self.CarModeldropdown.dataSource = []
                        var Array: [Any] = Bundle.main.loadNibNamed("CarModelview", owner: self, options: nil)!
                        self.carmodelpopview = Array[0] as! CarModelview
                        self.carmodelpopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
                        self.view.addSubview(self.carmodelpopview)
                        self.carmodelpopview.textcarbrand?.text = self.carbrandname
                        self.carmodelpopview.carbrandid = self.carbrandid
                        self.carmodelpopview.isbothfieldnil = false
                        self.carmodelpopview.delegate = self
                        self.carmodelpopview.textcarbrand.isUserInteractionEnabled = false
                        
                    }else
                    {
                        self.carmodelid = self.carmodelindexarr[index]
                    }
            }
    }
    
   
    @IBAction func tapToAutoRenewButton(sender : UIButton)
    {
        let currentSetImage = sender.image(for: .normal)
        if currentSetImage == #imageLiteral(resourceName: "select_check_box_icon"){
            hitServiceForChangeRenewStatus(mode: "1")
        }else{
            hitServiceForChangeRenewStatus(mode: "2")
        }
    }
    

    
    @IBAction func taptocartype(sender : UIButton)
    {
        if sender.tag == 101
        {
            self.cartype = "SUV"
            self.Cartypeimageview.image = #imageLiteral(resourceName: "suv_image")
            self.suvbtn.setImage(#imageLiteral(resourceName: "select_check_done"), for: .normal)
            self.saloonbtn.setImage(#imageLiteral(resourceName: "unselect_check_done"), for: .normal)
            
        }else if sender.tag == 102
        {
            self.cartype = "Saloon"
            self.Cartypeimageview.image = #imageLiteral(resourceName: "saloon_image")
            self.suvbtn.setImage(#imageLiteral(resourceName: "unselect_check_done"), for: .normal)
            self.saloonbtn.setImage(#imageLiteral(resourceName: "select_check_done"), for: .normal)
        }
    }
    
    
    @IBAction func taptoproceedbtn(sender : UIButton)
    {
        
        if self.carbrandname == ""
        {
            let alert = UIAlertController(title: AppName, message: "Please Enter Car Brand Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if self.carmodelname == ""
        {
            let alert = UIAlertController(title: AppName, message: "Please Enter Car Model Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if self.carcolour == ""
        {
            let alert = UIAlertController(title: AppName, message: "Please select Car Colour", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (Carplatetextf.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "Please Enter Car Plate Number", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }
//        else if (Carparkingbaytextf.text?.isEmpty)!
//        {
//            let alert = UIAlertController(title: AppName, message: "Please Enter Car Parking Bay Number", preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }
        else
        {
            if GoGreenManeger.instance.iseditcardetail == true
            {
                self.HitserviceForEditCar()
                
            }else
            {
                self.HitserviceForEnterCarDetail()
            }
        }
    }
    
    
    func HitserviceForEditCar()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print(result)
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"edit_car_detail",
                     "app_key":"123456",
                     "user_id":user_id,
                     "car_id":receivededitarr[0]["id"],
                     "city_id":GoGreenManeger.instance.Cityid,
                     "locality_id":GoGreenManeger.instance.LocalityId,
                     "street_id":GoGreenManeger.instance.Streetid,
                     "brand":self.carbrandid,
                     "model":self.carmodelid,
                     "reg_no": Carplatetextf.text?.removingWhitespaces() ?? "nil",
                     "color": self.carcolour,
                     "parking_number":Carparkingbaytextf.text ?? "nil",
                     "apartment_number":GoGreenManeger.instance.Apartmentname,
                     ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            GoGreenManeger.instance.iseditcardetail = false
                            self.navigationController?.popViewController(animated: true)
                            
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
    
    func HitserviceForEnterCarDetail()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print(result)
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"insert_car_detail",
                     "app_key":"123456",
                     "user_id":user_id,
                     "city_id":GoGreenManeger.instance.Cityid,
                     "locality_id":GoGreenManeger.instance.LocalityId,
                     "street_id":GoGreenManeger.instance.Streetid,
                     "brand":self.carbrandid,
                     "model":self.carmodelid,
                     "reg_no": Carplatetextf.text?.removingWhitespaces() ?? "nil",
                     "color": self.carcolour,
                     "parking_number":Carparkingbaytextf.text ?? "nil",
                     "apartment_number":GoGreenManeger.instance.Apartmentname,
                     "car_type":cartype] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            self.logCarRegistrationEvent(new_car_registration: "new_car_registration")
                            self.logAddToWishlistEvent(contentData: "Go Green Car wash", contentId: "GOGREEN-5544", contentType: "product", currency: "AED", price: 10.34)
                            self.navigationController?.popViewController(animated: true)
                            
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
    
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logCarRegistrationEvent(new_car_registration : String) {
        let params  = ["New_car_registration" : new_car_registration]
        AppEvents.logEvent(AppEvents.Name(rawValue: "CarRegistration"),  parameters: params)

       
    }

    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAddToWishlistEvent(contentData : String, contentId : String, contentType : String, currency : String, price : Double) {
        let params  = [
            "content" : contentData,
            "contentId" : contentId,
            "contentType" : contentType,
            "currency" : currency
        ]
        AppEvents.logEvent(AppEvents.Name(rawValue: "addedToWishlist"), valueToSum: price, parameters: params)

      
    }
    
    
    func hitServiceForChangeRenewStatus(mode : String)
    {
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"change_renewal_mode",
                     "app_key":"123456",
                     "car_id": receivededitarr[0]["id"],
                     "mode": mode
                    ] as [String : Any]
        print(param)
        
        ServiceManager.instance.request(method: .post, URLString: my_order, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view.window!, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if let result = dict1["result"]
                        {
                            if let auto_renewal = result["auto_renewal"] as? String
                            {
                               print(auto_renewal)
                                if auto_renewal == "1"{
                                    self.btnAutoRenew.setImage(#imageLiteral(resourceName: "unselect_check_box_icon"), for: .normal)
                                }else{
                                    self.btnAutoRenew.setImage(#imageLiteral(resourceName: "select_check_box_icon"), for: .normal)
                                }
                            }
                        }
                        

                    }
                    
                }
            }
        }
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
      
    }
}

extension String
{
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
}

//extension String {
//    var isAlphanumeric: Bool {
//        return !isEmpty && range(of: "[a-zA-Z0-9]", options: .regularExpression) == nil
//    }
//}


