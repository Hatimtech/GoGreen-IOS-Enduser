//
//  OrderConfirmationVC.swift
//  GoGreen
//
//  Created by Sonu on 03/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import IQKeyboardManagerSwift
import FacebookCore


class OrderConfirmationVC: UIViewController , coupencodedelegate
{
   
    
     @IBOutlet var Ordertableview : UITableView!
     @IBOutlet var topview : UIView!
     @IBOutlet var totalamountlbl : UILabel!
    
    @IBOutlet weak var heighhavecoupen: NSLayoutConstraint!
    @IBOutlet weak var heightadcoupenvm: NSLayoutConstraint!

     @IBOutlet var packageonviewlbl : UILabel!
     @IBOutlet var coupenlbl : UILabel!
     @IBOutlet var discountlbl : UILabel!
    
    
    
     var carreceivedata_arr = [CarData]()
     var totalamount : Int = 0
     var datapasstoService : [Dictionary<String,AnyObject>] = []
     var trasactionid = ""
     var expandedCells = [Int]()
     var discount : Int = 0
    var initialSetupViewController: PTFWInitialSetupViewController!
    
    var coupenpopview = CoupenView()
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        self.Ordertableview.rowHeight = 210
        print(carreceivedata_arr)
        print(GoGreenManeger.instance.selectedcity)
        print(GoGreenManeger.instance.selectedlocalityname)
        print(GoGreenManeger.instance.selectstreet)
        dataappendbyarray()
        heightadcoupenvm.constant = 0
        self.Ordertableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.Ordertableview.reloadData ()
    }
    
    
    
    
    @IBAction func taptocounpenbtn(sender : UIButton)
    {
        // self.entercoupencode()
        var Array: [Any] = Bundle.main.loadNibNamed("Coupenview", owner: self, options: nil)!
        self.coupenpopview = Array[0] as! CoupenView
        self.coupenpopview.Delegate = self
        self.coupenpopview.frame = CGRect(x: 0, y: 0, width:self.view.frame.size.width, height: self.view.frame.size.height)
        self.view.addSubview(self.coupenpopview)
    }
    
    func feedback(coupencodestr: String)
    {
        print(coupencodestr)
        HitserviceForValidCoupen(Coupencode : coupencodestr)
    }
   
    
    @IBAction func taptoproceedbtn(sender : UIButton)
    {
        let CashOnDeleveryVC = self.storyboard?.instantiateViewController(withIdentifier: "CashOnDeleveryVC") as! CashOnDeleveryVC
        CashOnDeleveryVC.carreceivedata_arr = self.carreceivedata_arr
        CashOnDeleveryVC.discount = self.discount
        CashOnDeleveryVC.isPushNoficationSelected = false
        self.logInitiateCheckoutEvent(contentData: "Go Green Car wash", contentId: "GOGREEN-5544", contentType: "product", numItems: 1, paymentInfoAvailable: false, currency: "AED", totalPrice: 10.34)
        self.navigationController?.pushViewController(CashOnDeleveryVC, animated: true)
        //paytabsCall()
    }
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logInitiateCheckoutEvent(contentData : String, contentId : String, contentType : String, numItems : Int, paymentInfoAvailable : Bool, currency : String, totalPrice : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .itemCount : NSNumber(value:numItems),
            .paymentInfoAvailable : NSNumber(value: paymentInfoAvailable ? 1 : 0),
            .currency : currency
        ]
        let event = AppEvent(name: .initiatedCheckout, parameters: params, valueToSum: totalPrice)
        AppEventsLogger.log(event)
    }
    
    
