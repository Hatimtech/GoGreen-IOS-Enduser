//
//  TermsConditionVC.swift
//  GoGreen
//
//  Created by Sonu on 25/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

class TermsConditionVC: UIViewController
{
    @IBOutlet weak var topview: UIView!
    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        let url  = URL(string: "http://13.126.37.218/gogreen/gogreen-info.html")
        let request:URLRequest = URLRequest(url: url!)
        webview.loadRequest(request)
       
    }
    
    @IBAction func TaptoBackbtn(sender : UIButton)
    {
        GoGreenManeger.instance.SetSlidemenuhome()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
       
}
