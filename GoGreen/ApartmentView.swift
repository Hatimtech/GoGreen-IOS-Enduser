//
//  ApartmentView.swift
//  GoGreen
//
//  Created by Sonu on 10/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import IQKeyboardManagerSwift


protocol addobserverdelegate
{
    func observeradd()
    
}


class ApartmentView: UIView
{

    @IBOutlet var textapartment : UITextField!
    @IBOutlet var crossbtn : UIButton?
    @IBOutlet var Submitbtn : UIButton?
     var delegate : addobserverdelegate?

    @IBAction func taptosubmitbtn()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        print(result )
        let package_data = result["is_payment"] as? String
        
        if (textapartment.text?.isEmpty)!
        {
            if let topController = UIApplication.topViewController()
            {
                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter Apartment Number")
            }
        } else if GoGreenManeger.instance.islocationselected == true
        {
            let apartmentname = textapartment.text!
            GoGreenManeger.instance.Apartmentname = textapartment.text!
            UserDefaults.standard.set(apartmentname, forKey: "apartmentname")
            GoGreenManeger.instance.islocationselected = false
            GoGreenManeger.instance.SetSlidemenuhome()
            if let apartmentname = UserDefaults.standard.object(forKey: "apartmentname")
            {
                if GoGreenManeger.instance.islocationedit == true
                {
                    GoGreenManeger.instance.SetSlidemenuhome()
                    GoGreenManeger.instance.islocationedit = false
                }else
                {
                    let mainStoryBoard : UIStoryboard!
                    mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let CarListVCnav = mainStoryBoard.instantiateViewController(withIdentifier: "CarListVCnav")
                    appDelegate.window?.rootViewController = CarListVCnav
                    appDelegate.window?.makeKeyAndVisible()
                }
            }
            
        }else
        {
            if let topController = UIApplication.topViewController()
            {
                GoGreenManeger.instance.Apartmentname = textapartment.text!
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let SMSVerification = storyboard.instantiateViewController(withIdentifier: "CarListVC") as! CarListVC
                IQKeyboardManager.sharedManager().enable = true; topController.navigationController?.pushViewController(SMSVerification, animated: true)
            }
            UserDefaults.standard.set(textapartment.text, forKey: "apartmentname")
            if let Apartmentname = UserDefaults.standard.object(forKey: "apartmentname")
            {
                GoGreenManeger.instance.Apartmentname = Apartmentname as! String
            }
            self.delegate?.observeradd()
            self.removeFromSuperview()
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
    
    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
        self.delegate?.observeradd()
        self.removeFromSuperview()
    }
}