//    func paytabsCall()
//    {
//        IQKeyboardManager.sharedManager().enable = false
//        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
//        let emailstr = result["email"]!
//        print(emailstr)
//        var view:PayTabCardReaderViewController!
//        if(UIDevice.current.userInterfaceIdiom == .pad)
//        {
//            view = PayTabCardReaderViewController.init(nibName: "PayTabCardReaderViewControllerWideScreen", bundle: nil)
//        }
//        else {
//            view = PayTabCardReaderViewController.init(nibName: "PayTabCardReaderViewController_iPhone", bundle: nil)
//        }
//        print(String(totalamount))
//        print(GoGreenManeger.instance.selectedlocalityname)
//        print(GoGreenManeger.instance.selectedcity)
//        print(GoGreenManeger.instance.selectstreet)
//
//
//
//        view.tag_amount = String(totalamount); // hamari gin@
//        view.tag_title = "Product1"; // hotel i anun@
//        view.tag_currency = "USD"
//        //"OMR"; // currency - n
//        view.sdklanguage = "en";
//        view.tag_tax = "0.0";
//        view.shipping_address = GoGreenManeger.instance.selectedlocalityname
//        //"Flat 1,Building 123, Road 2345";
//        print(view.shipping_address)
//        view.shipping_city = GoGreenManeger.instance.selectedlocalityname
//        //"Juffair
//        view.shiping_country = "AED";
//        print(view.shiping_country)
//        view.shipping_state = GoGreenManeger.instance.selectedcity
//        //"Manama";
//        view.shipping_zip_code = "00973";
//        view.billing_address = GoGreenManeger.instance.selectedlocalityname
//        //"Flat 11 Building 22 Block 333 Road 444Manama Bahrain";
//        view.billing_city = GoGreenManeger.instance.selectedlocalityname
//        //"Manama";
//        view.billing_country = "BHR";
//        view.billing_state = "Manama";
//        view.billing_zip_code = "00973";
//
//        view.order_id = "1234567";
//        view.phonenum = "0097300001";
//        view.customer_email = emailstr;
//        view.tag_merchant_email = "iossonu019@gmail.com";
//        view.timerFlag =  300;//seconds
//
//        view.secretKey = "fakQao2YINLEPx5d9TQsMheNYXsDBp5QzqGKOJJxxubm2hzcaqEXITLGQdjrDpicPZXEIGbgbnDdEcqPD4MlXx1NLlfoKxBAxzeg";
//        view.tag_original_assignee_code = "SDK"; // booking id - n
//        self.present(view, animated: true, completion: nil)
//
//    }
    
