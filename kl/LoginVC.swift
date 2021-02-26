//
//  LoginVC.swift
//  Parcelo
//
//  Created by Prankur on 15/05/18.
//  Copyright © 2018 Com.parcelo. All rights reserved.
//

import UIKit
import Alamofire
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import MBProgressHUD
import GoogleSignIn
import IQKeyboardManagerSwift
import AuthenticationServices


class LoginVC: UIViewController , GIDSignInDelegate  , UITextFieldDelegate,ASAuthorizationControllerDelegate
{
    
    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet var Loginbtn: UIButton!
    var Signuppopview : Signupview!
    var namestr  = ""
    var logintype = ""
   @IBOutlet var signInButtonStack : UIView!

    

    override func viewDidLoad()
    {
        super.viewDidLoad()
//        Crashlytics.sharedInstance().crash()
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().clientID = GoogleClientid
        SetUI()

    }

    
    
    override func viewWillAppear(_ animated: Bool)
    {
        IQKeyboardManager.sharedManager().enable = true
    }
    
    func SetUI()
    {
       txtemail.delegate = self
       txtPassword.delegate = self
        self.setUpSignInAppleButton()
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        txtemail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email or Mobile", attributes:attributes)
        txtPassword.attributedPlaceholder = NSAttributedString(string: "Enter Your Password", attributes:attributes)
      
        //self.Loginbtn.applyGradient(colors: [UIColor(red: 7 / 255.0, green: 176 / 255.0, blue: 76 / 255.0, alpha: 1.0).cgColor , UIColor(red: 187 / 255.0, green: 213 / 255.0, blue: 69 / 255.0, alpha: 1.0).cgColor])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        txtPassword.resignFirstResponder()
        txtemail.resignFirstResponder()
        return true
    }
   
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
        
    }
    
    @IBAction func TaptomovesignupVC(sender : UIButton)
    {
        let SignupVC = self.storyboard?.instantiateViewController(withIdentifier: "SignupVC") as! SignupVC
        self.navigationController?.pushViewController(SignupVC, animated: true)
    }
    
    @IBAction func TaptomoveForgetVC(sender : UIButton)
    {
        let ForgetVC = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordVC") as! ForgotPasswordVC
        self.navigationController?.pushViewController(ForgetVC, animated: true)
    }
    
    
    func signIn(signIn: GIDSignIn!, didSignInForUser user: GIDGoogleUser!,
                withError error: NSError!)
    {
    }

    func sign(_ signIn: GIDSignIn!,
              dismiss viewController: UIViewController!)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user:GIDGoogleUser!, withError error: Error!)
    {
        if (error == nil)
        {
            let userId = user.userID                  // For client-side use only!
            let emailstring = user.profile.email
            self.logintype = "GL"
            self.namestr = user.profile.name
            GIDSignIn.sharedInstance().signOut()
            self.HitserviceForLogin(logintype: "GL", SocialId: userId!, emailid: emailstring!, password: "")
        } else
        {
            print("\(error.localizedDescription)")
        }
        
    }

    @IBAction func googleSignIn(sender: UIButton)
    {
         GIDSignIn.sharedInstance().signIn()
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func taponLogin(sender : UIButton)
    {
        if (txtemail?.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "please enter valid mail id or phone number with country code", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else if (txtPassword?.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "please enter password", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        else
        {
            self.HitserviceForLogin(logintype: txtemail.text!.isPhoneNumber ? "PH" : "EM", SocialId: "", emailid: txtemail.text!, password: txtPassword.text!)
            
        }
    }
    
    
    
    @IBAction func tapfacebookbtn(sender : UIButton)
    {
        let fbLoginManager : LoginManager = LoginManager()
        fbLoginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if (error == nil)
            {
                let fbloginresult : LoginManagerLoginResult = result!
                if (result?.isCancelled)!
                {
                    return
                }
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                }
            }
        }
       
    }
    
    func getFBUserData()
    {
        if((AccessToken.current) != nil){
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil)
                {
                    let dict = result as! [String : AnyObject]
                    let userID = dict["id"]! as! String
                    print(dict)
                    self.namestr = dict["first_name"] as! String
                    let lastnaem = dict["last_name"] as! String
                    self.namestr += " " + lastnaem
                    print(self.namestr)
                    self.logintype = "FB"
                    if dict["email"] != nil
                    {
                         self.HitserviceForLogin(logintype: "FB", SocialId: userID, emailid: dict["email"] as! String, password: "")
                    }else{
                        
                         self.HitserviceForLogin(logintype: "FB", SocialId: userID, emailid: "", password: "")
                     }
                 }
                
            })
        }
    }
    
    
    //Apple Id Sign In
    
    func setUpSignInAppleButton() {
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
               //  authorizationButton.cornerRadius = 10
                 //Add button on some view or stack
                 self.signInButtonStack.addSubview(authorizationButton)
        } else {
            // Fallback on earlier versions
        }
     
    }
  
    @available(iOS 13.0, *)
    @objc func handleAppleIdRequest() {
      
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
               request.requestedScopes = [.fullName, .email]
               let authorizationController = ASAuthorizationController(authorizationRequests: [request])
               authorizationController.delegate = self
               authorizationController.performRequests()
       
   
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
    let userIdentifier = appleIDCredential.user
//    let fullName = appleIDCredential.fullName
        let fname = appleIDCredential.fullName?.givenName ?? ""
        let lname = appleIDCredential.fullName?.familyName ?? ""
        
        self.namestr = ((fname + lname) == "") ? "Guest" : fname + " " + lname
        print(namestr)
    let email = appleIDCredential.email ?? ""
    self.logintype = "GL"

        self.HitserviceForLogin(logintype: "GL", SocialId: userIdentifier, emailid: email, password: "")

    }
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    // Handle error.
    }
    
    
    func isValidEmail(testStr:String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    
    func validate(value: String) -> Bool
    {
        let PHONE_REGEX = "[0-9]{10,10}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func HitserviceForLogin(logintype : String , SocialId : String , emailid : String , password : String)
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"login",
                     "app_key":"123456",
                     "login_type": logintype,
                     "social_id": SocialId,
                     "device_type":"ios" ,
                     "email": emailid,
                     "phone_number":emailid,
                     "password": password] as [String : Any]
        ServiceManager.instance.request(method: .post, URLString: LOGIN, parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                var logindict_info = [String:String]()
                GoGreenManeger.instance.isuserlogin = true
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1 // sucessful
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
                                
                       //is_payment
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
                                        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
                                        print(result )
                                        let package_data = result["is_payment"] as? String
                                        if package_data == "2"
                                        {
                                            GoGreenManeger.instance.SetSlidemenuhome()
                                            
                                        }else
                                        {
                                            let SelectCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
                                            self.navigationController?.pushViewController(SelectCityVC, animated: true)
                                            }
                                        
                                    }
                                    
                                }
                            }
                            
                        } else if statuscode == 6 // for Facebook and Google not found social id in backend
                        {
                                 // open dialogue
                                var Array: [Any] = Bundle.main.loadNibNamed("Signupview", owner: self, options: nil)!
                                self.Signuppopview = Array[0] as! Signupview
                                self.Signuppopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
                                self.view.addSubview(self.Signuppopview)
                                self.Signuppopview.setUI()
                                //passData to Popupview
                                self.Signuppopview.namestrpopup = self.namestr
                                self.Signuppopview.logintypepopup = self.logintype
                                self.Signuppopview.socialidpopup = SocialId
                                self.Signuppopview.textemail?.text = emailid
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



