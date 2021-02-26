//
//  CarModelview.swift
//  GoGreen
//
//  Created by Sonu on 09/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD


protocol Datavaluechangedelegate
{
    func changevalue(isvaluechange : Bool)
    
}


class CarModelview: UIView
{

    @IBOutlet var textcarmodel : UITextField?
    @IBOutlet var textcarbrand : UITextField!
    var carbrandname = ""
    var carbrandid = ""
    var isbothfieldnil = false
    var delegate : Datavaluechangedelegate?
    
    
    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
        self.delegate?.changevalue(isvaluechange: true)
        self.removeFromSuperview()
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
    
    
    @IBAction func taptosubmitbtn(sender : UIButton)
    {
        if isbothfieldnil == true
        {
           
            if (self.textcarbrand?.text?.isEmpty)!
            {
                if let topController = UIApplication.topViewController()
                {
                    self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Car Brand")
                }
            }else if (self.textcarmodel?.text?.isEmpty)!
            {
                if let topController = UIApplication.topViewController()
                {
                    self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Car Model")
                }
            }else {
                
                 self.HitserviceForAddcarBrand()
            }
            
        }else
        {
            
                HitserviceForAddcarModel(brand_id : self.carbrandid)
        }
    }
    
    func HitserviceForAddcarBrand()
    {
        
        if let topController = UIApplication.topViewController()
        {
            addprogressbar(view: topController)
        }
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"add_brand",
                     "app_key":"123456",
                     "brand_name": self.textcarbrand.text ?? "nil",
                     "model_name":self.textcarmodel?.text ?? "nil",
                     "type":"user"] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            if let topController = UIApplication.topViewController()
            {
                self.hideprogressbar(view: topController)
            }
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            self.isbothfieldnil = false
                            self.delegate?.changevalue(isvaluechange: true)
                            self.removeFromSuperview()
                            
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                
                                if let topController = UIApplication.topViewController()
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

    
    func HitserviceForAddcarModel(brand_id : String)
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print(result)
        let user_id = result["id"] as! String
        if let topController = UIApplication.topViewController()
        {
            addprogressbar(view: topController)
        }
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"add_model",
                     "app_key":"123456",
                     "name": self.textcarmodel?.text ?? "Nil",
                     "type":"user",
                     "brand_id":brand_id] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            if let topController = UIApplication.topViewController()
            {
                self.hideprogressbar(view: topController)
            }
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                             self.carbrandid = ""
                            self.delegate?.changevalue(isvaluechange: true)
                            self.removeFromSuperview()
                            
                        } else
                        {
                            if let msgstr = dict1["message"] as? String
                            {
                                
                                if let topController = UIApplication.topViewController()
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


