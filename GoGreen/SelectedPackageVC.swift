//
//  SelectedPackageVC.swift
//  GoGreen
//
//  Created by Sonu on 04/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

class SelectedPackageVC: UIViewController
{

    @IBOutlet var Ordertableview : UITableView!
    @IBOutlet var topview : UIView!
    
    var detailarr = ["Customer Details" , "Package Details" , "Car Details"]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.topview.layer.shadowColor = UIColor.lightGray.cgColor
        self.topview.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.topview.layer.shadowOpacity = 0.3
        self.topview.layer.shadowRadius = 10.0
        self.topview.layer.masksToBounds = false
        self.Ordertableview.rowHeight = 210
        
    }
    @IBAction func taptobackbtn(sender : UIButton)
    {
        self.navigationController?.popViewController(animated: true)
    }

}

extension SelectedPackageVC : UITableViewDataSource , UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return detailarr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell!
        cell = tableView.dequeueReusableCell(withIdentifier: "BookCarCell", for: indexPath)
        let packagelbl : UILabel = (cell.viewWithTag(101) as? UILabel)!
        packagelbl.text = detailarr[indexPath.row]
        let mainBackground = cell.viewWithTag(104) as! UIView
        mainBackground.layer.cornerRadius = 8
        mainBackground.layer.masksToBounds = true
        mainBackground.layer.masksToBounds = false
        mainBackground.layer.shadowOffset = CGSize(width: -1, height: 1)
        mainBackground.layer.shadowColor = UIColor.black.cgColor
        mainBackground.layer.shadowOpacity = 0.23
        mainBackground.layer.shadowRadius = 4
        
        
        
        
        if indexPath.row == 0
        {
            
            
            
        }else if indexPath.row == 1
        {
            
            
            
        }else if indexPath.row == 2
        {
            
            
            
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("You tapped cell number \(indexPath.row).")
    }
}
