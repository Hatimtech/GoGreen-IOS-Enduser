//
//  BookCarServiceVC.swift
//  GoGreen
//
//  Created by Sonu on 28/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire
import MBProgressHUD
import SwipeCellKit
import PullToRefresh



class CarListVC: UIViewController
{

    @IBOutlet var Bookacatatbleview : UITableView!
    @IBOutlet var outerviewbtn : UIView!
    @IBOutlet var plusbtn : UIButton!
    @IBOutlet var topview : UIView!
    @IBOutlet var backbtn : UIButton!
    @IBOutlet weak var vwnodata: UIView!

    var Carlistarr : [Dictionary<String,AnyObject>] = []
    var selecteddataarr : [Dictionary<String,AnyObject>] = []
    var iscellfillup :Bool = false
    let refresher = PullToRefresh()
  
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.Bookacatatbleview.rowHeight = 160
        self.outerviewbtn.layer.cornerRadius = 20.0
        self.outerviewbtn.layer.masksToBounds = true
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
    }
    
    override func viewWillAppear(_ animated: Bool)
    {

        HitserviceForcarlist()

        GoGreenManeger.instance.iseditcardetail = false
        self.Bookacatatbleview.addPullToRefresh(refresher)
        {
            self.HitserviceForcarlist()
        }

        
        if GoGreenManeger.instance.issetdidemenu == true
        {
            backbtn.isHidden = false
            backbtn.isUserInteractionEnabled = true
            
        }else {
            
            backbtn.isHidden = true
            backbtn.isUserInteractionEnabled = false
            
        }
        
        backbtn.isHidden = false
        backbtn.isUserInteractionEnabled = true
    }
    
    
    @objc func refresh(sender:AnyObject)
    {
        HitserviceForcarlist()
    }
    
    @IBAction func taptobackbtn()
    {
        if GoGreenManeger.instance.issetdidemenu == true
        {
            GoGreenManeger.instance.SetSlidemenuhome()
            
        }else
        {
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    @IBAction func TaptomoveEnterCarDetailVC(sender : UIButton)
    {
        let EnterCarDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterCarDetailVC") as! EnterCarDetailVC
        self.navigationController?.pushViewController(EnterCarDetailVC, animated: true)
    }
    
    @IBAction func Taptoprocedbtn(sender : UIButton)
    {
      if Reachability.isConnectedToNetwork() == true
      {
          if self.selecteddataarr.count > 0
         {
            let BookServiceVC = self.storyboard?.instantiateViewController(withIdentifier: "BookServiceVC") as! BookServiceVC
            BookServiceVC.receivedataarr = self.selecteddataarr as [Dictionary<String, AnyObject>]
            self.navigationController?.pushViewController(BookServiceVC, animated: true)
          }else
         {
              let alert = UIAlertController(title: AppName, message: "Select a car to buy a package.", preferredStyle: UIAlertControllerStyle.alert)
              alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
             self.present(alert, animated: true, completion: nil)
         }
      }else
      {
         let alert = UIAlertController(title: "Network Problem", message: kAlertNoNetworkMessage, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
     }
}
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
   
}

extension CarListVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
         return Carlistarr.count
    }
    
   
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            var cell: UITableViewCell!
            cell = tableView.dequeueReusableCell(withIdentifier: "BookCarCell", for: indexPath)
            let carbrandlbl = cell.viewWithTag(101) as! UILabel
            let colourlbl = cell.viewWithTag(102) as! UILabel
            let cartypelbl = cell.viewWithTag(103) as! UILabel
            let carregnolbl = cell.viewWithTag(105) as! UILabel
            let selectedimage = cell.viewWithTag(106) as! UIImageView
            let cartypeimg = cell.viewWithTag(501) as! UIImageView
            var carfulle_str = ""
            if Carlistarr.count >= indexPath.row, let brand = Carlistarr[indexPath.row]["brand"]
            {
                carfulle_str = (brand as? String)!
            }
            if Carlistarr.count >= indexPath.row, let brand = Carlistarr[indexPath.row]["model"]
            {
                carfulle_str = carfulle_str + " " + (brand as? String ?? "")
            }
            carbrandlbl.text = carfulle_str
            if Carlistarr.count >= indexPath.row, let colourstr = Carlistarr[indexPath.row]["color"]
            {
                colourlbl.text = colourstr as? String
            }
            if Carlistarr.count >= indexPath.row, let cartype = Carlistarr[indexPath.row]["reg_no"]
            {
                cartypelbl.text = cartype as? String
            }
        
          if Carlistarr.count >= indexPath.row, let cartype = Carlistarr[indexPath.row]["parking_number"]
          {
            carregnolbl.text = cartype as? String
         }
        
        if Carlistarr.count >= indexPath.row, let type = self.Carlistarr[indexPath.row]["type"]
        {
            if type as! String == "Saloon"
            {
                cartypeimg.image = #imageLiteral(resourceName: "small_saloon_image")
               
            }else
            {
                cartypeimg.image = #imageLiteral(resourceName: "small_suv_image")
            }
        }
        
        if Carlistarr.count >= indexPath.row, let packageno = self.Carlistarr[indexPath.row]["is_package"]
        {
            let curvedimage = cell.viewWithTag(401) as! UIImageView
            let maincircleview = cell.viewWithTag(402) as! UIView
            let mangeview = cell.viewWithTag(403) as! UIView
            
            if packageno as! String == "2"
            {
                curvedimage.isHidden = false
                maincircleview.isHidden = false
                mangeview.isHidden = false
            }else
            {
                curvedimage.isHidden = true
                maincircleview.isHidden = true
                mangeview.isHidden = true
            }
            
        }
        let dict = self.Carlistarr[indexPath.row]
        if (self.selecteddataarr as NSArray).contains(dict)
        {
            selectedimage.image = #imageLiteral(resourceName: "select_check_done")
        }
        else
        {
            selectedimage.image = #imageLiteral(resourceName: "unselect_check_done")
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
         let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            GoGreenManeger.instance.iseditcardetail = true
            let EnterCarDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterCarDetailVC") as! EnterCarDetailVC
            EnterCarDetailVC.receivededitarr = [self.Carlistarr[indexPath.row]]
            self.navigationController?.pushViewController(EnterCarDetailVC, animated: true)
            
            //TODO: edit the row at indexPath here
//            if let packageno = self.Carlistarr[indexPath.row]["is_package"]
//            {
//                if packageno as! String == "2"
//                {
//                    let alert = UIAlertController(title: AppName, message: "Package Already Active On the Car Not Deleted", preferredStyle: UIAlertControllerStyle.alert)
//                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
//                    self.present(alert, animated: true, completion: nil)
//                }else
//                {
//                    // Edit Screen
//                    GoGreenManeger.instance.iseditcardetail = true
//                    let EnterCarDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterCarDetailVC") as! EnterCarDetailVC
//                    EnterCarDetailVC.receivededitarr = [self.Carlistarr[indexPath.row]]
//                    self.navigationController?.pushViewController(EnterCarDetailVC, animated: true)
//                }
//
//            }
        }
            
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            //TODO: Delete the row at indexPath here
            if let packageno = self.Carlistarr[indexPath.row]["is_package"]
            {
                if packageno as! String == "2"
                {
                    let alert = UIAlertController(title: AppName, message: "Package Already Active On the Car Not Deleted", preferredStyle: UIAlertControllerStyle.alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }else
                {
                   // Hit delete services
                    if let carid = self.Carlistarr[indexPath.row]["id"]
                    {
                        print(carid)
                        self.HitserviceForDeleteCar(car_id: carid as! String)
                    }
                    
                }
                
            }
        }
        editAction.backgroundColor = UIColor(red: 77.0 / 255.0, green: 161.0 / 255.0, blue: 2.0 / 255.0, alpha: 1.0)
        deleteAction.backgroundColor = .red
        return [editAction,deleteAction]
  }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
         if let packageno = self.Carlistarr[indexPath.row]["is_package"]
        {
            if packageno as! String == "2"
            {
                let alert = UIAlertController(title: AppName, message: "Package Already Active On the Car", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }else
            {
                let dict = self.Carlistarr[indexPath.row] as Dictionary<String,AnyObject>
                if (self.selecteddataarr as NSArray).contains(dict)
                {
                    let index = (self.selecteddataarr as NSArray).index(of: dict)
                    self.selecteddataarr.remove(at: index)
                }else {
                    
                    self.selecteddataarr.append(self.Carlistarr[indexPath.row])
                }
                
            }
            
        // only reload tableview
//            self.Bookacatatbleview.isScrollEnabled = false
//            let contentOffset = self.Bookacatatbleview.contentOffset
            self.Bookacatatbleview.reloadData()
//            self.Bookacatatbleview.layoutIfNeeded()
//            self.Bookacatatbleview.setContentOffset(contentOffset, animated: false)
//            self.Bookacatatbleview.isScrollEnabled = true

    }
}
}


