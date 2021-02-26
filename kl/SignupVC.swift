//
//  SignupVC.swift
//  Parcelo
//
//  Created by Prankur on 15/05/18.
//  Copyright © 2018 Com.parcelo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import IQKeyboardManagerSwift
import CountryPicker

class SignupVC: UIViewController , UITextFieldDelegate
{
    @IBOutlet weak var txtnametextf: UITextField!
    @IBOutlet weak var txtemailtextf: UITextField!
    @IBOutlet weak var txtphonetextf: UITextField!
    @IBOutlet weak var txtDailCodetextf: UITextField!
    @IBOutlet weak var txtPasswordtextf: UITextField!
   
    @IBOutlet weak var scrollView:  UIScrollView!
    @IBOutlet var Signupbtn: UIButton!
    
     @IBOutlet weak var picker: CountryPicker!
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtphonetextf.delegate = self
        self.SetUI()
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
//        picker.displayOnlyCountriesWithCodes = ["DK", "SE", "NO", "DE"] //display only
//        picker.exeptCountriesWithCodes = ["RU"] //exept country
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(donePressed))
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel , target: nil, action: #selector(CancelPressed))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.items = [done, flexibleSpace, cancel]
        
        txtDailCodetextf.inputAccessoryView = toolbar
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: false)        //optional for UIPickerView theme changes
        picker.theme = theme //optional for UIPickerView theme changes
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        picker.setCountry(code!)
    }
    
    @objc func donePressed()
    {
        self.view.endEditing(true)
    }
    
    @objc func CancelPressed()
    {
        self.view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func SetUI()
    {
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        txtnametextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Name", attributes:attributes)
        txtemailtextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes:attributes)
        txtphonetextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Mobile Number", attributes:attributes)
        txtPasswordtextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes:attributes)
        txtDailCodetextf.inputView = picker
    
        
       // self.Signupbtn.applyGradient(colors: [UIColor(red: 7 / 255.0, green: 176 / 255.0, blue: 76 / 255.0, alpha: 1.0).cgColor , UIColor(red: 187 / 255.0, green: 213 / 255.0, blue: 69 / 255.0, alpha: 1.0).cgColor])
    }
    

    
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func taponSignupbtn(sender : UIButton)
    {
        if (txtnametextf?.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "please enter Name", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if (txtphonetextf?.text?.isEmpty)! ||  txtphonetextf.text!.count < 6
        {
            let alert = UIAlertController(title: AppName, message: "please enter Phone", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
        else if (txtemailtextf?.text?.isEmpty)! || isValidEmail(testStr: txtemailtextf.text!) == false
        {
            let alert = UIAlertController(title: AppName, message: "please valid enter Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (txtPasswordtextf?.text?.isEmpty)! || (txtPasswordtextf.text?.count)! < 6
        {
           let alert = UIAlertController(title: AppName, message: "please enter minimum lengthh 6 password", preferredStyle: UIAlertControllerStyle.alert)
           alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
        
     } else
        {
             self.HitserviceForSignup()
        }
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let charsLimit = 13
        let startingLength = txtphonetextf.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
    func isPhonevalidate(value: String) -> Bool
    {
        let PHONE_REGEX = "^((\\+)|(00))[0-9]{6,14}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @IBAction func taponback(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    func HitserviceForSignup()
    {
        MBProgressHUD.showAdded(to: self.view.window!, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let namestring = self.txtnametextf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let emailstring = self.txtemailtextf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let passwordstring = self.txtPasswordtextf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let diaCode = txtDailCodetextf.text!
        let phonestring = self.txtphonetextf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let param = ["method":"sign_up",
                     "app_key":"123456",
                     "login_type":"EM",
                     "social_id":"",
                     "device_type":"ios",
                     "phone_number": diaCode + phonestring,
                     "email":emailstring,
                     "name": namestring,
                     "device_token":"123456",
                     "password": passwordstring] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: SIGNUP, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
           print(dictionary ?? "no")
           MBProgressHUD.hide(for: self.view.window!, animated: true)
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
                                if let is_phone_verified = DataDic[0]["is_phone_verified"] as? String
                                {
                                    logindict_info["is_phone_verified"] = is_phone_verified
                                }
                                if let phone_number = DataDic[0]["phone_number"] as? String
                                {
                                     logindict_info["phone_number"] = phone_number
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
                                
                                if let is_phone_varified = DataDic[0]["is_phone_verified"] as? String
                                {
                                    if is_phone_varified == "0"
                                    {
                                        let SMSVerification = self.storyboard?.instantiateViewController(withIdentifier: "SMSVerificationphone") as! SMSVerificationphone
                                        self.navigationController?.pushViewController(SMSVerification, animated: true)
                                        
                                    }else
                                    {
                                        let SelectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
                                        self.navigationController?.pushViewController(SelectCityVC, animated: true)
                                    }
                             
                                    
                                }
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
}

extension String
{
    var isPhoneNumber: Bool
    {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first
            {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count && self.characters.count == 6
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

extension UIButton
{
//    func applyGradient(colors: [CGColor])
//    {
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = colors
//        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
//        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
//        gradientLayer.frame = self.bounds
//        self.layer.addSublayer(gradientLayer)
//    }
    
}
extension SignupVC : CountryPickerDelegate {
    
    func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        txtDailCodetextf.text = phoneCode
    }
    
}
