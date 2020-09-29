//
//  AboutusVC.swift
//  GoGreen
//
//  Created by Sonu on 13/09/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

class AboutusVC: UIViewController
{

    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var webview: UIWebView!
    var fromclass = ""
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        
        let url = URL (string: "http://13.126.37.218/gogreenstaging/terms-of-use1.html")
        let requestObj = URLRequest(url: url!)
        webview.loadRequest(requestObj)
    }
    
    @IBAction func TaptoBackbtn(sender : UIButton)
    {
        if(fromclass == "bookmycar")
        {
            self.dismiss(animated: true) {}
        }
        else
        {
            GoGreenManeger.instance.SetSlidemenuhome()
        }
    }


    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
  
}