//    func paytabsCall()
//    {
//        //IQKeyboardManager.sharedManager().enable = false
//        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
//        let emailstr = result["email"]!
//        let user_Name = result["name"]!
//        let user_Phone = result["phone_number"]!
//
//        var email = ""
//        var secretKey = ""
//        let payment_type_val = UserDefaults.standard.object(forKey: "payment_type") as! String
//        if payment_type_val == "1"
//        {
//            //By Karan
//            email = "karan@ripenapps.com"
//            secretKey = "nCqyPKUQExNhDKiQqZpRF4Bp9dNFH875KyEzizqX7eeKYxBpw1gc5SCe5pUNx1TizxSS7iPew4ZvCAV8BbkH4WWamQYUSRcrp4kw"
//        }
//        else
//        {
//            //By Karan
//            email = "abhishek@ripenapps.com";
//            secretKey = "PqoVISuqaN6DXhiWB7oV4cgSpJvII2tytRubKZCUMJxJ1PFCX4y1hOUGxpogsSOVJi7tiKo4tVOuLt7IyFKQtEw14VhwN6sxpA0H";
//        }
//
//
//        email = "akashshukla.sln@gmail.com"
//        secretKey = "pIHBPORX6VyM6p4prWdcTfSUDI88LAnbj5N9TE6ZAEMG4R5vOjIHyABcjJk5kIhDN4MGJSGkxt0Ck678pQQXrs9KcuPwc7aZcWFV"
//         let orderID = String(Int((Date().timeIntervalSince1970 * 1000.0).rounded()))
//
//        let bundle = Bundle(url: Bundle.main.url(forResource: ApplicationResources.kFrameworkResourcesBundle, withExtension: "bundle")!)
//        self.initialSetupViewController = PTFWInitialSetupViewController(nibName: ApplicationXIBs.kPTFWInitialSetupView,
//                                                  bundle: bundle,
//                                                  andWithViewFrame: self.view.frame,
//                                                  andWithAmount: Float(totalamount),
//                                                  andWithCustomerTitle: user_Name,
//                                                  andWithCurrencyCode: "AED",
//                                                  andWithTaxAmount: 0.0,
//                                                  andWithSDKLanguage: "en",
//                                                  andWithShippingAddress: GoGreenManeger.instance.selectedlocalityname,
//                                                  andWithShippingCity: GoGreenManeger.instance.selectedlocalityname,
//                                                  andWithShippingCountry: "ARE",
//                                                  andWithShippingState: GoGreenManeger.instance.selectedlocalityname,
//                                                  andWithShippingZIPCode: "00973",
//                                                  andWithBillingAddress: GoGreenManeger.instance.selectedlocalityname,
//                                                  andWithBillingCity: GoGreenManeger.instance.selectedlocalityname,
//                                                  andWithBillingCountry: "ARE",
//                                                  andWithBillingState: "Manama",
//                                                  andWithBillingZIPCode: "00971",
//                                                  andWithOrderID: orderID,
//                                                  andWithPhoneNumber: user_Phone,
//                                                  andWithCustomerEmail: emailstr,
//                                                  andIsTokenization: false,
//                                                  andWithMerchantEmail: email,
//                                                  andWithMerchantSecretKey: secretKey,
//                                                  andWithAssigneeCode: "SDK",
//                                                  andWithThemeColor: UIColor.green,
//                                                  andIsThemeColorLight: true)
//
//
//        weak var weakSelf = self
//        self.initialSetupViewController.didReceiveBackButtonCallback = {
//            weakSelf?.handleBackButtonTapEvent()
//        }
//
//        self.initialSetupViewController.didReceiveFinishTransactionCallback = {(responseCode, result, transactionID, tokenizedCustomerEmail, tokenizedCustomerPassword, token, transactionState) in
//
//            if responseCode == 100 {
//                weakSelf?.trasactionid = String(transactionID)
//                weakSelf?.HitserviceForPaymentgateway(transactionid : weakSelf!.trasactionid, Cardata: weakSelf!.datapasstoService)
//            }else{
//
//                var errorMessage = ""
//                switch responseCode {
//                case 4001:
//                    errorMessage = "Missing parameters"
//                    break
//
//                case 4002:
//                    errorMessage = "Invalid Credentials"
//                    break
//                case 0404:
//                    errorMessage = "You don’t have permissions"
//                    break
//                case 4015:
//                    errorMessage = "Invalid tokenization Credentials"
//                    break
//                case 4091:
//                    errorMessage = "There are no transactions available."
//                    break
//                case 481,482:
//                    errorMessage = "This transaction may be suspicious. If this transaction is genuine, please contact PayTabs customer service to enquire about the feasibility of processing this transaction."
//                    break
//
//
//                default:
//                    errorMessage = "Something went wrong."
//                }
//
//                if errorMessage != "" {
//                    let alert = UIAlertController(title: AppName, message: errorMessage, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    weakSelf?.present(alert, animated: true, completion: nil)
//                }
//            }
//
//            weakSelf?.handleBackButtonTapEvent()
//        }
//
////        print(emailstr)
//////        var view:PayTabCardReaderViewController!
////       // var view:PTFWInitialSetupViewController =  PTFWInitialSetupViewController()
//////        if(UIDevice.current.userInterfaceIdiom == .pad)
//////        {
////            view = PTFWInitialSetupViewController(nibName: "Main", bundle: bundle, andWithViewFrame: self.view.frame, andWithAmount: Float(totalamount), andWithCustomerTitle: "Product1", andWithCurrencyCode: "AED", andWithTaxAmount: 0.0, andWithSDKLanguage: "en", andWithShippingAddress: GoGreenManeger.instance.selectedlocalityname, andWithShippingCity: GoGreenManeger.instance.selectedlocalityname, andWithShippingCountry: "AED", andWithShippingState: GoGreenManeger.instance.selectedcity, andWithShippingZIPCode: "00973", andWithBillingAddress: GoGreenManeger.instance.selectedlocalityname, andWithBillingCity: GoGreenManeger.instance.selectedlocalityname, andWithBillingCountry: "BHR", andWithBillingState: "Manama", andWithBillingZIPCode: "00973", andWithOrderID: "1234567", andWithPhoneNumber: "0097300001", andWithCustomerEmail: emailstr, andIsTokenization: false, andWithMerchantEmail: "akashshukla.sln@gmail.com", andWithMerchantSecretKey: "pIHBPORX6VyM6p4prWdcTfSUDI88LAnbj5N9TE6ZAEMG4R5vOjIHyABcjJk5kIhDN4MGJSGkxt0Ck678pQQXrs9KcuPwc7aZcWFV", andWithAssigneeCode: "SDK", andWithThemeColor: UIColor.blue, andIsThemeColorLight: false)
////        PayTabCardReaderViewController.init(nibName: "PayTabCardReaderViewControllerWideScreen", bundle: nil)
////        }
////        else {
////            view = PayTabCardReaderViewController.init(nibName: "PayTabCardReaderViewController_iPhone", bundle: nil)
////        }
////        print(String(totalamFount))
////        print(GoGreenManeger.instance.selectedlocalityname)
////        print(GoGreenManeger.instance.selectedcity)
////        print(GoGreenManeger.instance.selectstreet)
////
////        view.tag_amount = String(totalamount); // hamari gin@
////        view.tag_title = "Product1"; // hotel i anun@
////        view.tag_currency = "AED"
////        view.sdklanguage = "en";
////        view.tag_tax = "0.0";
////        view.shipping_address = GoGreenManeger.instance.selectedlocalityname
////        view.shipping_city = GoGreenManeger.instance.selectedlocalityname
////        view.shiping_country = "AED";
////        view.shipping_state = GoGreenManeger.instance.selectedcity
////        view.shipping_zip_code = "00973";
////        view.billing_address = GoGreenManeger.instance.selectedlocalityname
////        view.billing_city = GoGreenManeger.instance.selectedlocalityname
////        view.billing_country = "BHR";
////        view.billing_state = "Manama";
////        view.billing_zip_code = "00973";
////        view.order_id = "1234567";
////        view.phonenum = "0097300001";
////        view.customer_email = emailstr;
////        view.timerFlag =  300;//seconds
////
////        let payment_type_val = UserDefaults.standard.object(forKey: "payment_type") as! String
////        if payment_type_val == "1"
////        {
////            view.tag_merchant_email = "karan@ripenapps.com"
////            view.secretKey = "nCqyPKUQExNhDKiQqZpRF4Bp9dNFH875KyEzizqX7eeKYxBpw1gc5SCe5pUNx1TizxSS7iPew4ZvCAV8BbkH4WWamQYUSRcrp4kw"
////        }
////        else
////        {
////            view.tag_merchant_email = "abhishek@ripenapps.com";
////            view.secretKey = "PqoVISuqaN6DXhiWB7oV4cgSpJvII2tytRubKZCUMJxJ1PFCX4y1hOUGxpogsSOVJi7tiKo4tVOuLt7IyFKQtEw14VhwN6sxpA0H";
////        }
////
////        view.tag_original_assignee_code = "SDK"; // booking id - n
//        //self.present(view, animated: true, completion: nil)
////        self.view.addSubview(view.view)
////        self.addChildViewController(view)
//
//    }
    
   
    private func handleBackButtonTapEvent() {
        self.initialSetupViewController.willMove(toParentViewController: self)
        self.initialSetupViewController.view.removeFromSuperview()
        self.initialSetupViewController.removeFromParentViewController()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        self.Ordertableview.reloadData()
        IQKeyboardManager.sharedManager().enable = true
//        checkPaymentStatus()
    }
    
    
    @IBAction func taptocrossbtn(sender : UIButton)
    {
        self.heightadcoupenvm.constant = 0
        self.heighhavecoupen.constant = 50
        self.totalamount = self.discount + self.totalamount
        self.totalamountlbl.text = String(totalamount)
    }
    
    
    
