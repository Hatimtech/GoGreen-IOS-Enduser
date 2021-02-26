//
//  WrongNumberView.swift
//  GoGreen
//
//  Created by Sonu on 20/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD


 protocol mobilenumberchangedelegate
{
    func changemobilenumber(mobilenumber : String)
   
}




class WrongNumberView: UIView , UITextFieldDelegate
{
    @IBOutlet var textphone : UITextField!
    @IBOutlet var tfdial : UITextField!
    @IBOutlet var crossbtn : UIButton?
    @IBOutlet var Submitbtn : UIButton?
    var mobilenumberstr = ""
    
    var delegate : mobilenumberchangedelegate?
    
    @IBAction func taptosubmitbtn()
    {
        if (tfdial.text?.isEmpty)!, let topController = UIApplication.topViewController()
        {
            self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Valid Dial Number")
            
        }else if (textphone.text?.isEmpty)! || textphone.text!.count < 6 
        {
            if let topController = UIApplication.topViewController()
            {
                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Valid Mobile Number")
            }
        } else
        {
            self.HitserviceForWrongphonenumber()
        }
    }
    
    
    func emptyalertpopshow(view:UIViewController , Titlestr : String ,descriptionStr : String)
    {
        let alert = UIAlertController(title: Titlestr, message:  descriptionStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    func HitserviceForWrongphonenumber()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        print(user_id)
        if let topController = UIApplication.topViewController()
        {
            addprogressbar(view: topController)
        }
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let dailcode = tfdial.text!
        let param = ["method":"update_phone_number",
                     "app_key":"123456",
                     "user_id":user_id,
                     "phone_number": dailcode + textphone.text! as Any] as [String : Any]
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
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
                            result["phone_number"] = dailcode + self.textphone.text!
                            UserDefaults.standard.set(result, forKey: "logindict_info")
                            let Dic = UserDefaults.standard.object(forKey: "logindict_info")
                            print(Dic ?? "nil")
                            
                            
                            self.delegate?.changemobilenumber(mobilenumber: dailcode + self.textphone.text!)
                                self.removeFromSuperview()
                            
                        }else if statuscode == 0
                        {
                            let descriptionStr = dict1["message"] as! String
                            if let topController = UIApplication.topViewController()
                            {
                                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : descriptionStr)
                                
                            }
                        
                        }else
                        {
                            
                            
                            
                        }
                        }
                    }
                }
            }
        }

            
    func addprogressbar(view: UIViewController)
    {
        MBProgressHUD.showAdded(to: view.view, animated: true)
    }
    
    func hideprogressbar(view: UIViewController)
    {
        MBProgressHUD.hide(for: view.view, animated: true)
        
    }
    
    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
        
        self.removeFromSuperview()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let charsLimit = 13
        let startingLength = textphone.text?.characters.count ?? 0
        let lengthToAdd = string.characters.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
}
