//
//  Signupview.swift
//  Parcelo
//
//  Created by Sonu on 29/05/18.
//  Copyright © 2018 Com.parcelo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CountryPicker



class Signupview: UIView , UITextFieldDelegate, CountryPickerDelegate
{

    @IBOutlet var textemail : UITextField?
    @IBOutlet var textphone : UITextField!
    @IBOutlet var crossbtn : UIButton?
    @IBOutlet var Signupbtn : UIButton?
    @IBOutlet var Titlelbl : UILabel?
    @IBOutlet weak var picker: CountryPicker!
    @IBOutlet weak var txtDailCodetextf: UITextField!
    
    var namestrpopup = ""
    var logintypepopup = ""
    var socialidpopup = ""
    
    func setUI()
    {

        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
       
        textemail?.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes:attributes)
        textphone.attributedPlaceholder = NSAttributedString(string: "Enter Your Mobile Number", attributes:attributes)
        Titlelbl?.layer.borderWidth = 1.0
        Titlelbl?.layer.borderColor = UIColor.black.cgColor
        Signupbtn?.layer.cornerRadius = 20
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)
       
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(donePressed))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel , target: nil, action: #selector(CancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [done, flexibleSpace, cancel]
        
        picker.theme = theme
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
        
        txtDailCodetextf.inputView = picker
        
        
    }
    @objc func donePressed()
    {
        self.endEditing(true)
    }
    
    @objc func CancelPressed()
    {
        self.endEditing(true)
    }
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let charsLimit = 13
        let startingLength = textphone.text?.characters.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
   /// country Picker delegate
        
        func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
            txtDailCodetextf.text = phoneCode
        }
  
    
   
    @IBAction func Taptosignupbtn(sender : UIButton)
    {
        if (textemail?.text?.isEmpty)! || isValidEmail(testStr: (textemail?.text!)!) == false
        {
            if let topController = UIApplication.topViewController()
            {
                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Valid Email")
            }
      
        } else if (textphone.text?.isEmpty)! ||  textphone.text!.count < 6
        {
            if let topController = UIApplication.topViewController()
            {
                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Valid Phone")
            }
                        
        }else
        {
            let phoneNo = txtDailCodetextf.text! + textphone.text!
            HitserviceForSignup(logintype: logintypepopup, emailid: (textemail?.text!)!, name: namestrpopup, phonenumber: phoneNo, socialid: socialidpopup)
        }
        
    }
    
    func emptyalertpopshow(view:UIViewController , Titlestr : String ,descriptionStr : String)
    {
        let alert = UIAlertController(title: Titlestr, message:  descriptionStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    func addprogressbar(view: UIViewController)
    {
         MBProgressHUD.showAdded(to: view.view, animated: true)
    }
    
    func hideprogressbar(view: UIViewController)
    {
        MBProgressHUD.hide(for: view.view, animated: true)
        
    }
    
    func HitserviceForSignup(logintype : String , emailid : String , name : String , phonenumber : String , socialid : String)
    {
        if let topController = UIApplication.topViewController()
        {
            addprogressbar(view: topController)
        }
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"sign_up",
                     "app_key":"123456",
                     "login_type":logintype,
                     "social_id":socialid,
                     "device_type":"ios",
                     "phone_number":phonenumber,
                     "email":emailid,
                     "name": name,
                     "device_token":"123456",
                     "password": ""] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: SIGNUP, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            if let topController = UIApplication.topViewController()
            {
                self.hideprogressbar(view: topController)
            }
            if(error == nil)
            {
                var logindict_info = [String:String]()
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            if let DataDic = dictionary?["data"]!["result"] as? [Dictionary<String,AnyObject>]
                            {
                                if let email = DataDic[0]["email"] as? String
                                {
                                    logindict_info["email"] = email
                                }
                                
                                if let name = DataDic[0]["name"] as? String
                                {
                                    logindict_info["name"] = name
                                }
                                if let phone_number = DataDic[0]["phone_number"] as? String
                                {
                                    logindict_info["phone_number"] = phone_number
                                }
                                
                                if let is_phone_verified = DataDic[0]["is_phone_verified"] as? String
                                {
                                    logindict_info["is_phone_verified"] = is_phone_verified
                                }
                                
                                if let user_id = DataDic[0]["id"] as? String
                                {
                                   logindict_info["id"] = user_id
                                }
                                if let is_payment = DataDic[0]["is_payment"] as? String
                                {
                                    logindict_info["is_payment"] = is_payment
                                }
                                UserDefaults.standard.set(logindict_info, forKey: "logindict_info")
                                let Dic = UserDefaults.standard.object(forKey: "logindict_info")
                                print(Dic ?? "nil")
                                self.removeFromSuperview()
                                if let is_phone_varified = DataDic[0]["is_phone_verified"] as? String
                                {
                                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                                    if is_phone_varified == "0"
                                    {
                                        if let topController = UIApplication.topViewController()
                                        {
                                            let SMSVerification = storyboard.instantiateViewController(withIdentifier: "SMSVerificationphone") as! SMSVerificationphone
                                            topController.navigationController?.pushViewController(SMSVerification, animated: true)
                                            
                                        }
                                        
                                    }else
                                    {
                                        
                                        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
                                        print(result )
                                        let package_data = result["is_payment"] as? String
                                        if package_data == "2"
                                        {
                                            GoGreenManeger.instance.SetSlidemenuhome()
                                            
                                        }else
                                        {
                                            if let topController = UIApplication.topViewController()
                                            {
                                                let SelectCityVC = storyboard.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
                                                topController.navigationController?.pushViewController(SelectCityVC, animated: true)
                                                
                                            }
                                        }
                                        
                                    }
                                    
                                       
                                    
                        }
                }
            else
            {
                
            }
                        } else {
                            
                            
                            if let msgstr = dict1["message"] as? String
                            {
                                if let topController = UIApplication.topViewController()
                                {
                                    if let msgstr = dict1["message"] as? String
                                    {
                                        self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : msgstr)
                                    }
                                }
                               
                            }
                            
                        }
    }
 }
}
        
}
        
    }
    
    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
        self.removeFromSuperview()
    }

}
