//
//  SMSVerification.swift
//  Parcelo
//
//  Created by Prankur on 15/05/18.
//  Copyright © 2018 Com.parcelo. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
//import SinchVerification
import MBProgressHUD
import FacebookCore

class SMSVerificationphone: UIViewController, UITextFieldDelegate , mobilenumberchangedelegate
{
    @IBOutlet weak var otptxt1: UITextField!
    @IBOutlet weak var otptxt2: UITextField!
    @IBOutlet weak var otptxt3: UITextField!
    @IBOutlet weak var otptxt4: UITextField!
    @IBOutlet weak var mobilenumberlbl: UILabel!
    var mobilenumber = ""
    
    @IBOutlet var Verifybtn: UIButton!
    var enterotpstr = ""
    var statusotp = ""
    var isphoneverify : Bool = false
    var Wronpopview = WrongNumberView()
    
//    var verification : Verification!
//    var applicationKey = "43b7c518-5060-4118-9348-f8316f9be5e0";
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.styleTextField(textField: otptxt1)
        self.styleTextField(textField: otptxt2)
        self.styleTextField(textField: otptxt3)
        self.styleTextField(textField: otptxt4)
        otptxt1.delegate = self
        otptxt3.delegate = self
        otptxt2.delegate = self
        otptxt4.delegate = self
        otptxt1.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otptxt2.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otptxt3.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        otptxt4.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: UIControlEvents.editingChanged)
        //self.Verifybtn.applyGradient(colors: [UIColor(red: 7 / 255.0, green: 176 / 255.0, blue: 76 / 255.0, alpha: 1.0).cgColor , UIColor(red: 187 / 255.0, green: 213 / 255.0, blue: 69 / 255.0, alpha: 1.0).cgColor])
        
        // sinch code for verificatio
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
        //print(result["phone_number"] as? String ?? nil)
//        var mobile_send = "+971"
        let mobile_number = result["phone_number"] as! String