//    func entercoupencode()
//    {
//
//        let alert = UIAlertController(title: AppName, message: "Please Enter Coupen Code", preferredStyle: .alert)
//        //2. Add the text field. You can configure it however you need.
//            alert.addTextField { (textField) in
//            //textField.text = "Some default text"
//            let attributes = [
//                NSAttributedStringKey.foregroundColor: UIColor(red: 35 / 255.0, green: 31 / 255.0, blue: 32 / 255.0, alpha: 1.0),
//                NSAttributedStringKey.font : UIFont(name:"Montserrat-Light", size: 14)! // Note the !
//            ]
//            textField.attributedPlaceholder = NSAttributedString(string: "Enter Your Coupen", attributes:attributes)
//        }
//
//        // 3. Grab the value from the text field, and print it when the user clicks OK.
//        alert.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak alert] (_) in
//            let textField = alert?.textFields![0]
//            textField?.text = textField?.text?.uppercased()
//            if (textField?.text?.isEmpty)!
//            {
//                self.emptycounpentextf()
//                return
//
//            }else
//            {
//                self.HitserviceForValidCoupen(Coupencode : (textField?.text?.removingWhitespaces())!)
//            }
//                print("Text field: \(textField?.text)")
//        }))
//
//        // 4. Present the alert.
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
//    func emptycounpentextf()
//    {
//        let alert = UIAlertController(title: AppName, message: "Please Enter Counpen Number", preferredStyle: UIAlertControllerStyle.alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
//    }
    
    
   
    
    
    func HitserviceForValidCoupen(Coupencode : String)
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"is_valid_coupan",
                     "app_key":"123456",
                     "coupan_code": Coupencode,
                     "user_id":user_id,
                     "amount": self.totalamount] as [String : Any]
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
                            self.heightadcoupenvm.constant = 100
                            self.heighhavecoupen.constant = 0
                            if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
                            {
                                if let discount = result[0]["discount"] as? String
                                {
                                    self.packageonviewlbl.text = String(self.totalamount)
                                    let percentdata = Int(discount)! * self.totalamount / 100
                                    self.discountlbl.text = String(percentdata)
                                    self.discount = percentdata
                                    self.totalamount = self.totalamount - percentdata
                                    self.totalamountlbl.text = String(self.totalamount)
                                }
                                if let coupan_name = result[0]["coupan_code"] as? String
                                {
                                     self.coupenlbl.text = "Coupon Applied :\((String(coupan_name)))"
                                }
                            }
                                                     
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
    
    
    
    
    
    
    
    
    func dataappendbyarray()
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
            
            let arrayofDict = ["car_id": dic.carid , "package_type": ismonthly , "purchase_date": Datestr , "services": services , "frequency": frequency , "amount": caramount ,  "days" : appenddays, "coupan_applied" :" 0"  ,"one_time_service_date":dic.date] as [String : AnyObject]
            print(arrayofDict)
            self.datapasstoService.append(arrayofDict)
            
        }
         UserDefaults.standard.set(self.totalamount, forKey: "totalamount")
         UserDefaults.standard.set(self.datapasstoService, forKey: "Cardata")
        
    }
    
    
    
    func checkPaymentStatus()
    {
        if UserDefaults.standard.value(forKey: "pt_response_code") as? String ?? "0" == "0"
        {
           //fail

           
        }
        else
        {
            // Payment Success
            let responseCode = UserDefaults.standard.value(forKey: "pt_response_code") as! String
            if let transactionId = UserDefaults.standard.value(forKey: "pt_transaction_id")
            {
                self.trasactionid = transactionId as! String
                self.HitserviceForPaymentgateway(transactionid : self.trasactionid, Cardata: self.datapasstoService)
            }
        }
        
    }
    
    
    
    
    
    
    func HitserviceForPaymentgateway(transactionid : String,Cardata: [Dictionary<String,AnyObject>])
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"insert_booked_services",
                     "app_key":"123456",
                     "user_id":user_id,
                     "transaction_id": transactionid,
                     "net_paid":self.totalamount,
                    "cars": self.datapasstoService,
                    "payment_type":"2",
                    "city_id" :GoGreenManeger.instance.Cityid,
                    "locality_id" : GoGreenManeger.instance.LocalityId,
                    "street_id" : GoGreenManeger.instance.Streetid

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
                            GoGreenManeger.instance.SetSlidemenuhome()

                            let alert = UIAlertController(title: AppName, message: "You have successfully purchased service.", preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                            self.present(alert, animated: true, completion: nil)

                            
                            self.totalamount = 0
                            UserDefaults.standard.removeObject(forKey: "pt_response_code")
                            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
                            var result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,String>
                            result["is_payment"] = "2"
                            UserDefaults.standard.set(result, forKey: "logindict_info")
                            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")

                        }
                        else
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
            else
            {
                
            }
        }
    }
    
    @IBAction func buttonPressed(_ sender: AnyObject)
    {
        // If the array contains the button that was pressed, then remove that button from the array
        if expandedCells.contains(sender.tag)
        {
            expandedCells = expandedCells.filter({ $0 != sender.tag})
        }
            // Otherwise, add the button to the array
        else {
            expandedCells.append(sender.tag)
        }
        // Reload the tableView data anytime a button is pressed
        self.Ordertableview.reloadData()
    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
        //self.slideMenuController()?.openLeft()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
}


