//
//  MyOrderVC.swift
//  GoGreen
//
//  Created by Sonu on 01/08/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import MBProgressHUD
import PullToRefresh


class MyOrderVC: UIViewController
{
    
    @IBOutlet var topview : UIView!
    @IBOutlet var activeview : UIView!
    @IBOutlet var expireview : UIView!
    @IBOutlet var MyOrdertableview : UITableView!
    @IBOutlet var Activebtn : UIButton!
    @IBOutlet var Expirebtn : UIButton!
    @IBOutlet var vwnodata : UIView!

    var isactive = true
    let refresher = PullToRefresh()
    var activepackagearr : [Dictionary<String,AnyObject>] = []
    var expirepackagearr : [Dictionary<String,AnyObject>] = []
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        self.MyOrdertableview.rowHeight = 200
        self.setupui()
        self.HitserviceForMyOrder()
        self.MyOrdertableview.addPullToRefresh(refresher)
        {
            self.HitserviceForMyOrder()
        }
       // datanotfoundlbl.isHidden = true
    }
    
    
    func HitserviceForMyOrder()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = [
            "method":"get_orders",
            "app_key":"123456",
            "user_id":user_id
            ] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: my_order, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.MyOrdertableview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    let statuscode = dict1["resCode"] as! NSNumber
                    if statuscode == 1
                    {
                        if let activepackagearr = dict1["result"]!["active_package"] as? [Dictionary<String,AnyObject>]
                        {
                            self.activepackagearr = activepackagearr
                            print(self.activepackagearr.count)
                            self.MyOrdertableview.reloadData()
                        }
                        if let expirpackagearr = dict1["result"]!["expired_package"] as? [Dictionary<String,AnyObject>]
                        {
                            self.expirepackagearr = expirpackagearr
                        }
                        self.MyOrdertableview.reloadData()
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
                else
                {
                    
                }
            }
        }
    }

    
    
    func setupui()
    {
        activeview.layer.shadowColor = UIColor.lightGray.cgColor
        activeview.layer.shadowOpacity = 1
        activeview.layer.shadowOffset = CGSize.zero
        activeview.layer.shadowRadius = 5
        
        expireview.layer.shadowColor = UIColor.lightGray.cgColor
        expireview.layer.shadowOpacity = 1
        expireview.layer.shadowOffset = CGSize.zero
        expireview.layer.shadowRadius = 5
        
        Activebtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
        Activebtn.setTitleColor(UIColor.white, for: .normal)
        Expirebtn.backgroundColor = UIColor.white
        Expirebtn.setTitleColor(UIColor.black, for: .normal)
        
    }
    
    
    @IBAction func taptouperbtn(sender : UIButton)
    {
        
        if sender.tag == 101
        {
            self.isactive = true
            Activebtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            Activebtn.setTitleColor(UIColor.white, for: .normal)
            Expirebtn.backgroundColor = UIColor.white
            Expirebtn.setTitleColor(UIColor.black, for: .normal)
            self.MyOrdertableview.reloadData()
            
        }else if sender.tag == 102
        {
            self.isactive = false
            Expirebtn.backgroundColor = UIColor(red: 76.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
            Activebtn.backgroundColor = UIColor.white
            Expirebtn.setTitleColor(UIColor.white, for: .normal)
            Activebtn.setTitleColor(UIColor.black, for: .normal)
            //activeview.backgroundColor = UIColor.white
            self.MyOrdertableview.reloadData()
        }
    }
    
    
    @IBAction func taptobackbtn(sender : UIButton)
    {
        GoGreenManeger.instance.SetSlidemenuhome()
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
    func nullToNil(value : AnyObject?) -> AnyObject?
    {
        if value is NSNull
        {
            return nil
        } else
        {
            return value
        }
    }
}


extension MyOrderVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if isactive == true
        {
            self.vwnodata.isHidden = self.activepackagearr.count > 0 ? true : false
            self.MyOrdertableview.isHidden = self.activepackagearr.count > 0 ? false : true
            return self.activepackagearr.count
            
        }else
        {
            self.vwnodata.isHidden = self.expirepackagearr.count > 0 ? true : false
            self.MyOrdertableview.isHidden = self.expirepackagearr.count > 0 ? false : true
            return self.expirepackagearr.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "MyorderCell", for: indexPath)
        let carmodellbl : UILabel = cell.viewWithTag(101) as! UILabel
        let carparkinglbl : UILabel = cell.viewWithTag(102) as! UILabel
        let carcalenderlbl : UILabel = cell.viewWithTag(103) as! UILabel
        let carpackagetypelbl : UILabel = cell.viewWithTag(105) as! UILabel
        let orderlbl : UILabel = cell.viewWithTag(106) as! UILabel
        var carbrandandmodelstr = ""
        
        if isactive == true
        {
            if let brand = self.activepackagearr[indexPath.row]["brand"] as? String
            {
                carbrandandmodelstr = brand
            }
            if let orders_id = self.activepackagearr[indexPath.row]["orders_id"] as? String
            {
                orderlbl.text = "Order Id : \(orders_id)"
            }
            else
            {
                orderlbl.text = ""
            }
            
            if let model = self.activepackagearr[indexPath.row]["model"] as? String
            {
                carbrandandmodelstr += " " + (model )
            }
            
            carmodellbl.text = carbrandandmodelstr
            print(carbrandandmodelstr)
            
            if let expiry_date = self.activepackagearr[indexPath.row]["expiry_date"] as? String
            {
                carcalenderlbl.text = expiry_date
            }
//            if let parking_number = self.activepackagearr[indexPath.row]["parking_number"] as? String
//            {
//                carparkinglbl.text = parking_number
//            }
            if let parking_number = self.activepackagearr[indexPath.row]["reg_no"] as? String
            {
                carparkinglbl.text = parking_number
            }
            
            if let services = self.activepackagearr[indexPath.row]["services"] as? String
            {
                if services == "2"
                {
                    carpackagetypelbl.text = "Exterior"
                    
                }else
                {
                    carpackagetypelbl.text = "Interior , Exterior"
                }
            }
            
        }else
        {
             if let orders_id = self.expirepackagearr[indexPath.row]["orders_id"] as? String
            {
                orderlbl.text = "Order Id : \(orders_id)"
            }else
            {
                orderlbl.text = ""
                
            }
            
            if let brand = self.expirepackagearr[indexPath.row]["brand"] as? String
            {
                carbrandandmodelstr = brand
            }
            if let model = self.expirepackagearr[indexPath.row]["model"] as? String
            {
                carbrandandmodelstr += " " + (model )
            }
            carmodellbl.text = carbrandandmodelstr
            print(carbrandandmodelstr)
            if let expiry_date = self.expirepackagearr[indexPath.row]["expiry_date"] as? String
            {
                carcalenderlbl.text = expiry_date
            }
            if let parking_number = self.expirepackagearr[indexPath.row]["parking_number"] as? String
            {
                carparkinglbl.text = parking_number
            }
            if let parking_number = self.expirepackagearr[indexPath.row]["parking_number"] as? String
            {
                carparkinglbl.text = parking_number
            }
            
            if let services = self.expirepackagearr[indexPath.row]["services"] as? String
            {
                if services == "2"
                {
                    carpackagetypelbl.text = "Exterior"
                    
                }else
                {
                    carpackagetypelbl.text = "Interior , Exterior"
                }
            }
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
                print("You tapped cell number \(indexPath.row).")
          //MyOrderDetailVC
        let MyOrderDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "MyOrderDetailVC") as! MyOrderDetailVC
        if isactive == true
        {
            MyOrderDetailVC.receivedarr = [self.activepackagearr[indexPath.row]]
        }else
        {
            MyOrderDetailVC.receivedarr = [self.expirepackagearr[indexPath.row]]
        }
        MyOrderDetailVC.isactive = self.isactive
         self.navigationController?.pushViewController(MyOrderDetailVC, animated: true)
    }

}
