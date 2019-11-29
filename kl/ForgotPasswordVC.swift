//
//  ForgotPasswordVC.swift
//  Parcelo
//
//  Created by Prankur on 15/05/18.
//  Copyright © 2018 Com.parcelo. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD

class ForgotPasswordVC: UIViewController , UITextFieldDelegate
{

    @IBOutlet weak var txtemail: UITextField!
    @IBOutlet var Sendbtn: UIButton!
    @IBOutlet var topview : UIView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtemail.delegate = self
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
            NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
        ]
        txtemail.attributedPlaceholder = NSAttributedString(string: "Enter Your Email", attributes:attributes)
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false

    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        txtemail.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func taponforgotPasswordbtn(sender : UIButton)
    {
        if (txtemail?.text?.isEmpty)! || isValidEmail(testStr: txtemail.text!) == false
        {
            let alert = UIAlertController(title: AppName, message: "please valid enter Email", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else
        {
           self.HitserviceForForgotpassword()
        }
        
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
    
    
    func HitserviceForForgotpassword()
    {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let emailstring = self.txtemail.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let param = ["method":"forget_password",
                     "app_key":"123456",
                    "device_type":"ios" ,
                    "email": emailstring] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: FORGOTPASSWORD, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
         MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let statuscode = dict1["resCode"] as! NSNumber
                    print(statuscode)
                    if statuscode == 1
                    {
                        if let msgstr = dict1["message"] as? String
                        {
                            let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                        }
                            //self.navigationController?.popViewController(animated: true)
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
    
}
