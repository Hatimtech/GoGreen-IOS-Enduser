//
//  LogoutVC.swift
//  GoGreen
//
//  Created by Sonu on 27/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

class LogoutVC: UIViewController
{

    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }
    
    
    @IBAction func taptologoutbtn(sender : UIButton)
    {
        let Signup_obj = self.storyboard?.instantiateViewController(withIdentifier: "LaunchNav")
        appDelegate.window?.rootViewController = Signup_obj
        appDelegate.window?.makeKeyAndVisible()
        UserDefaults.standard.removeObject(forKey: "logindict_info")
    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
       
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func taptobookacar(sender : UIButton)
    {
        let CarListVC = self.storyboard?.instantiateViewController(withIdentifier: "CarListVC") as! CarListVC
        self.navigationController?.pushViewController(CarListVC, animated: true)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
}
