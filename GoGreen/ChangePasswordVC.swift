
//
//  ChangePassword.swift
//  GoGreen
//
//  Created by Sonu on 25/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD

class ChangePasswordVC: UIViewController
{
   
    @IBOutlet weak var oldpasstextf: UITextField!
    @IBOutlet weak var newpasstextf: UITextField!
    @IBOutlet weak var confirmpasstextf: UITextField!
    @IBOutlet weak var topview: UIView!
    
     
    
    
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
        oldpasstextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Old Password", attributes:attributes)
        newpasstextf.attributedPlaceholder = NSAttributedString(string: "Enter Your New Password", attributes:attributes)
        confirmpasstextf.attributedPlaceholder = NSAttributedString(string: "Enter Your Confirm Password", attributes:attributes)
      }
    
    
    @IBAction func TaptoBackbtn(sender : UIButton)
    {
        GoGreenManeger.instance.SetSlidemenuhome()
    }
    
    @IBAction func TaptoSavebtn(sender : UIButton)
    {
        if (oldpasstextf.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "Please enter old password" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (newpasstextf.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "Please enter new password" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else if (confirmpasstextf.text?.isEmpty)!
        {
            let alert = UIAlertController(title: AppName, message: "Please enter confirm password" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else  if (newpasstextf.text?.isEmpty)! || (newpasstextf.text?.count)! < 6{
            let alert = UIAlertController(title: AppName, message: "Please enter minimum 6 digit password" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else if newpasstextf.text != confirmpasstextf.text {
            let alert = UIAlertController(title: AppName, message: "Password Doesn't Match" , preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
        } else
        {
            
            HitserviceForchangepassword()
            
        }
    }
    
    func HitserviceForchangepassword()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"change_password",
                     "app_key":"123456",
                     "user_id":user_id,
                     "old_password":oldpasstextf.text ?? "nil",
                     "new_password":newpasstextf.text ?? "nil"
    ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: change_password, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
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
                            //popup
                            let refreshAlert = UIAlertController(title: AppName, message: "Password Successfully change", preferredStyle: UIAlertControllerStyle.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                                
                                GoGreenManeger.instance.SetSlidemenuhome()
                                
                                self.navigationController?.popViewController(animated: true)
                            }))
                            self.present(refreshAlert, animated: true, completion: nil)
                            //return
                        }else
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

    
   


