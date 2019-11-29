//
//  CashOnDeleveryVC.swift
//  GoGreen
//
//  Created by Sonu on 02/08/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import IQKeyboardManagerSwift
import MBProgressHUD
import FacebookCore

class CashOnDeleveryVC: UIViewController
{

    @IBOutlet var topview : UIView!
    @IBOutlet var upperview : UIView!
    @IBOutlet var downview : UIView!
    @IBOutlet var btnAutoRenew : UIButton!
    var trasactionid = ""
    var carreceivedata_arr = [CarData]()
    var totalamount : Int = 0
    var datapasstoService : [Dictionary<String,AnyObject>] = []
    var expandedCells = [Int]()
    var discount : Int = 0
    var pendingrenewarr : [Dictionary<String,AnyObject>] = []
    var datestrpass = ""
    var initialSetupViewController: PTFWInitialSetupViewController!
    var isPushNoficationSelected = false
    var pushOrderID = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if discount == 0
        {
            GoGreenManeger.instance.coupencode = "NO"
        } else
        {
            GoGreenManeger.instance.coupencode = String(discount)
        }
        
        UserDefaults.standard.set(discount, forKey: "Coupen")
        print(UserDefaults.standard.object(forKey: "Coupen") as! Int)
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        
        
        upperview.layer.shadowColor = UIColor.darkGray.cgColor
        upperview.layer.shadowOpacity = 1
        upperview.layer.shadowOffset = CGSize.zero
        upperview.layer.shadowRadius = 5
        
        btnAutoRenew.setImage(#imageLiteral(resourceName: "select_check_box_icon"), for: .normal)
        downview.layer.shadowColor = UIColor.darkGray.cgColor
        downview.layer.shadowOpacity = 1
        downview.layer.shadowOffset = CGSize.zero
        downview.layer.shadowRadius = 5
        self.dataappendbyarray()
    }
    
    
    func dataappendbyarray()
    {
        if isPushNoficationSelected == true{
            hitServiceForCarPackages(for: pushOrderID)
            isPushNoficationSelected = false
        }else if self.pendingrenewarr.count == 0
        {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var Datestr = formatter.string(from: date)
            for dic in carreceivedata_arr
            {
                var ismonthly = ""
                var frequency : Int = 0
                var caramount : Int = 0
                var services = ""
                var appenddays = ""
                if dic.isonetime == true
                {
                    ismonthly = "once"
                    dic.numberOfMonth = 0
                }else
                {
                    ismonthly = "monthly"
                    frequency = dic.frequencyindex
                    for dic in dic.selecteddayarr
                    {
                        appenddays += dic + ","
                    }
                }
                
                if dic.isinterior && dic.isexterior
                {
                    services = "3"
                    
                }else if dic.isinterior
                {
                    services = "1"
                }else
                {
                    services = "2"
                }
                caramount = dic.caramount
                self.totalamount += dic.caramount
                if appenddays != ""
                {
                    appenddays.remove(at: appenddays.index(before: appenddays.endIndex))
                }
                let arrayofDict = ["car_id": dic.carid , "package_type": ismonthly , "purchase_date": Datestr , "services": services , "frequency": frequency , "amount": caramount ,  "days" : appenddays, "coupan_applied" : "","one_time_service_date":dic.date, "no_of_months": dic.numberOfMonth, "package_name" : dic.pack_name] as [String : AnyObject]
                print(arrayofDict)
                self.datapasstoService.append(arrayofDict)
            }
        }else{
            print(pendingrenewarr[0]["amount"])
            let amount = pendingrenewarr[0]["amount"] as? String
            self.totalamount = Int(amount!)!
            
            var packName = ""
            if let pName = pendingrenewarr[0]["package_name"] as? String{
                packName = pName
            }
            var nOMonth = "0"
            if let nom = pendingrenewarr[0]["no_of_months"] as? String{
                nOMonth = nom
            }
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var currentDateStr = formatter.string(from: date)
           
          let arrayofDict = ["car_id": pendingrenewarr[0]["car_id"], "package_type": pendingrenewarr[0]["package_type"] ?? "" as AnyObject, "purchase_date": currentDateStr, "services": "1" , "frequency": pendingrenewarr[0]["frequency"] , "amount": pendingrenewarr[0]["amount"] ,  "days" : pendingrenewarr[0]["days"], "coupan_applied" : "", "one_time_service_date": self.datestrpass, "no_of_months": nOMonth, "package_name" : packName] as [String : AnyObject]
            print(arrayofDict)
          self.datapasstoService.append(arrayofDict)
          UserDefaults.standard.set(self.totalamount, forKey: "totalamount")
          UserDefaults.standard.set(self.datapasstoService, forKey: "Cardata")
    }
}
    
    
    
