//
//  CoupenView.swift
//  GoGreen
//
//  Created by Sonu on 28/08/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

protocol coupencodedelegate
{
    func feedback(coupencodestr : String)
}

class CoupenView: UIView
{
    var Delegate : coupencodedelegate!
    @IBOutlet var coupentextf : UITextField!
    

    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
        self.removeFromSuperview()
    }
    
    
    @IBAction func TaptoSubmitbtn(sender : UIButton)
    {
        if (coupentextf.text?.isEmpty)!
        {
            if let topController = UIApplication.topViewController()
            {
                self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Enter a Coupon")
            }

        }else
        {
            self.Delegate.feedback(coupencodestr: (coupentextf?.text?.removingWhitespaces())!)
            self.removeFromSuperview()
        }
  }
    
    func emptyalertpopshow(view:UIViewController , Titlestr : String ,descriptionStr : String)
    {
        let alert = UIAlertController(title: Titlestr, message:  descriptionStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