extension Array {
    func contains<T>(obj: T) -> Bool where T : Equatable {
        return self.filter({$0 as? T == obj}).count > 0
    }
}


extension CarListVC {
   
    func HitserviceForDeleteCar(car_id : String)
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"remove_car",
                     "app_key":"123456",
                     "user_id": user_id,
                     "car_id":car_id] as [String : Any]
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
                            self.selecteddataarr.removeAll()
                            self.Carlistarr.removeAll()
                            self.Bookacatatbleview.reloadData()
                            self.HitserviceForcarlist()
                            
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
    
    
    func HitserviceForcarlist()
    {
        let result = UserDefaults.standard.object(forKey: "logindict_info") as! Dictionary<String,AnyObject>
        let user_id = result["id"] as! String
        MBProgressHUD.showAdded(to: self.view, animated: true)
        let headers: HTTPHeaders = ["Content-Type":"application/json"]
        let param = ["method":"car_list",
                     "app_key":"123456",
                     "user_id":user_id] as [String : Any]
        print(param)
        ServiceManager.instance.request(method: .post, URLString: inser_cardetail, parameters: param as [String : AnyObject] , encoding: JSONEncoding.default, headers: headers)
        { (success, dictionary, error) in
            print(dictionary ?? "no")
            MBProgressHUD.hide(for: self.view, animated: true)
            self.Bookacatatbleview.endRefreshing(at: .top)
            if(error == nil)
            {
                if  let dict1 = dictionary?["data"] as? Dictionary<String,AnyObject>
                {
                    if let statuscode = dict1["resCode"] as? NSNumber
                    {
                        if statuscode == 1
                        {
                            self.Carlistarr.removeAll()
                            if let carlistarr = dict1["result"] as? [Dictionary<String,AnyObject>]
                            {
                                self.Carlistarr = carlistarr
                                self.Bookacatatbleview.reloadData()
                            }
                            self.vwnodata.isHidden = (self.Carlistarr.count > 0) ? true : false
                            self.Bookacatatbleview.isHidden = (self.Carlistarr.count > 0) ? false : true
                        }
                        else
                        {
                            self.vwnodata.isHidden = (self.Carlistarr.count > 0) ? true : false
                            if let msgstr = dict1["message"] as? String
                            {
                                let EnterCarDetailVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterCarDetailVC") as! EnterCarDetailVC
                                EnterCarDetailVC.doublePop = true;
                                self.navigationController?.pushViewController(EnterCarDetailVC, animated: false)
                            }
                        }
                    }
                }
            }
        }
    }
    
}
