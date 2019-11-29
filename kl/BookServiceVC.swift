//
//  BookServiceVC.swift
//  GoGreen
//
//  Created by Sonu on 03/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import DropDown
import AlamofireImage
import Alamofire
import MBProgressHUD
import IQKeyboardManagerSwift
import FacebookCore

class BookServiceVC: UIViewController , changefrquencyindexdelegate
{
        @IBOutlet var topview : UIView!
        @IBOutlet var upperview : UIView!
        @IBOutlet var upperinnnerview : UIView!
//        @IBOutlet var selectpackageview : UIView!
//        @IBOutlet var selectpackageinnerview : UIView!
        @IBOutlet var selectpackagevtypeview : UIView!
        @IBOutlet var selectpackagevtypeinnerview : UIView!
        @IBOutlet var Bookserviectableview : UITableView!
        @IBOutlet weak var onetimebottomview: UIView!
        @IBOutlet weak var headerview: UIView!
        @IBOutlet weak var monthlybottomview: UIView!
        @IBOutlet weak var monthlybtn: UIButton!
        @IBOutlet weak var onetimebtn: UIButton!
        @IBOutlet weak var Brandlbl: UILabel!
        @IBOutlet weak var Modellbl: UILabel!
        @IBOutlet weak var interiorbtn: UIButton!
        @IBOutlet weak var exteriorbtn: UIButton!
        //@IBOutlet weak var moneylbl: UILabel!
        //@IBOutlet weak var timelbl: UILabel!

    
    //var ismonthlycell = false
    let picker = UIDatePicker()
    //var datestr = ""
    var dayarr = ["Sun" , "Mon" , "Tue" , "Wed" , "Thu"  , "Sat"]
    var selecteddayarr = [String]()
    //var frequencyindex = 1
    var receivedataarr : [Dictionary<String,AnyObject>] = []
    var brandandmodeldropdown = DropDown()
    var packegeMonthDropDown = DropDown()
    
    var dropdownarr : [String] = []
    //var isagree : Bool = false
    var dropdowncarindexarr : [String] = []
   // var isalreadyappend : Bool = false
    var cardata_array = [CarData]()
    var packagedata_array = [Packageselect]()
   
    var totalmoney = ""
//    var paytab = PayTabCardReaderViewController()
    var monthlyPercentageData = [String : String]()
    var selectedmonthIndex = 0
    var months = ["Monthly", "2 Month", "3 Month", "4 Month", "5 Month", "6 Month", "7 Month", "8 Month", "9 Month", "10 Month", "11 Month", "12 Month"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setPackegeMonthSelectionDropdown()
        //self.moneylbl.text = ""
        //self.Bookserviectableview.rowHeight = 300
        self.Bookserviectableview.reloadData()
        SetupUI()
        for Dic in receivedataarr
        {
            let car_data_obj = CarData()
            car_data_obj.carid = Dic["id"]! as! String
            car_data_obj.carmodel = Dic["model"]! as! String
            car_data_obj.car_brand = Dic["brand"]! as! String
            car_data_obj.cartype = Dic["type"]! as! String 
            car_data_obj.carcolor = Dic["color"]! as! String
            car_data_obj.car_plate_number = Dic["reg_no"]! as! String
            cardata_array.append(car_data_obj)
            brandandmodeldropdown.dataSource.append(car_data_obj.car_brand + "," + car_data_obj.carmodel + " " + car_data_obj.car_plate_number)
            picker.maximumDate = (Calendar.current as NSCalendar).date(byAdding: .day, value: 60, to: Date(), options: [])!
        }
        for _ in 0..<receivedataarr.count
        {
            self.packagedata_array.append(Packageselect())
        }

        brandandmodeldropdown.selectRow(0)
        brandandmodeldropdown.anchorView = upperview //colur
        brandandmodeldropdown.direction = .bottom
        self.Brandlbl.text = "\(self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].car_brand) \(self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].carmodel)"
        self.Modellbl.text = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].car_plate_number
        self.servicefrogetpackage(index: brandandmodeldropdown.indexForSelectedRow!)
 
    }
    
  
    
