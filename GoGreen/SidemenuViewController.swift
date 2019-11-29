//
//  SidemenuViewController.swift
//  sh8ke
//
//  Created by Prankur on 22/09/17.
//  Copyright © 2017 Sonu. All rights reserved.
//

import UIKit
import AVFoundation


class SidemenuViewController: UIViewController
{
    

    @IBOutlet var topview : UIView!
    @IBOutlet var homebutton : UIButton!
    @IBOutlet var sidecollectionview : UICollectionView!
    var player:AVAudioPlayer!
    @IBOutlet var collectionview : UIView!
    
    @IBOutlet var usernamelbl : UILabel!
    @IBOutlet var emailnamelbl : UILabel!
    @IBOutlet var phonenamelbl : UILabel!
    @IBOutlet weak var headerview: UIView!
    
    
   var window: UIWindow?
   var titlearr = ["Home" , "My Car" , "My Order" , "Term & Condition" , "Rate Us" , "Change Password" , "Invite friends" , "Sign Out"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let emailstr = result["email"] as! String
        let phonestr = result["phone_number"] as! String
        let usernamestr = result["name"] as! String
        self.emailnamelbl.text = emailstr
        self.phonenamelbl.text = phonestr
        self.usernamelbl.text = usernamestr
        if let LocalityId = UserDefaults.standard.object(forKey: "LocalityId")
        {
            GoGreenManeger.instance.LocalityId = LocalityId as! String
            print(GoGreenManeger.instance.LocalityId)
            print(LocalityId)
        }
        
        if let cityid = UserDefaults.standard.object(forKey: "cityid")
        {
            GoGreenManeger.instance.Cityid = cityid as! String
            print(GoGreenManeger.instance.Cityid)
            print(cityid)
        }
        if let streetid = UserDefaults.standard.object(forKey: "streetid")
        {
            GoGreenManeger.instance.Streetid = streetid as! String
            print(GoGreenManeger.instance.Streetid)
            print(streetid)
        }
        
        if let endtime = UserDefaults.standard.object(forKey: "endtime")
        {
            GoGreenManeger.instance.endtime = endtime as! String
            
        }
        
        if let starttime = UserDefaults.standard.object(forKey: "starttime")
        {
            GoGreenManeger.instance.starttime = starttime as! String
        }
        
        
    }
   
    
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {

      
    }
    
    
    //TermsConditionNav
    @IBAction func taptotermandcondtion(sender : UIButton)
    {
        let TermsConditionNav = self.storyboard?.instantiateViewController(withIdentifier: "TermsConditionNav")
        appDelegate.window?.rootViewController = TermsConditionNav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func taptorateus(sender : UIButton)
    {
//        let alert = UIAlertController(title: AppName, message: "Under Development", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
        
        let appID = "1440585352"
        let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
        if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @IBAction func taptoedituser(sender : UIButton)
    {
        let EditUserVCnav = self.storyboard?.instantiateViewController(withIdentifier: "EditUserVCnav")
        appDelegate.window?.rootViewController = EditUserVCnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func taptomycar(sender : UIButton)
    {
        if let apartmentname = UserDefaults.standard.object(forKey: "apartmentname")
        {
            print(apartmentname)
           let CarListVCnav = self.storyboard?.instantiateViewController(withIdentifier: "CarListVCnav")
            appDelegate.window?.rootViewController = CarListVCnav
            appDelegate.window?.makeKeyAndVisible()
        }else
        {
            let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "citylistnav")
            appDelegate.window?.rootViewController = citylistnav
            appDelegate.window?.makeKeyAndVisible()
        }
        
    }
    
    @IBAction func taptoAboutus()
    {
        let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "AboutusVCnav")
        appDelegate.window?.rootViewController = citylistnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    @IBAction func taptomyorder()
    {
        let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderVCnav")
        appDelegate.window?.rootViewController = citylistnav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    @IBAction func taptoinvitefriend()
    {
        // text to share
        let text = "https://itunes.apple.com/in/app/go-green-uae/id1440585352?mt=8"
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads         // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, UIActivityType.postToFacebook ]
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
  
    
    @IBAction func taptochnagepassword(sender : UIButton)
    {
        let ChangePasswordNav = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordNav")
        appDelegate.window?.rootViewController = ChangePasswordNav
        appDelegate.window?.makeKeyAndVisible()
    }
    
    
    
    @IBAction func taptohomebutton(sender : UIButton)
    {
        let HomeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
       sideMenuViewController?.hideMenuViewController()
       sideMenuViewController?.setContentViewController(HomeVC, animated: false)
    }
    
    @IBAction func taptoLogoutbutton(sender : UIButton)
    {
        
        let refreshAlert = UIAlertController(title: AppName, message: "Want to logout ?", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
            GoGreenManeger.instance.flushData()
            
            //GoGreenManeger.instance.LocalityId = ""
            let Signup_obj = self.storyboard?.instantiateViewController(withIdentifier: "LaunchNav")
            if let result = UserDefaults.standard.object(forKey: "logindict_info") as? Dictionary<String,AnyObject> {
                appDelegate.hitApiForPushNotification(fcmDeviceToken: "", result: result)
            }
            appDelegate.window?.rootViewController = Signup_obj
            appDelegate.window?.makeKeyAndVisible()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(refreshAlert, animated: true, completion: nil)
    }

    
    @IBAction func taptocallusbutton(sender : UIButton)
    {
        
        let url: NSURL = URL(string: "TEL://+971-545866100")! as NSURL
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}


extension SidemenuViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        return headerview
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 482.0
    }
}

