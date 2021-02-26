//
//  GoGreenManeger.swift
//  GoGreen
//
//  Created by Sonu on 28/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Foundation

import Alamofire
import AVFoundation
import AKSideMenu
import AlamofireImage




class GoGreenManeger: NSObject, AKSideMenuDelegate
{
    static var instance = GoGreenManeger()
    var Cityid = ""
    var LocalityId = ""
    var Streetid = ""
    var Apartmentname = ""
    var isorderconfirm : Bool = false
    
    // selected city , select locality ,  street
    var selectedcity = ""
    var selectedlocalityname = ""
    var selectstreet = ""
    var starttime = ""
    var endtime = ""
    var islocationselected = false
    var issetdidemenu = false
    var window: UIWindow?
    var trasactionid = ""
    var totalamount = ""
    var iseditcardetail = false
    var coupencode = ""
    var ispaymentservicecall = true
    var isuserlogin = false
    var islocationedit = false
    
    
    
    
    func SetSlidemenuhome()
    {
        let mainStoryBoard : UIStoryboard!
          mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let slidemnuvc = mainStoryBoard.instantiateViewController(withIdentifier: "SidemenuViewController") as! SidemenuViewController
        let vc = mainStoryBoard.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
        //side menu
       // self.window = UIWindow(frame: UIScreen.main.bounds)
        // Create content and menu controllers
        let navigationController = UINavigationController(rootViewController: vc)
        let leftMenuViewController = slidemnuvc
       // let rightMenuViewController = slidemnuvc
        // Create side menu controller
        let sideMenuViewController: AKSideMenu = AKSideMenu(contentViewController: navigationController, leftMenuViewController: leftMenuViewController, rightMenuViewController: nil)
        
        // sideMenuViewController.backgroundImage = UIImage(named: "Stars")!
        sideMenuViewController.menuPreferredStatusBarStyle = .lightContent
        sideMenuViewController.delegate = self
        sideMenuViewController.contentViewShadowColor = .black
        sideMenuViewController.contentViewShadowOffset = CGSize(width: 0, height: 0)
        sideMenuViewController.contentViewShadowOpacity = 0.6
        sideMenuViewController.contentViewShadowRadius = 12
        sideMenuViewController.contentViewShadowEnabled = true
        sideMenuViewController.panGestureEnabled = false
        sideMenuViewController.panFromEdge = false
       // sideMenuViewController.backgroundImage = UIImage(named: "Stars")!
        appDelegate.window!.rootViewController = sideMenuViewController
        appDelegate.window!.backgroundColor = .white
        appDelegate.window?.makeKeyAndVisible()
    }
    
    func flushData()
    {
        UserDefaults.standard.removeObject(forKey: "logindict_info")
        UserDefaults.standard.removeObject(forKey: "LocalityId")
        UserDefaults.standard.removeObject(forKey: "streetid")
        UserDefaults.standard.removeObject(forKey: "cityid")
        UserDefaults.standard.removeObject(forKey: "starttime")
        UserDefaults.standard.removeObject(forKey: "endtime")
        UserDefaults.standard.removeObject(forKey: "cityname")
        UserDefaults.standard.removeObject(forKey: "localityname")
        UserDefaults.standard.removeObject(forKey: "apartmentname")
        UserDefaults.standard.removeObject(forKey: "Cardata")
        UserDefaults.standard.removeObject(forKey: "totalamount")
        UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
        UserDefaults.standard.removeObject(forKey: "Coupen")
        GoGreenManeger.instance.issetdidemenu = false
        GoGreenManeger.instance.islocationselected = false
    }
    
    func citydataflush()
    {
        UserDefaults.standard.removeObject(forKey: "cityname")
        UserDefaults.standard.removeObject(forKey: "localityname")
        UserDefaults.standard.removeObject(forKey: "streetid")
        UserDefaults.standard.removeObject(forKey: "apartmentname")
        UserDefaults.standard.removeObject(forKey: "streetname")
        GoGreenManeger.instance.selectstreet = ""
        GoGreenManeger.instance.Apartmentname = ""
    }
    
    
    func HitserviceForPaymentgateway()
    {
        ispaymentservicecall = false
        let totalamount = UserDefaults.standard.object(forKey: "totalamount") as! Int
        let transactionId = UserDefaults.standard.value(forKey: "pt_transaction_id") as! String
        let Cardata = UserDefaults.standard.object(forKey: "Cardata")
        let result = UserDefaults.standard.object(forKey: "logindict_info") as!
            Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        let discount = UserDefaults.standard.object(forKey: "Coupen") as! Int
        if discount == 0
        {
            GoGreenManeger.instance.coupencode = "NO"
            
        } else
        {
            GoGreenManeger.instance.coupencode = String(discount)
            
        }
        
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"insert_booked_services",
                     "app_key":"123456",
                     "user_id":user_id,
                     "transaction_id": transactionId,
                     "net_paid": totalamount - discount,
                     "cars": Cardata,
                     "actual_payment": totalamount,
                     "payment_type": "2",
                     "city_id" :GoGreenManeger.instance.Cityid,
                     "locality_id" : GoGreenManeger.instance.LocalityId,
                     "street_id" : GoGreenManeger.instance.Streetid,
                     "coupan_applied":GoGreenManeger.instance.coupencode
            ] as [String : AnyObject]
//        let param = ["method":"insert_booked_services" as AnyObject,
//                     "app_key":"123456" as AnyObject,
//                     "user_id":user_id as AnyObject,
//                     "transaction_id": transactionId as AnyObject,
//                     "net_paid":totalamount as AnyObject,
//                      "cars": Cardata] as [String : AnyObject]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            self.ispaymentservicecall = false
                            UserDefaults.standard.removeObject(forKey: "pt_response_code")
                            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
                            UserDefaults.standard.removeObject(forKey: "Cardata")
                            UserDefaults.standard.removeObject(forKey: "totalamount")
                            UserDefaults.standard.removeObject(forKey: "Coupen")
                            GoGreenManeger.instance.SetSlidemenuhome()
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
                            result["is_payment"] = "2"
                            UserDefaults.standard.set(result, forKey: "logindict_info")

                        } else
                        {


                        }
                    }

                }
            }
            else
            {
                    
            }
        }
    }
    
}