    @IBAction func tapToAutoRenewButton(sender : UIButton)
    {
        let currentSetImage = sender.image(for: .normal)
        if currentSetImage == #imageLiteral(resourceName: "select_check_box_icon"){
            btnAutoRenew.setImage(#imageLiteral(resourceName: "unselect_check_box_icon"), for: .normal)
        }else{
             btnAutoRenew.setImage(#imageLiteral(resourceName: "select_check_box_icon"), for: .normal)
        }
    }
    
    @IBAction func taptoonlinepayment(sender : UIButton)
    {
        
        let alert = UIAlertController(title: "Go Green", message: "Do you want to make an online payment ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
//            if GoGreenManeger.instance.selectedlocalityname == "JLT TOWER"
//            {
//                let refreshAlert = UIAlertController(title: AppName, message: "Location is JLT TOWER", preferredStyle: UIAlertControllerStyle.alert)
//                refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
//
//                    self.paytabsCall()
//                }))
//                self.present(refreshAlert, animated: true, completion: nil)
//            }
//            else
//            {

                self.paytabsCall()

//            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))

        present(alert, animated: true, completion: nil)
    }
    
    
    func HitserviceForPaymentgateway(transactionid : String, Cardata: [Dictionary<String,AnyObject>] , paymnettype : String, pt_token : String = "", pt_email : String = "",  pt_password : String = "", auto_renewal : String = "")
    {
        
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        
        var netPaid = self.totalamount - discount
        if isPushNoficationSelected && Cardata.count > 0{
            netPaid = Int(Cardata[0]["amount"] as! String) ?? 0
        }
        
    
        
        let param = ["method":"insert_booked_services",
                     "app_key":"123456",
                     "user_id":user_id,
                     "transaction_id": transactionid,
                     "net_paid":netPaid,
                     "cars": self.datapasstoService,
                     "actual_payment":self.totalamount,
                     "payment_type":paymnettype,
                     "coupan_applied":GoGreenManeger.instance.coupencode, 
            "city_id" :GoGreenManeger.instance.Cityid,
            "locality_id" : GoGreenManeger.instance.LocalityId,
            "street_id" : GoGreenManeger.instance.Streetid,
            "pt_token" : pt_token,
            "pt_email" : pt_email,
            "pt_password" : pt_password,
            "auto_renewal" : auto_renewal,
            
                     ] as [String : AnyObject]
        
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
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
                            self.logNewPackegeActivateEvent(new_Packege_Activate: "New_Packege_Activate")
                            AppEvent.purchased(amount: 10.34, currency: "AED", extraParameters: ["":""])
                            let alert = UIAlertController(title: AppName, message: "Thank you for your order, your car service will commence shortly", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)
                            GoGreenManeger.instance.SetSlidemenuhome()
                            self.totalamount = 0
                            UserDefaults.standard.removeObject(forKey: "pt_response_code")
                            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
                            result["is_payment"] = "2"
                            UserDefaults.standard.set(result, forKey: "logindict_info")
                            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
                            
                        } else{
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
            else
            {
                let alert = UIAlertController(title: AppName, message: "Something Went Wrong", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logNewPackegeActivateEvent(new_Packege_Activate : String) {
        let params : AppEvent.ParametersDictionary = ["New_Packege_Activate" : new_Packege_Activate]
        let event = AppEvent(name: "Packege Activate", parameters: params)
        AppEventsLogger.log(event)
    }
    
    @IBAction func taptocashondelevery(sender : UIButton)
    {
        
        let alert = UIAlertController(title: "Go Green", message: "For cash on service orders,We charge 5 AED extra. Do you want to continue ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
            self.totalamount = self.totalamount - self.discount + 5;
            var auto_renewal = "2"
            let currentSetImage = self.btnAutoRenew.image(for: .normal)
            if currentSetImage == #imageLiteral(resourceName: "unselect_check_box_icon"){
                auto_renewal = "1"
            }
            
//            self.HitserviceForPaymentgateway(transactionid: "COD", Cardata: self.datapasstoService, paymnettype: "1")
             self.HitserviceForPaymentgateway(transactionid : "COD", Cardata: self.datapasstoService, paymnettype: "1", pt_token: "", pt_email: "", pt_password: "", auto_renewal: auto_renewal)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
        }))
        
        present(alert, animated: true, completion: nil)


    }
    
    func paytabsCall()
    {
        IQKeyboardManager.sharedManager().enable = false
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
        let emailstr = result["email"]!
        let user_Name = result["name"]!
        var user_Phone = result["phone_number"]!
        print(emailstr )
//        if user_Phone.hasPrefix("+971"){
//            
//        }else{
//            user_Phone = "+971" + user_Phone
//        }
//       
        var email = ""
        var secretKey = ""
        let payment_type_val = UserDefaults.standard.object(forKey: "payment_type") as! String
//        if payment_type_val == "1"
//        {
//            //By Karan
//            email = "manjeet.singh@ripenapp.com"//"karan@ripenapps.com"
//            secretKey =  "Mp0s7ZpjVLRknXNfG5qIznDLunSnBH1o71Qe0gxW2pgqm4F3a5MJtpvXNnlp5mNdoErpVZlXpBoMG3QQ9CzC14AOsWeyi1LGGd6C" //"nCqyPKUQExNhDKiQqZpRF4Bp9dNFH875KyEzizqX7eeKYxBpw1gc5SCe5pUNx1TizxSS7iPew4ZvCAV8BbkH4WWamQYUSRcrp4kw"
//        }
//        else
//        {
//            //By Karan
//            email = "manjeet.singh@ripenapp.com"//"abhishek@ripenapps.com";
//            secretKey = "Mp0s7ZpjVLRknXNfG5qIznDLunSnBH1o71Qe0gxW2pgqm4F3a5MJtpvXNnlp5mNdoErpVZlXpBoMG3QQ9CzC14AOsWeyi1LGGd6C" //"PqoVISuqaN6DXhiWB7oV4cgSpJvII2tytRubKZCUMJxJ1PFCX4y1hOUGxpogsSOVJi7tiKo4tVOuLt7IyFKQtEw14VhwN6sxpA0H";
//        }
        ///
        
        if isPushNoficationSelected && datapasstoService.count > 0{
            if let totalamount = datapasstoService[0]["amount"] as? Int{
                self.totalamount = totalamount
            }else if let totalamount = datapasstoService[0]["amount"] as? String{
                self.totalamount = Int(totalamount)!
            }else if let totalamount = datapasstoService[0]["amount"] as? Float{
                self.totalamount = Int(totalamount)
            }
        }
        
        email = "karan@ripenapps.com"
        secretKey = "nCqyPKUQExNhDKiQqZpRF4Bp9dNFH875KyEzizqX7eeKYxBpw1gc5SCe5pUNx1TizxSS7iPew4ZvCAV8BbkH4WWamQYUSRcrp4kw"

        let orderID = String(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))
        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)
         self.initialSetupViewController = PTFWInitialSetupViewController(nibName: ApplicationXIBs.kPTFWInitialSetupView,
                                                  bundle: bundle,
                                                  andWithViewFrame: self.view.frame,
                                                  andWithAmount: Float(totalamount - self.discount),
                                                  andWithCustomerTitle: user_Name,
                                                  andWithCurrencyCode: "AED",
                                                  andWithTaxAmount: 0.0,
                                                  andWithSDKLanguage: "en",
                                                  andWithShippingAddress: GoGreenManeger.instance.selectedlocalityname  +  ", " + GoGreenManeger.instance.selectedcity,
                                                  andWithShippingCity: GoGreenManeger.instance.selectedlocalityname,
                                                  andWithShippingCountry: "ARE",
                                                  andWithShippingState: GoGreenManeger.instance.selectedcity,
                                                  andWithShippingZIPCode: "00971",
                                                  andWithBillingAddress: GoGreenManeger.instance.selectedlocalityname  +  ", " + GoGreenManeger.instance.selectedcity,
                                                  andWithBillingCity: GoGreenManeger.instance.selectedlocalityname,
                                                  andWithBillingCountry: "ARE",
                                                  andWithBillingState: GoGreenManeger.instance.selectedcity,
                                                  andWithBillingZIPCode: "00971",
                                                  andWithOrderID: orderID,
                                                  andWithPhoneNumber: user_Phone,
                                                  andWithCustomerEmail: emailstr,
                                                  andIsTokenization: true,
                                                  andWithMerchantEmail: email,
                                                  andWithMerchantSecretKey: secretKey,
                                                  andWithAssigneeCode: "SDK",
                                                  andWithThemeColor: UIColor.green,
                                                  andIsThemeColorLight: true)
                
        weak var weakSelf = self
        self.initialSetupViewController.didReceiveBackButtonCallback = {
            weakSelf?.handleBackButtonTapEvent()
        }
        
        self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in

            if responseCode == 100 {
                self.trasactionid = String(transactionID)
               print(result)
               print(transactionID)
                print(tokenizedCustomerPassword)
                print(tokenizedCustomerEmail)
                print(transactionState)
                print(token)
                var auto_renewal = "2"
                let currentSetImage = self.btnAutoRenew.image(for: .normal)
                if currentSetImage == #imageLiteral(resourceName: "unselect_check_box_icon"){
                   auto_renewal = "1"
                }
                self.HitserviceForPaymentgateway(transactionid : self.trasactionid, Cardata: self.datapasstoService, paymnettype: "2", pt_token: token, pt_email: tokenizedCustomerEmail, pt_password: tokenizedCustomerPassword, auto_renewal: auto_renewal)
            }else{
                
                var errorMessage = ""
                switch responseCode {
                case 4001:
                    errorMessage = "Missing parameters"
                    break
                    
                case 4002:
                    errorMessage = "Invalid Credentials"
                    break
                case 0404:
                    errorMessage = "You don’t have permissions"
                    break
                case 4015:
                    errorMessage = "Invalid tokenization Credentials"
                    break
                case 4091:
                    errorMessage = "There are no transactions available."
                    break
                case 481,482:
                    errorMessage = "This transaction may be suspicious. If this transaction is genuine, please contact PayTabs customer service to enquire about the feasibility of processing this transaction."
                    break
                default:
                    errorMessage = "Something went wrong."
                }
                
                if errorMessage != "" {
                    let alert = UIAlertController(title: AppName, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    weakSelf?.present(alert, animated: true, completion: nil)
                }
            }
            weakSelf?.handleBackButtonTapEvent()
        }
        self.view.addSubview(self.initialSetupViewController.view)
        self.addChildViewController(self.initialSetupViewController)
    }
    
    
    private func handleBackButtonTapEvent() {
        self.initialSetupViewController.willMove(toParentViewController: self)
        self.initialSetupViewController.view.removeFromSuperview()
        self.initialSetupViewController.removeFromParentViewController()
    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
}