//    override func viewWillAppear(_ animated: Bool)
//    {
//         IQKeyboardManager.sharedManager().enable = true
//    }
    
    override func viewDidLayoutSubviews()
    {
        super.viewDidLayoutSubviews()
        //self.Bookserviectableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -80, right: 0)
    }
   

    func setPackegeMonthSelectionDropdown(){
        packegeMonthDropDown.dataSource = months
        packegeMonthDropDown.selectRow(0)
        packegeMonthDropDown.anchorView = monthlybtn
        packegeMonthDropDown.direction = .bottom
    }

    
    func SetupUI()
    {
        //first view
        self.upperview.layer.shadowColor = UIColor.lightGray.cgColor
        self.upperview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.upperview.layer.shadowOpacity = 0.3
        self.upperview.layer.shadowRadius = 10
        self.upperinnnerview.layer.cornerRadius = 10.0
        self.upperinnnerview.layer.masksToBounds = true
        
        // selected package view
//        self.selectpackageview.layer.shadowColor = UIColor.lightGray.cgColor
//        self.selectpackageview.layer.shadowOffset = CGSize(width: -1, height: 1)
//        self.selectpackageview.layer.shadowOpacity = 0.3
//        self.selectpackageview.layer.shadowRadius = 10
//        self.selectpackageinnerview.layer.cornerRadius = 10.0
//        self.selectpackageinnerview.layer.masksToBounds = true
        
        // selected package type view
        self.selectpackagevtypeview.layer.shadowColor = UIColor.lightGray.cgColor
        self.selectpackagevtypeview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.selectpackagevtypeview.layer.shadowOpacity = 0.3
        self.selectpackagevtypeview.layer.shadowRadius = 10
        self.selectpackagevtypeinnerview.layer.cornerRadius = 10.0
        self.selectpackagevtypeinnerview.layer.masksToBounds = true
        
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        
        // one time and monthly segment
        self.monthlybtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
        self.onetimebtn.setTitleColor(UIColor.black, for: .normal)
        self.onetimebottomview.backgroundColor = UIColor.clear
        self.monthlybottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
        self.exteriorbtn.isSelected = true
        self.exteriorbtn.isUserInteractionEnabled = false
       
    }

    func tableviewreloaddata()
    {
        let contentOffset = self.Bookserviectableview.contentOffset
        self.Bookserviectableview.reloadData()
        self.Bookserviectableview.layoutIfNeeded()
        self.Bookserviectableview.setContentOffset(contentOffset, animated: false)
    }
    
   
    func changefrqquencyindex(index: Int)
    {
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex =  index
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].selecteddayarr.removeAll()
        self.calculateprice()
        self.tableviewreloaddata()
    }
    
    @objc func taptonextbtn()
    {
        var strmsg = ""
        let carmodelname = ""
        var carname = ""
        if (brandandmodeldropdown.indexForSelectedRow == self.cardata_array.count - 1)
        {
            for car_data in cardata_array
            {
                if(carname != "")
                {
                    carname = carname + "\n"
                }
                if (!car_data.isinterior && !car_data.isexterior)
                {
                    carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                    continue
                }
                if(!car_data.isagree || car_data.caramount == 0)
                {
                    carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                    continue
                }
                
                if (car_data.isonetime)
                {
                    if(car_data.date == "")
                    {
                        carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                        continue
                    }
                }
                else
                {
                    switch car_data.frequencyindex
                    {
                        case 0 :
                            if car_data.selecteddayarr.count < 1
                            {
                                carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                            }
                        continue;
                    case 1 :
                        if car_data.selecteddayarr.count < 3
                        {
                            carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                        }
                        continue;
                    case 2 :
                        if car_data.selecteddayarr.count < 5
                        {
                            carname = carname + "\(car_data.car_brand).\(car_data.carmodel)"
                        }
                        continue;
                    default:
                        continue;
                    }
                }
                
                
            }
            
            
            
            if (carname == "")
            {
                self.logConfirmCarPackageEvent(confirm_Car_Package: "Confirm_Car_Package")
                self.logAddToCartEvent(contentData: "Go Green Car wash", contentId: "GOGREEN-5544", contentType: "product", currency: "AED", price: 10.34)
                let OrderConfirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationVC
                OrderConfirmationVC.carreceivedata_arr = cardata_array
                UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
                self.navigationController?.pushViewController(OrderConfirmationVC, animated: true)
            }
            else
            {
                let alert = UIAlertController(title: AppName, message: "The Following cars have incomplete details. Please Provide complete details for all your cars to continue. \n\n \(carname)", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            self.brandandmodeldropdown.selectRow(self.brandandmodeldropdown.indexForSelectedRow! + 1)
            if(self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].isinserted == false)
            {
                self.servicefrogetpackage(index: self.brandandmodeldropdown.indexForSelectedRow!)
            }
            else
            {
                let currentcar_obj = self.cardata_array[self.brandandmodeldropdown.indexForSelectedRow!]
                
                self.Brandlbl.text = "\(currentcar_obj.car_brand) \(currentcar_obj.carmodel)"
                self.Modellbl.text = currentcar_obj.car_plate_number
//                self.Modellbl.text = currentcar_obj.carmodel
//                self.Brandlbl.text = currentcar_obj.car_brand
                self.interiorbtn.isSelected = currentcar_obj.isinterior
                self.exteriorbtn.isSelected = currentcar_obj.isexterior
                self.calculateprice()
                if (currentcar_obj.isonetime)
                {
                    self.onetimebtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                    self.monthlybtn.setTitleColor(UIColor.black, for: .normal)
                    self.monthlybottomview.backgroundColor = UIColor.clear
                    self.onetimebottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                }
                else
                {
                    self.onetimebtn.setTitleColor(UIColor.black, for: .normal)
                    self.monthlybtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                    self.monthlybottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                    self.onetimebottomview.backgroundColor = UIColor.clear
                    self.monthlybtn.setTitle(currentcar_obj.seletedMonths, for: .normal)
                   
                }
                self.tableviewreloaddata()
            }

           // self.brandandmodeldropdown.show()
//            self.brandandmodeldropdown.selectionAction = { [unowned self] (index, item) in
//
//            }
        }
        
        
        /**
         * For more details, please take a look at:
         * developers.facebook.com/docs/swift/appevents
         */
       

        
//        for car_data in cardata_array
//        {
//            if (!car_data.isinterior && !car_data.isexterior)
//            {
//                strmsg = "Please select atleast one in interior or exterior"
//                break;
//            }
//            if (car_data.isonetime)
//            {
//                if(car_data.date == "")
//                {
//                    strmsg = "Please fill date"
//                    let alert = UIAlertController(title: AppName, message: strmsg + " in car model " + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                    break;
////                    let alert = UIAlertController(title: AppName, message: strmsg + " in car model " + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
////                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
////                    self.present(alert, animated: true, completion: nil)
//                    //return
//                }
//            }
//            else
//            {
//            switch car_data.frequencyindex
//            {
//                case 0 :
//                    if car_data.selecteddayarr.count < 1
//                    {
//                        strmsg = "please select day"
//                        let alert = UIAlertController(title: AppName, message: strmsg + " in car model " + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        return;
//                    }
//                    break;
//                case 1 :
//                    if car_data.selecteddayarr.count < 3
//                    {
//                        strmsg = "please select day"
//                        let alert = UIAlertController(title: AppName, message: strmsg + " in car model " + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        return;
//                    }
//                break;
//                case 2 :
//                    if car_data.selecteddayarr.count < 5
//                    {
//                        strmsg = "please select day"
//                        let alert = UIAlertController(title: AppName, message: strmsg + " in car model " + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                        self.present(alert, animated: true, completion: nil)
//                        return;
//
//                    }
//                    break;
//                default:
//                    break;
//            }
//
//        }
//            if(!car_data.isagree)
//            {
//               strmsg = "please select Term & Condition "
//               let alert = UIAlertController(title: AppName, message: strmsg + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//               alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//               self.present(alert, animated: true, completion: nil)
//               return
//            }
//
//            if car_data.caramount == 0
//            {
//               //popupalertpackage()
//                strmsg = "Package Doesn't Exit "
//                let alert = UIAlertController(title: AppName, message: strmsg + "In Car Model" + car_data.car_brand, preferredStyle: UIAlertControllerStyle.alert)
//                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                self.present(alert, animated: true, completion: nil)
//            }
//    }
     
        
//        if strmsg != ""
//        {
//            //alert
//            let alert = UIAlertController(title: AppName, message: strmsg + "In Car Model" + carmodelname, preferredStyle: UIAlertControllerStyle.alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//            self.present(alert, animated: true, completion: nil)
//        }else
//        {
//             //self.paytabsCall()
//            let OrderConfirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationVC
//            OrderConfirmationVC.carreceivedata_arr = cardata_array
//            UserDefaults.standard.removeObject(forKey: "pt_transaction_id")
//            self.navigationController?.pushViewController(OrderConfirmationVC, animated: true)
//
//        }
    }
    
    
    /**
     * For more details, please take a look at:
     * developers.facebook.com/docs/swift/appevents
     */
    func logAddToCartEvent(contentData : String, contentId : String, contentType : String, currency : String, price : Double) {
        let params : AppEvent.ParametersDictionary = [
            .content : contentData,
            .contentId : contentId,
            .contentType : contentType,
            .currency : currency
        ]
        let event = AppEvent(name: .addedToCart, parameters: params, valueToSum: price)
        AppEventsLogger.log(event)
    }
    
   
    
    func calculateprice()
    {
        var Calculationonprice : Int = 0
        if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isonetime == true
        {
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior == true
            {
                Calculationonprice = Calculationonprice + self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].price_interior
            }
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isexterior == true
            {
                Calculationonprice = Calculationonprice + self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].price_exterior
            }
        }
        else
        {
            var frequency = 1
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 0
            {
                frequency = 1
            }
            else if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 1
            {
                frequency = 3
            }
            else if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 2
            {
                frequency = 5
            }
            
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior == true
            {
                let amount_interior = frequency == 1 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_once
                    : (frequency == 3 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_thrice
                        :self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_five )
                Calculationonprice = Calculationonprice + amount_interior
            }
            
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isexterior == true
            {
                let amount_exterior = frequency == 1 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].exterior_once
                    : (frequency == 3 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].exterior_thrice
                        :self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].exterior_five )
                Calculationonprice = Calculationonprice + amount_exterior
            }
        }
        
        selectedmonthIndex = months.firstIndex{$0 == self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].seletedMonths} ?? 0
        
        if selectedmonthIndex != 0 && self.monthlyPercentageData.count >= selectedmonthIndex {
            let percentage = getPercentageVaueForIndex(sIndex: selectedmonthIndex)

             print(percentage)
            let totalPrice = Calculationonprice * ( selectedmonthIndex + 1 )
            let percent = 100.0
            var discount = 0.0
            if percentage > 0{
            discount = (Double(totalPrice) * percentage) / percent
            print(discount)
            }
            
          Calculationonprice = Int(Double(totalPrice) - discount)
            print(Calculationonprice)
        }
        
        totalmoney = String("AED" + " " + String(Calculationonprice))
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].caramount = Calculationonprice
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].pack_name = self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].pack_name
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].numberOfMonth = selectedmonthIndex + 1
        self.Bookserviectableview.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)

    }
    
    
    func logConfirmCarPackageEvent(confirm_Car_Package : String) {
        let params : AppEvent.ParametersDictionary = ["Confirm_Car_Package" : confirm_Car_Package]
        let event = AppEvent(name: "Car Package", parameters: params)
        AppEventsLogger.log(event)
    }
    
    func getPercentageVaueForIndex(sIndex : Int) -> Double {
        let percentage = 0.0
        switch sIndex {
        case 0:
            if let parValue = monthlyPercentageData["month_1"]{
            return Double(parValue) ?? 0.0
            }
            break
        case 1:
            if let parValue = monthlyPercentageData["month_2"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 2:
            if let parValue = monthlyPercentageData["month_3"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 3:
            if let parValue = monthlyPercentageData["month_4"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 4:
            if let parValue = monthlyPercentageData["month_5"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 5:
            if let parValue = monthlyPercentageData["month_6"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 6:
            if let parValue = monthlyPercentageData["month_7"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 7:
            if let parValue = monthlyPercentageData["month_8"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 8:
            if let parValue = monthlyPercentageData["month_9"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 9:
            if let parValue = monthlyPercentageData["month_10"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 10:
            if let parValue = monthlyPercentageData["month_11"]{
                return Double(parValue) ?? 0.0
            }
            break
        case 11:
            if let parValue = monthlyPercentageData["month_12"]{
                return Double(parValue) ?? 0.0
            }
            break
        default:
            return percentage
        }
        
        return 0.0
    }
    
    
    func popupalertpackage()
    {
        var alertstr = ""
        self.interiorbtn.isSelected = false
        if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isonetime == true
        {
             alertstr = "One Time Interior package doesn't Exist"
            
        }else
        {
            alertstr = "Monthly Interior package doesn't Exist"
            
        }
        let alert = UIAlertController(title: AppName, message: alertstr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    func HitserviceForCarPackage(cartype : String ,completionHandler: @escaping (_ success:Bool?) -> ())
    {
        ServiceManager.instance.alertShowing = true
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"package",
                     "app_key":"123456",
                     "locality_id":GoGreenManeger.instance.LocalityId,
                     "car_type":cartype] as [String : Any]
        print(param)
        MBProgressHUD.showAdded(to: self.view, animated: true)
         ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let sucessnumber = dict1["resCode"] as! NSNumber
                    let package_data_obj = Packageselect()
                    print(sucessnumber)
                    if sucessnumber == 1
                    {
                        if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
                        {
                            if let monthly = result[0]["monthly"] as? Dictionary<String,AnyObject>
                            {
                                package_data_obj.exterior_five = Int((monthly["exterior_five"] as? String)!)!
                                package_data_obj.exterior_once = Int((monthly["exterior_once"] as? String)!)!
                                package_data_obj.exterior_thrice = Int((monthly["exterior_thrice"] as? String)!)!
                                package_data_obj.interior_five = Int((monthly["interior_five"] as? String)!)!
                                package_data_obj.interior_once = Int((monthly["interior_once"] as? String)!)!
                                package_data_obj.interior_thrice = Int((monthly["interior_thrice"] as? String)!)!
                            }
                            if let Oncedata = result[0]["once"] as? Dictionary<String,AnyObject>
                            {
                                package_data_obj.price_exterior = Int((Oncedata["price_exterior"] as? String)!)!
                                package_data_obj.price_interior = Int((Oncedata["price_interior"] as? String)!)!
                            }
                            package_data_obj.isinserted = true
                            package_data_obj.pack_name = (result[0]["name"] as? String)!
                            self.monthlyPercentageData.removeAll()
                            if let monthlyPerData = result[0]["percentage"] as? Dictionary<String, String>
                            {
                                self.monthlyPercentageData = monthlyPerData
                            }
                            
                            self.packagedata_array.insert(package_data_obj, at: self.brandandmodeldropdown.indexForSelectedRow!)
                            self.calculateprice()
                            completionHandler(true)
                        }
                    }
                    else
                    {
                        completionHandler(true)
                        if let msgstr = dict1["message"] as? String
                        {
                            
                            let refreshAlert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
                            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                               
                                self.navigationController?.popViewController(animated: true)
                               
                            }))
                         self.present(refreshAlert, animated: true, completion: nil)
                            
//                            let alert = UIAlertController(title: AppName, message: msgstr, preferredStyle: UIAlertControllerStyle.alert)
//                            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                            self.present(alert, animated: true, completion: nil)

                        }
                       // completionHandler(false)
                    }
                }
                else
                {
                    
                    completionHandler(false)
                    
                }
            }
            else
            {
                
                completionHandler(false)
                
            }
        }
    }
    
//    func HitserviceForCarPackage(cartype : String ,completionHandler: @escaping (_ success:Bool?) -> ())
//    {
//        let headers: HTTPHeaders = ["Content-Type":"application/json"]
//        let param = ["method":"package",
//                     "app_key":"123456",
//                     "locality_id":GoGreenManeger.instance.LocalityId,
//                     "car_type":cartype] as [String : Any]
//        print(param)
//        MBProgressHUD.showAdded(to: self.view, animated: true)
//        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
//        { (success, dictionary, error) in
//            print(dictionary ?? "no")
//             MBProgressHUD.hide(for: self.view, animated: true)
//            if(error == nil)
//            {
//                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
//                {
//                    let sucessnumber = dict1["resCode"] as! NSNumber
//                    let package_data_obj = Packageselect()
//                    print(sucessnumber)
//                    if sucessnumber == 1
//                    {
//                        if let result = dict1["result"] as? [Dictionary<String,AnyObject>]
//                        {
//                            print(result)
//                            if let monthly = result[0]["monthly"] as? Dictionary<String,AnyObject>
//                            {
//                                package_data_obj.exterior_five = Int((monthly["exterior_five"] as? String)!)!
//                                package_data_obj.exterior_once = Int((monthly["exterior_once"] as? String)!)!
//                                package_data_obj.exterior_thrice = Int((monthly["exterior_thrice"] as? String)!)!
//                                package_data_obj.interior_five = Int((monthly["interior_five"] as? String)!)!
//                                package_data_obj.interior_once = Int((monthly["interior_once"] as? String)!)!
//                                package_data_obj.interior_thrice = Int((monthly["interior_thrice"] as? String)!)!
//
//                            }
//                            if let Oncedata = result[0]["once"] as? Dictionary<String,AnyObject>
//                            {
//
//                                package_data_obj.price_exterior = Int((Oncedata["price_exterior"] as? String)!)!
//                                package_data_obj.price_interior = Int((Oncedata["price_interior"] as? String)!)!
//                                self.packagedata_array.append(package_data_obj)
//                                 print(self.packagedata_array)
//                                //self.calculateprice()
//                                if self.packagedata_array.count == 0
//                                {
//                                    self.moneylbl.text = ""
//                                    self.popupback()
//
//                                }else
//                                {
//                                    self.calculateprice()
//
//                                }
//
//                        }
//                    }
//                }
//                    else
//                    {
//
//
//
//
//
//
//                    }
//
//                }
//                else
//                {
//
//                }
//            }
//        }
//
//    }
    
//    func dataappend()
//    {
//        let OrderConfirmationVC = self.storyboard?.instantiateViewController(withIdentifier: "OrderConfirmationVC") as! OrderConfirmationVC
//        self.navigationController?.pushViewController(OrderConfirmationVC, animated: true)
//    }
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    @objc func donePressed()
    {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        let date = Date()
        formatter.dateFormat = "yyyy-MM-dd"
        var Datestr = formatter.string(from: date)
        
        let currentobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
        if picker.date.isFriday(){
            currentobj.date = ""
            popupback(msg: "You could not select the Friday")
        }else{
            currentobj.date = formatter.string(from: picker.date)
        }
        
        self.tableviewreloaddata()
        let indexPath = IndexPath(row: 0, section: 0)
        self.Bookserviectableview.scrollToRow(at: indexPath, at: .bottom, animated: true)
        self.view.endEditing(true)
    }
    
    @objc func termsboxPressed()
    {
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isagree =  !self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isagree
        let contentOffset = self.Bookserviectableview.contentOffset
        self.Bookserviectableview.reloadData()
        self.Bookserviectableview.layoutIfNeeded()
        self.Bookserviectableview.setContentOffset(contentOffset, animated: false)
    }

    @IBAction func openTermsCondition(_ sender: Any)
    {
        let citylistnav = self.storyboard?.instantiateViewController(withIdentifier: "AboutusVC") as! AboutusVC
        citylistnav.fromclass = "bookmycar"
        self.present(citylistnav, animated: true) {}
        //self.navigationController?.pushViewController(TermsConditionNav!, animated: true)
    }
    
    @objc func CancelPressed()
    {
        self.view.endEditing(true)
    }
    
    

}

extension BookServiceVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
         return headerview
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return headerview.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        let currentobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
        if currentobj.isonetime == true
        {
            return 404
        }
        else
        {
            return 451
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let currentobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
        if currentobj.isonetime == true
        {
            var cell: OnetimeBookserviceCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "OneTimecell", for: indexPath) as! OnetimeBookserviceCell
            cell.timerlbl.text = GoGreenManeger.instance.starttime + " - " + GoGreenManeger.instance.endtime
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let done = UIBarButtonItem(barButtonSystemItem: .done , target: nil, action: #selector(donePressed))
            let cancel = UIBarButtonItem(barButtonSystemItem: .cancel , target: nil, action: #selector(CancelPressed))
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
            toolbar.items = [done, flexibleSpace, cancel]
            cell.populatedata(price: totalmoney)
            cell.Nextbtn.addTarget(self, action: #selector(taptonextbtn), for: .touchUpInside)
            cell.datetextf?.inputAccessoryView = toolbar
            cell.datetextf?.inputView = picker
            
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)

            if(hour > 18)
            {
                let today = Date()
                let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)
                picker.minimumDate = tomorrow
            }
            else
            {
                picker.minimumDate = Date()
            }
            
            
            picker.datePickerMode = .date
            cell.clickbtn.addTarget(self, action: #selector(termsboxPressed), for: .touchUpInside)
            cell.Agreeimage.image = currentobj.isagree ? #imageLiteral(resourceName: "select_check_box_icon")  : #imageLiteral(resourceName: "unselect_check_box_icon")
            cell.datetextf?.text = currentobj.date
            return cell
        }
        else
        {
            var cell: MonthlyBookingServiceCell
            cell = tableView.dequeueReusableCell(withIdentifier: "MonthlyCell", for: indexPath) as! MonthlyBookingServiceCell
            cell.timerslbl.text = GoGreenManeger.instance.starttime + " - " + GoGreenManeger.instance.endtime
            cell.Nextbtn.addTarget(self, action: #selector(taptonextbtn), for: .touchUpInside)
            cell.Daycollectionview.reloadData()
            cell.populatedata(price: totalmoney, index: self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex)

            cell.delegate = self
             cell.clickbtn.addTarget(self, action: #selector(termsboxPressed), for: .touchUpInside)
            cell.Agreeimage.image = currentobj.isagree ? #imageLiteral(resourceName: "select_check_box_icon")  : #imageLiteral(resourceName: "unselect_check_box_icon")
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        //self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isagree =  !self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isagree
        let contentOffset = self.Bookserviectableview.contentOffset
        self.Bookserviectableview.reloadData()
        self.Bookserviectableview.layoutIfNeeded()
        self.Bookserviectableview.setContentOffset(contentOffset, animated: false)
    }
}



extension BookServiceVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
    {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
        {
            return dayarr.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
        {
            var cell : UICollectionViewCell
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DayCell", for: indexPath as IndexPath)
            let daylbl = cell.viewWithTag(101) as? UILabel
            daylbl?.text = dayarr[indexPath.row]
            let selecteddayimage : UIImageView = (cell.viewWithTag(106) as? UIImageView)!
            let currenrtobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
            
            if(currenrtobj.selecteddayarr.contains(dayarr[indexPath.row]))
            {
                  daylbl?.textColor = UIColor.darkText
                  selecteddayimage.image = #imageLiteral(resourceName: "select_check_done")
                 selecteddayimage.layer.borderWidth = 1.0
                 selecteddayimage.layer.borderColor = UIColor.white.cgColor
            }
            else
            {
                selecteddayimage.layer.borderWidth = 1.0
                selecteddayimage.layer.borderColor = UIColor.lightGray.cgColor
                selecteddayimage.image = #imageLiteral(resourceName: "unselect_day_icon")
                daylbl?.textColor = UIColor(red: 35.0 / 255.0, green: 31.0 / 255.0, blue: 32.0 / 255.0, alpha: 1.0)
            }
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
        {
            
            
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
        {
            return CGSize(width: self.view.frame.size.width / 5, height: 62)
        }
        
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
        {
            let currenrtobj = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!]
            if (currenrtobj.selecteddayarr.contains(dayarr[indexPath.row]))
            {
                currenrtobj.selecteddayarr.remove(at: currenrtobj.selecteddayarr.index(of: dayarr[indexPath.row])!)
            }
            else
            {
                switch currenrtobj.frequencyindex
                {
                    case 0 :
                        if currenrtobj.selecteddayarr.count < 2
                        {
                            currenrtobj.selecteddayarr.append(self.dayarr[indexPath.row])
                        }
                        break;
                    case 1 :
                        if currenrtobj.selecteddayarr.count < 3
                        {
                            currenrtobj.selecteddayarr.append(self.dayarr[indexPath.row])
                        }
                        break;
                    case 2 :
                        if currenrtobj.selecteddayarr.count < 6
                        {
                            currenrtobj.selecteddayarr.append(self.dayarr[indexPath.row])
                        }

                        break;
                default:
                    break;
                }
                currenrtobj.selecteddayarr = self.sortdays(daysarr: currenrtobj.selecteddayarr)
                print(currenrtobj.selecteddayarr)
            }
            let contentOffset = self.Bookserviectableview.contentOffset
            self.Bookserviectableview.reloadData()
            self.Bookserviectableview.layoutIfNeeded()
            self.Bookserviectableview.setContentOffset(contentOffset, animated: false)
        }
    
    func sortdays(daysarr : [String]) -> [String]
    {
        var modifydayarr = [String]()
        
        if (daysarr.contains("Sun"))
        {
            modifydayarr.append("Sun")
        }
        if (daysarr.contains("Mon"))
        {
            modifydayarr.append("Mon")
        }
        if (daysarr.contains("Tue"))
        {
            modifydayarr.append("Tue")
        }
        if (daysarr.contains("Wed"))
        {
            modifydayarr.append("Wed")
        }
        if (daysarr.contains("Thu"))
        {
            modifydayarr.append("Thu")
        }
        if (daysarr.contains("Sat"))
        {
            modifydayarr.append("Sat")
        }
        return modifydayarr
    }
}

class CarData
{
    var carid = ""
    var carmodel = ""
    var car_brand = ""
    var isinterior : Bool = false
    var isexterior : Bool = true
    var isonetime : Bool = false
    var seletedMonths : String = "Monthly"
    var date = ""
    var frequencyindex = 1
    var selecteddayarr = [String]()
    var isagree : Bool = false
    var cartype = ""
    var carcolor = ""
    var caramount : Int = 0
    var pack_name = ""
    var car_plate_number = ""
    var numberOfMonth:Int = 1
    

 }


class Packageselect
{
    var exterior_five : Int = 0
    var exterior_once : Int = 0
    var exterior_thrice : Int = 0
    var interior_five : Int = 0
    var interior_once : Int = 0
    var interior_thrice : Int = 0
    var price_exterior : Int = 0
    var price_interior : Int = 0
    var totalmoney : Int = 0
    var isinserted = false
    var pack_name = ""

}



//ibaction
extension BookServiceVC
{
    @IBAction func taptointeriorbtn(sender : UIButton)
    {
        if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isonetime == true
        {
            if self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].price_interior == 0
            {
                popupalertpackage()
                return
            }
        }
        else
        {
            var frequency = 1
            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 0
            {
                frequency = 1
            }
            else if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 1
            {
                frequency = 3
            }
            else if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].frequencyindex == 2
            {
                frequency = 5
            }
            
            if frequency == 1
            {
                if self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_once == 0
                {
                       popupalertpackage()
                        return
                }
            }else if frequency == 3
            {
                if self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_thrice == 0
                {
                    popupalertpackage()
                    return
                }
            }else if frequency == 5
            {
                if self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_five == 0
                {
                    popupalertpackage()
                    return
                }
                
            }
            
            
//            if self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior == true
//            {
//                let amount_interior = frequency == 1 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_once
//                    : (frequency == 3 ? self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_thrice
//                        :self.packagedata_array[self.brandandmodeldropdown.indexForSelectedRow!].interior_five )
//                if(amount_interior == 0)
//                {
//                    return
//                }
//            }
        }
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior =  !self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior
        interiorbtn.isSelected = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isinterior
        self.calculateprice()
    }
    
    @IBAction func taptoectyeriorbtn(sender : UIButton)
    {
        self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isexterior =  !self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isexterior
        exteriorbtn.isSelected = self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isexterior
        self.calculateprice()
    }
    
    @IBAction func taptopackagetypebtn(sender : UIButton)
    {
        self.interiorbtn.isSelected = false
        if sender.tag == 101
        {
            self.Bookserviectableview.rowHeight = 300
            self.onetimebtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
            self.monthlybtn.setTitleColor(UIColor.black, for: .normal)
            self.monthlybottomview.backgroundColor = UIColor.clear
            self.onetimebottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isonetime =  true
            self.calculateprice()
            self.tableviewreloaddata()
            
        }
        else if sender.tag == 102
        {
            self.Bookserviectableview.rowHeight = 360
            self.onetimebtn.setTitleColor(UIColor.black, for: . normal)
            self.monthlybtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
            self.monthlybottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            self.onetimebottomview.backgroundColor = UIColor.clear
            self.cardata_array[brandandmodeldropdown.indexForSelectedRow!].isonetime =  false
            self.packegeMonthDropDown.show()
            self.packegeMonthDropDown.selectionAction = { [unowned self] (index, item) in
             self.cardata_array[self.brandandmodeldropdown.indexForSelectedRow!].seletedMonths =  item
            self.monthlybtn.setTitle(item, for: .normal)
                self.selectedmonthIndex = index
                self.calculateprice()
                self.tableviewreloaddata()
            }
        }
//        self.calculateprice()
//        self.tableviewreloaddata()
       
    }
    
    @IBAction func taptouperdropdown(sender : UIButton)
    {
        self.brandandmodeldropdown.show()
        self.brandandmodeldropdown.selectionAction = { [unowned self] (index, item) in
            if(self.packagedata_array[index].isinserted == false)
            {
                self.servicefrogetpackage(index: index)
            }
            else
            {
                let currentcar_obj = self.cardata_array[index]
                self.Brandlbl.text = "\(currentcar_obj.car_brand) \(currentcar_obj.carmodel)"
                self.Modellbl.text = currentcar_obj.car_plate_number
                self.interiorbtn.isSelected = currentcar_obj.isinterior
                self.exteriorbtn.isSelected = currentcar_obj.isexterior
                self.calculateprice()
                
                
                if (currentcar_obj.isonetime)
                {
                    self.onetimebtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                    self.monthlybtn.setTitleColor(UIColor.black, for: .normal)
                    self.monthlybottomview.backgroundColor = UIColor.clear
                    self.onetimebottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                }
                else
                {
                    self.onetimebtn.setTitleColor(UIColor.black, for: .normal)
                    self.monthlybtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                    self.monthlybottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                    self.onetimebottomview.backgroundColor = UIColor.clear
                    self.monthlybtn.setTitle(currentcar_obj.seletedMonths, for: .normal)
                }
                self.tableviewreloaddata()
            }
        }
    }
    
    
    
    
   
    func servicefrogetpackage(index : Int)
    {
        
            let currentcar_obj = self.cardata_array[index]
        self.Brandlbl.text = "\(currentcar_obj.car_brand) \(currentcar_obj.carmodel)"
        self.Modellbl.text = currentcar_obj.car_plate_number
            self.interiorbtn.isSelected = currentcar_obj.isinterior
            self.exteriorbtn.isSelected = currentcar_obj.isexterior
            self.HitserviceForCarPackage(cartype: self.cardata_array[index].cartype, completionHandler: { (status) in
                if(status == false)
                {
                        self.popupback()
                }
            
            self.calculateprice()
            if (currentcar_obj.isonetime)
            {
                self.onetimebtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                self.monthlybtn.setTitleColor(UIColor.black, for: .normal)
                self.monthlybottomview.backgroundColor = UIColor.clear
                self.onetimebottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            }
            else
            {
                self.onetimebtn.setTitleColor(UIColor.black, for: .normal)
                self.monthlybtn.setTitleColor(UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0), for: .normal)
                self.monthlybottomview.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
                self.onetimebottomview.backgroundColor = UIColor.clear
                self.monthlybtn.setTitle(currentcar_obj.seletedMonths, for: .normal)
            }
            self.tableviewreloaddata()
        })
    }
    
    
    func popupback()
    {
        let topController = UIApplication.topViewController()
        //popup
        let refreshAlert = UIAlertController(title: AppName, message: "SomeThing went Wrong", preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "Back", style: .default, handler: { (action: UIAlertAction!) in
            
            // service again call for retry here
            ServiceManager.instance.alertShowing = false
            self.navigationController?.popViewController(animated: true)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        //return
    }
    
    func popupback(msg : String)
    {
        let topController = UIApplication.topViewController()
        //popup
        let refreshAlert = UIAlertController(title: AppName, message: msg, preferredStyle: UIAlertControllerStyle.alert)
        refreshAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) in
            
            // service again call for retry here
//            ServiceManager.instance.alertShowing = false
//            self.navigationController?.popViewController(animated: true)
        }))
        self.present(refreshAlert, animated: true, completion: nil)
        //return
    }
    
    
}


extension Date{
    func isFriday() -> Bool{
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents([.weekday], from: self)
        if components.weekday == 6 {
            return true
        } else {
            return false
        }
    }
}