extension OrderConfirmationVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return carreceivedata_arr.count
    }
    
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "BookCarCell", for: indexPath)
        let carmodellbl : UILabel = cell.viewWithTag(101) as! UILabel
        let colourlbl : UILabel = cell.viewWithTag(100) as! UILabel
        let interioelbl : UILabel = cell.viewWithTag(102) as! UILabel
        let cartype: UILabel = cell.viewWithTag(103) as! UILabel
        let Selecteddaylbl : UILabel = cell.viewWithTag(105) as! UILabel
        let cartypeimg : UIImageView = cell.viewWithTag(203) as! UIImageView
        let Calenderimg : UIImageView = cell.viewWithTag(204) as! UIImageView
        let Ratelbl: UILabel = cell.viewWithTag(125) as! UILabel
        let viewmorelbl : UILabel = cell.viewWithTag(123) as! UILabel
        //one_time_service_date
        if expandedCells.contains(indexPath.row)
        {
           viewmorelbl.text = "View less"
            cartypeimg.isHidden = false
            cartype.isHidden = false
        }
        else
        {
           
            viewmorelbl.text = "View More"
            cartypeimg.isHidden = true
            cartype.isHidden = true
        }
        
        if carreceivedata_arr[indexPath.row].isinterior && carreceivedata_arr[indexPath.row].isexterior
        {
            interioelbl.text = "Interior & Exterior"
            
        }else if carreceivedata_arr[indexPath.row].isinterior
        {
           interioelbl.text = "Interior"
        }else
        {
            interioelbl.text = "Exterior"
        }
        colourlbl.text = carreceivedata_arr[indexPath.row].carcolor
        cartype.text = carreceivedata_arr[indexPath.row].cartype
        Ratelbl.text = "AED" + " "+String(carreceivedata_arr[indexPath.row].caramount)
        self.totalamountlbl.text = "AED " + String(self.totalamount)
        if carreceivedata_arr[indexPath.row].cartype == "Saloon"
        {
            cartypeimg.image = #imageLiteral(resourceName: "small_saloon_image")
        }else
        {
            cartypeimg.image = #imageLiteral(resourceName: "small_suv_image")
        }
        
        var carbrand = ""
        carbrand = carreceivedata_arr[indexPath.row].car_brand
        carbrand += " " + carreceivedata_arr[indexPath.row].carmodel
        carmodellbl.text = carbrand
        if carreceivedata_arr[indexPath.row].isonetime
        {
           Selecteddaylbl.text = carreceivedata_arr[indexPath.row].date
           //Calenderimg.isHidden = true
        }else
        {
            var appendvalues = ""
            for dic in carreceivedata_arr[indexPath.row].selecteddayarr
            {
                appendvalues += " " + dic
            }
            
            Selecteddaylbl.text = appendvalues
        }
        
        let mainBackground = cell.viewWithTag(104) as! UIView
        mainBackground.layer.cornerRadius = 8
        mainBackground.layer.masksToBounds = true
        mainBackground.layer.masksToBounds = false
        mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
        mainBackground.layer.shadowColor = UIColor.black.cgColor
        mainBackground.layer.shadowOpacity = 0.23
        mainBackground.layer.shadowRadius = 4
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if expandedCells.contains(indexPath.row)
        {
            return 210
            
        } else {
            
            return 122
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
        // If the array contains the button that was pressed, then remove that button from the array
        if expandedCells.contains(indexPath.row)
        {
            expandedCells = expandedCells.filter({ $0 != indexPath.row})
        }
            // Otherwise, add the button to the array
        else {
            
            expandedCells.append(indexPath.row)
        }
        
        self.Ordertableview.reloadData()
        // Reload the tableView data anytime a button is pressed
        
    }
}
