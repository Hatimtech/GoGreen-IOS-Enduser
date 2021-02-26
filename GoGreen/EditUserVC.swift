//
//  EditUserVC.swift
//  GoGreen
//
//  Created by Sonu on 26/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import IQKeyboardManagerSwift

class EditUserVC: UIViewController
{
    @IBOutlet weak var emailtextf: UITextField!
    @IBOutlet weak var usernametextf: UITextField!
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var locationview: UIView!
    @IBOutlet var selectcitylbl : UILabel!
    
    
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
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        emailtextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes:attributes)
        usernametextf.attributedPlaceholder = NSAttributedString(string: "Enter Your User Name", attributes:attributes)
        
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let emailstr = result["email"] as! String
        let usernamestr = result["name"] as! String
        self.emailtextf.text = emailstr
        self.usernametextf.text = usernamestr
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        print(GoGreenManeger.instance.selectstreet)
        GoGreenManeger.instance.islocationselected = true
        GoGreenManeger.instance.issetdidemenu = true
        IQKeyboardManager.sharedManager().enable = true
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
        
        
//        if let pendingpaymentdata =  UserDefaults.standard.object(forKey: "pt_transaction_id")
//        {
//            if GoGreenManeger.instance.ispaymentservicecall == true
//            {
//                GoGreenManeger.instance.HitserviceForPaymentgateway()
//            }
//        }
//
//        let result = UserDefaults.standard.object(forKey: "logindict_info") as!
//            Dictionary<String,AnyObject>
//        let usernamestr = result["name"] as! String
//        self.usernamelbl.text = usernamestr
//        if GoGreenManeger.instance.isuserlogin == true
//        {
//            self.usernamelbl.isHidden = false
//            self.welcomelbl.isHidden = false
//            upperconstraints.constant = 100
//            headerview.frame.size.height = 950
//
//        }else
//        {
//            headerview.frame.size.height = 880
//            self.usernamelbl.isHidden = true
//            self.welcomelbl.isHidden = true
//            upperconstraints.constant = 10
//        }
    }
    
    
    
    
    func HitserviceForUpdateUser()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = [ "method":"update_profile",
                      "app_key":"123456",
                      "user_id":user_id,
                      "name": usernametextf.text!,
                      "email":emailtextf.text!] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: LOGIN, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["status"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
                            result["email"] = self.emailtextf.text
                            result["name"] = self.usernametextf.text
                            UserDefaults.standard.set(result, forKey: "logindict_info")
                            if let msgstr = dict1["message"] as? String
                            {
                                let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                                self.present(alert, animated: true, completion: nil)
                            }
                            GoGreenManeger.instance.SetSlidemenuhome()
                            
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
    
    @IBAction func TaptoSavebtn(sender : UIButton)
    {
        
        if (usernametextf.text?.isEmpty)!{
            
            let alert = UIAlertController(title: AppName, message: "Please enter user name" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        }else if (emailtextf.text?.isEmpty)!{
            let alert = UIAlertController(title: AppName, message: "Please enter email" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else  if  isValidEmail(testStr: (emailtextf?.text!)!) == false
        {
            let alert = UIAlertController(title: AppName, message: "Please enter valid email" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
             self.HitserviceForUpdateUser()
        }
    }
    
    @IBAction func taptoeditlocation(sender : UIButton)
    {
        GoGreenManeger.instance.islocationedit = true
        let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "citylistnav")
        appDelegate.window?.rootViewController = citylistnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    override func viewDidLayoutSubviews()
    {
        self.locationview.layer.shadowColor = UIColor.lightGray.cgColor
        self.locationview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.locationview.layer.shadowOpacity = 0.5
        self.locationview.layer.shadowRadius = 8
        self.locationview.layer.cornerRadius = self.locationview.frame.size.height/2.0
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func TaptoBackbtn(sender : UIButton)
    {
        GoGreenManeger.instance.SetSlidemenuhome()
    }
    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
}
