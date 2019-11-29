//
//  AppDelegate.swift
//  GoGreen
//
//  Created by Sonu on 28/05/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import GoogleSignIn
import IQKeyboardManagerSwift
import AKSideMenu
import Fabric
import Crashlytics
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate ,AKSideMenuDelegate
{
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        Fabric.with([Crashlytics.self])
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        registerForPushNotifications()
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplicationBackgroundFetchIntervalMinimum)
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        Messaging.messaging().isAutoInitEnabled = true
        
        IQKeyboardManager.sharedManager().enable = true
        GIDSignIn.sharedInstance().clientID = GoogleClientid
        GoGreenManeger.instance.islocationselected = false
        if UserDefaults.standard.object(forKey: "isfirsttimeshowow") == nil
        {
            let mainStoryBoard : UIStoryboard!
            mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
            let vc = mainStoryBoard.instantiateViewController(withIdentifier: "TutorialVC") as! TutorialVC
            let navigationController = UINavigationController(rootViewController: vc)
            self.window?.rootViewController = navigationController
            navigationController.navigationBar.isHidden = true
            window?.makeKeyAndVisible()
            UserDefaults.standard.set(true, forKey: "isfirsttimeshowow")
            return true
        }
        if let pendingpaymentdata =  UserDefaults.standard.object(forKey: "pt_transaction_id")
        {
            if GoGreenManeger.instance.ispaymentservicecall == true
            {
                GoGreenManeger.instance.HitserviceForPaymentgateway()
            }
        }
        
        
        if (UserDefaults.standard.value(forKey: "logindict_info") as? Dictionary<String,AnyObject>) != nil
        {
            let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
            print(result )
            let is_phone_verified = result["is_phone_verified"] as? String
            let package_data = result["is_payment"] as? String
            
            if is_phone_verified == "0"
            {
                let mainStoryBoard : UIStoryboard!
                mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                let vc = mainStoryBoard.instantiateViewController(withIdentifier: "SMSVerificationphone") as! SMSVerificationphone
                let navigationController = UINavigationController(rootViewController: vc)
                self.window?.rootViewController = navigationController
                navigationController.navigationBar.isHidden = true
                window?.makeKeyAndVisible()
                
            }else {
                
                if package_data == "2"
                {
                    GoGreenManeger.instance.SetSlidemenuhome()
                    GoGreenManeger.instance.isuserlogin = true
                    //                    let mainStoryBoard : UIStoryboard!
                    //                    mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    //                    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
                    //                    let navigationController = UINavigationController(rootViewController: vc)
                    //                    self.window?.rootViewController = navigationController
                    //                    navigationController.navigationBar.isHidden = true
                    //                    window?.makeKeyAndVisible()
                    
                }else
                {
                    let mainStoryBoard : UIStoryboard!
                    mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = mainStoryBoard.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
                    let navigationController = UINavigationController(rootViewController: vc)
                    self.window?.rootViewController = navigationController
                    navigationController.navigationBar.isHidden = true
                    window?.makeKeyAndVisible()
                }
                
            }
            
        }
        //        let mainStoryBoard : UIStoryboard!
        //        mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        //        let HowitworkVc = mainStoryBoard.instantiateViewController(withIdentifier: "HowitworkVc") as! HowitworkVc
        //        self.window?.rootViewController = HowitworkVc
        //        window?.makeKeyAndVisible()
        
        
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current() // 1
            .requestAuthorization(options: [.alert, .sound, .badge]) { // 2
                granted, error in
                print("Permission granted: \(granted)") // 3
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
        }
    }
    
    func hitApiForPushNotification(fcmDeviceToken : String, result : [String : AnyObject])
    {
        let user_id = result["id"] as! String
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = [ "method":"update_device_token",
                      "app_key":"123456",
                      "user_id": user_id,
                      "token": fcmDeviceToken,
                      "d_type":"ios"] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: car_packages, parameters: param as [String : AnyObject], encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            //      MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                var logindict_info = [String:String]()
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {// sucessful
                            print(dict1)
                        }
                    }
                }
            }
        }
    }
    
    
    
    private func application(application: UIApplication,
                             didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        Messaging.messaging().apnsToken = deviceToken as Data
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool
    {
        let canHandlefacebookURL = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        let canHandleGoogleUrl =  GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
        if canHandleGoogleUrl
        {
            return canHandleGoogleUrl
        } else {
            
            return canHandlefacebookURL
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication)
    {
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication)
    {
        
    }
    
    func applicationWillEnterForeground(_ application: UIApplication)
    {
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication)
    {
        let appversion = UIApplication.appVersion()
        hitserviceForCheckUpdate(appVersion: appversion)
    }
    
    func applicationWillTerminate(_ application: UIApplication)
    {
        
    }
    
    func hitserviceForCheckUpdate(appVersion : String)
    {
        
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"check_app_compatiblity",
                     "version": appVersion,
                     "device_type":"ios",
                     "app_key": "123456",
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: api, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let resCode = dict1["resCode"] as? Int{
                        if resCode == 0{
                            let alert = UIAlertController(title: AppName, message:dict1["message"] as! String, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Update", style: UIAlertActionStyle.cancel, handler: { (act) in
                                self.openAppStoreURL()
                            }))
                            UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
                        }
                        
                    }
                }
                
            }
        }
    }
    
    func openAppStoreURL(){
        guard let url = URL(string: "https://itunes.apple.com/ae/app/go-green-uae/id1440585352?mt=8") else {
            return //be safe
        }
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
}




extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void){
        completionHandler([.alert, .badge, .sound])
        
        let userInfo = notification.request.content.userInfo;
        print(userInfo)
        print("willPresent notification...............................................")
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void){
        NSLog("%@", response.notification.request.content.userInfo);
        let userInfo  = response.notification.request.content.userInfo
        print(userInfo)
        if let orderID = userInfo["gcm.notification.order_id"] as? String{
            print(orderID)
            NotificationCenter.default.post(name: .didReceivedPushNofication, object: nil, userInfo: userInfo)
        }
        //        if let topVC = UIApplication.getTopMostViewController() {
        //            print(topVC)
        //
        //        }
        
        print("didReceive response............................................")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?){
        
    }
}

extension AppDelegate : MessagingDelegate {
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        
        NSLog("Firebase registration token: = %@", fcmToken )
        let dataDict:[String: String] = ["token": fcmToken]
        if (UserDefaults.standard.value(forKey: "logindict_info") as? Dictionary<String,AnyObject>) != nil
        {
            let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
            print(result )
            let is_phone_verified = result["is_phone_verified"] as? String
            let package_data = result["is_payment"] as? String
            
            if is_phone_verified == "0"
            {
            }else {
                
                if package_data == "2"
                {
                    hitApiForPushNotification(fcmDeviceToken: fcmToken, result: result)
                }else
                {
                    hitApiForPushNotification(fcmDeviceToken: fcmToken, result: result)
                }
            }
        }
        
        
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
    
}


extension UIApplication {
    class func getTopMostViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return getTopMostViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return getTopMostViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return getTopMostViewController(base: presented)
        }
        return base
    }
    
    
    
    class func appVersion() -> String {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
    }
    
    class func appBuild() -> String {
        return Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as! String
    }
    
    class func versionBuild() -> String {
        let version = appVersion(), build = appBuild()
        
        return version == build ? "v\(version)" : "v\(version)(\(build))"
    }
}