//        mobile_send += mobile_number!
//        print(mobile_send)
        mobilenumberlbl.text = mobile_number
        
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        verification = SMSVerification(applicationKey, phoneNumber: mobile_number)
//        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
//            if (result.success)
//            {
//                print(result.success)
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//            } else
//            {
//
//                print(result.success)
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//            }
//        }
        
        hitServiceForSendOTPForVerification()
  }
    
    func hitServiceForSendOTPForVerification(){
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print("hitServiceForSendOTPForVerification = \(result)" )
               
        let user_id = result["id"] as! String
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"phone_varification",
                     "app_key":"123456",
                     "user_id" : user_id
    ]

        print(param)
        ServiceManager.instance.request(method: .post, URLString: phone_varification, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
             MBProgressHUD.hide(for: self.view, animated: true)
            if success != nil{
               
            }
           
        }
    }
    
    
    func sinchverification(otpstr : String)
    {
//        verification.verify(
//            otpstr, completion:
//            { (success:Bool, error:Error?) -> Void in
//                if (success)
//                {
//                    print("Sucess")
//                    // service Hit here
//                    self.HitserviceForCorrectOTP()
//                    self.logCompleteRegistrationEvent(registrationMethod: "Complete Registration")
//                    let HowitworkVc = self.storyboard?.instantiateViewController(withIdentifier: "HowitworkVc") as! HowitworkVc
//                   self.navigationController?.pushViewController(HowitworkVc, animated: true)
//
//
//                } else
//                {
//                    print("Unscucess")
//                    self.enterotpstr = ""
//                    //alert
//                    self.otptxt1.text = ""
//                    self.otptxt2.text = ""
//                    self.otptxt3.text = ""
//                    self.otptxt4.text = ""
//                    let alert = UIAlertController(title: AppName, message: "Please enter valid OTP", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }
//        });
    }
    

    
    func changemobilenumber(mobilenumber: String)
    {
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        mobilenumberlbl.text = mobilenumber
//        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
//        print(result["phone_number"] as? String ?? nil)
////        var mobile_send = //"+971"
//        let mobile_number = result["phone_number"] as? String
////        mobile_send += mobile_number!
////        print(mobile_send)
//        verification = SMSVerification(applicationKey, phoneNumber: mobile_number!)
//        verification.initiate { (result: InitiationResult, error:Error?) -> Void in
//            if (result.success)
//            {
//                print(result.success)
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//            } else
//            {
//
//                print(result.success)
//                MBProgressHUD.hide(for: self.view, animated: true)
//
//            }
//        }
        
        //HitserviceForSmsVerification()
    }
    
    @IBAction func taptowrongnumber()
    {
        var Array: [Any] = Bundle.main.loadNibNamed("wrongview", owner: self, options: nil)!
        self.Wronpopview = Array[0] as! WrongNumberView
        self.Wronpopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        self.Wronpopview.delegate = self
        self.view.addSubview(self.Wronpopview)
    }
    
    
    override func viewWillAppear(_ animated: Bool)
    {
       //HitserviceForSmsVerification()
        self.otptxt1.text = ""
        self.otptxt2.text = ""
        self.otptxt3.text = ""
        self.otptxt4.text = ""
       
    }
    
    
    func logCompleteRegistrationEvent(registrationMethod : String) {
        let params  = ["registrationMethod" : registrationMethod]
        AppEvents.logEvent(AppEvents.Name(rawValue: "completedRegistration"),  parameters: params)

     
    }

    @objc func textFieldDidChange(textField: UITextField)
    {
        
        let text = textField.text
        if text?.utf8.count == 1
        {
            switch textField
            {
            case otptxt1:
                otptxt2.becomeFirstResponder()
            case otptxt2:
                otptxt3.becomeFirstResponder()
            case otptxt3:
                otptxt4.becomeFirstResponder()
            case otptxt4:
                otptxt4.resignFirstResponder()
            default:
                break
            }
        }else{
            
        }
    }
    
    
    @IBAction func taptoverifyotpbtn(sender : UIButton)
    {
        enterotpstr = (enterotpstr + otptxt1.text!) + (otptxt2.text)! + (otptxt3.text)! + (otptxt4.text)!
//        self.sinchverification(otpstr: enterotpstr)
        self.HitserviceForCorrectOTP(otp: enterotpstr)
    }
    
    @IBAction func taptoresenfotpbtn(sender : UIButton)
    {
        
//        let alert = UIAlertController(title: AppName, message: "Do you want to resend OTP?", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alt) in
//            MBProgressHUD.showAdded(to: self.view, animated: true)
//            let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
//            var mobile_send = "+971"
//            let mobile_number = result["phone_number"]
//            mobile_send += mobile_number!
//            // print(mobile_send)
//            self.verification = SMSVerification(self.applicationKey, phoneNumber: mobile_send)
//            self.verification.initiate { (result: InitiationResult, error:Error?) -> Void in
//                MBProgressHUD.hide(for: self.view, animated: true)}
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        self.otptxt1.text = ""
               self.otptxt2.text = ""
               self.otptxt3.text = ""
               self.otptxt4.text = ""
        
        hitServiceForSendOTPForVerification()
        
        
    }
        
    
    
    func HitserviceForSmsVerification()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)

        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
        print(result["phone_number"] as? String ?? nil)
        if let mobilenumber = result["phone_number"] as? String
        {
            self.mobilenumberlbl.text =  mobilenumber
        }
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"phone_varification",
                     "app_key":"123456",
                     "phone_number":result["phone_number"] as! String] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: phone_varification, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            MBProgressHUD.hide(for: self.view, animated: true)

            print(dictionary ?? "no")
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let sucessnumber = dict1["resCode"] as! NSNumber
                    print(sucessnumber)
                    if sucessnumber == 1
                    {
                        if let DataDic = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                        {
                            if let otpstr = DataDic[0]["otp"] as? NSNumber
                            {
                                self.statusotp = String(describing: otpstr)
                                print(self.statusotp)
                                
                            }
                            
                        }
                        
                    }
                    else
                    {
                        
                        
                    }
                    
                }
                else
                {
                    
                } 
            }
        }
        
    }
    
    
    
    func HitserviceForCorrectOTP(otp : String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print(result ?? "nil")
        
        let user_id = result["id"] as! String
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"update_verification_key",
                     "app_key":"123456",
                     "otp": otp,
                     "user_id":user_id] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: phone_varification, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let sucessnumber = dict1["resCode"] as! NSNumber
                    print(sucessnumber)
                    if sucessnumber == 1
                    {
                        if let DataDic = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                        {
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
                            result["is_phone_verified"] = "1" as AnyObject
                            UserDefaults.standard.set(result, forKey: "logindict_info")
                            let Dic = UserDefaults.standard.object(forKey: "logindict_info")
                            print(Dic ?? "nil")
                            UserDefaults.standard.synchronize()
                            self.logCompleteRegistrationEvent(registrationMethod: "Complete Registration")
                            let HowitworkVc = self.storyboard?.instantiateViewController(withIdentifier: "HowitworkVc") as! HowitworkVc
                            self.navigationController?.pushViewController(HowitworkVc, animated: true)
                            
                         }
                        
                    }
                    else
                    {
                        if let otpErrorMessage = dict1["message"] as? String{
                        let alert = UIAlertController(title: AppName, message: otpErrorMessage, preferredStyle: UIAlertControllerStyle.alert)
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
    
    
    
    func textFieldDidBeginEditing(textField: UITextField)
    {
        textField.text = ""
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    private func styleTextField(textField: UITextField)
    {
        textField.borderStyle = UITextBorderStyle.none
        textField.layer.masksToBounds = false
        textField.layer.cornerRadius = 15.0;
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderColor = UIColor.clear.cgColor
        textField.layer.shadowColor = UIColor.black.cgColor
        textField.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        textField.layer.shadowOpacity = 0.2
        textField.layer.shadowRadius = 4.0
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        return updatedText.count <= 1
    }
}