extension CashOnDeleveryVC{
    
//    {
//    "method":"get_all_details_using_order_id",
//    "app_key":"123456",
//    "order_id":"7"
//    }
    // 13.126.99.14/gogreen/index.php/car_packages
    
    
    
    func hitServiceForCarPackages(for OrderId: String)
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"get_all_details_using_order_id",
                     "app_key":"123456",
                     "order_id": OrderId] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: car_packages, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    print(dict1)
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            self.datapasstoService.removeAll()
                            
                            
                            if let carData = dict1["result"] as? [[String : Any]]{
                                let date = Date()
                                let formatter = DateFormatter()
                                formatter.dateFormat = "yyyy-MM-dd"
                                let datestr = formatter.string(from: date)
                                for car in carData{
                                    let arrayofDict = ["car_id": car["car_id"], "package_type": car["package_type"] , "purchase_date": datestr , "services": car["services"] , "frequency":  car["frequency"] , "amount": car["amount"]  ,  "days" : car["days"], "coupan_applied" : "","one_time_service_date":"", "package_name" : car["package_name"]] as [String : AnyObject]
                                print(arrayofDict)
                                self.datapasstoService.append(arrayofDict)
                                }
                            }
//                            self.selecteddataarr.removeAll()
//                            self.Carlistarr.removeAll()
//                            self.Bookacatatbleview.reloadData()
//                            self.HitserviceForcarlist()
//
                        } else
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
