//
//  HowitworkVc.swift
//  Baranoy
//
//  Created by Sonu on 24/11/17.
//  Copyright © 2017 Sonu. All rights reserved.
//

import UIKit




class HowitworkVc: UIViewController
{

    @IBOutlet var howitstableview : UITableView!
    @IBOutlet var topview : UIView!
    
    
    var titlearr = ["Select Your Location", "Add Your Vehicles" , "Choose A Package" , "Choose Payment Option" , "Confirm Your Order" ]
     var imagarr = [#imageLiteral(resourceName: "locality_icon"), #imageLiteral(resourceName: "car_model_icon") , #imageLiteral(resourceName: "choose_icon") , #imageLiteral(resourceName: "payment_icon"), #imageLiteral(resourceName: "city_icon")]
     var countingarr = ["1" , "2" , "3" , "4" , "5"]
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let screenSize = UIScreen.main.bounds
        let screenHeight = screenSize.height
        self.howitstableview.rowHeight = (screenHeight - 130)  / 5
//        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
//        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
//        self.topview.layer.shadowOpacity = 0.3
//        self.topview.layer.shadowRadius = 10.0
//        self.topview.layer.masksToBounds = false
    }
    
    

    @IBAction func Taptohowitswork(sender : UIButton)
    {
        let SelectionCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
        self.navigationController?.pushViewController(SelectionCityVC, animated: true)
    }
    
    @IBAction func Taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
       
    }
    
}

extension HowitworkVc : UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return titlearr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HowitworkCell")
        let mainBackground = cell?.viewWithTag(104) as! UIView
        mainBackground.layer.cornerRadius = 8
        mainBackground.layer.masksToBounds = true
        mainBackground.layer.masksToBounds = false
        mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
        mainBackground.layer.shadowColor = UIColor.black.cgColor
        mainBackground.layer.shadowOpacity = 0.23
        mainBackground.layer.shadowRadius = 4
        
        let uperimgview : UIView = cell?.viewWithTag(109) as! UIView
        let downimgview : UIView = cell?.viewWithTag(114) as! UIView
        let backGroundView : UIView = cell?.viewWithTag(47896) as! UIView
    
        if(indexPath.row == 0)
        {
            backGroundView.backgroundColor = UIColor.white
        }
        else
        {
            mainBackground.backgroundColor = UIColor.lightGray
        }
        
        if indexPath.row == 4
        {
            uperimgview.isHidden = true
            downimgview.isHidden = true
            
        }else
        {
            uperimgview.isHidden = false
            downimgview.isHidden = false
        }
        

        let image : UIImageView = cell?.viewWithTag(103) as! UIImageView
        image.image = imagarr[indexPath.row]
        let titlelbl : UILabel = cell?.viewWithTag(102) as! UILabel
        titlelbl.text = titlearr[indexPath.row]
        let countinglbl : UIButton = cell?.viewWithTag(110) as! UIButton
        countinglbl.layer.masksToBounds = true
        countinglbl.layer.masksToBounds = false
        countinglbl.layer.shadowOffset = CGSize(width: -1, height: 1)
        countinglbl.layer.shadowColor = UIColor.yellow.cgColor
        countinglbl.layer.shadowOpacity = 0.23
        countinglbl.layer.shadowRadius = 4
        countinglbl.setTitle(countingarr[indexPath.row], for: .normal)
        let borderview : UIView = cell?.viewWithTag(111) as! UIView
        borderview.layer.cornerRadius = 15
        countinglbl.layer.cornerRadius = 10
        countinglbl.layer.masksToBounds = true
        borderview.layer.borderWidth = 1.0
        borderview.layer.borderColor = UIColor(red: 90.0 / 255.0, green: 165.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0).cgColor
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if(indexPath.row == 0)
        {
            let SelectionCityVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectionCityVC") as! SelectionCityVC
            self.navigationController?.pushViewController(SelectionCityVC, animated: true)
        }
   }
}
