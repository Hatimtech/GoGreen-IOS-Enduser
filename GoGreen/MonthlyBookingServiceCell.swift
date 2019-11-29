//
//  MonthlyBookingServiceCell.swift
//  GoGreen
//
//  Created by Sonu on 04/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import DropDown

protocol changefrquencyindexdelegate
{
    func changefrqquencyindex(index : Int)
    
}

class MonthlyBookingServiceCell: UITableViewCell
{
    
    @IBOutlet var Daycollectionview : UICollectionView!
    @IBOutlet var DropDownbtn : UIButton!
    @IBOutlet var frequencylbl : UILabel!
    @IBOutlet var Nextbtn : UIButton!
    @IBOutlet var Agreeimage : UIImageView!
    @IBOutlet var timerslbl : UILabel!
    @IBOutlet var clickbtn : UIButton!
    @IBOutlet var selectpackageview : UIView!
    @IBOutlet var selectpackageinnerview : UIView!
    //@IBOutlet weak var timelbl: UILabel!
    @IBOutlet weak var moneylbl: UILabel!
    var dayname = ["Twice a week","Thrice a week", "Daily"]
    
    
    var delegate : changefrquencyindexdelegate?
    var frequencyindex : Int  = 0
   
    
    
    let Enterfrequency = DropDown()
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    
    func populatedata(price : String, index : Int)
    {
        self.selectpackageview.layer.shadowColor = UIColor.lightGray.cgColor
        self.selectpackageview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.selectpackageview.layer.shadowOpacity = 0.3
        self.selectpackageview.layer.shadowRadius = 10
        self.selectpackageinnerview.layer.cornerRadius = 10.0
        self.selectpackageinnerview.layer.masksToBounds = true
        moneylbl.text = price
        self.frequencylbl.text = dayname[index]
    }
    
    @IBAction func taptofrequncybtn(sender : UIButton)
    {
        self.Daycollectionview.reloadData()
        Enterfrequency.anchorView = DropDownbtn //colur
        Enterfrequency.direction = .bottom
        Enterfrequency.dataSource = dayname//["1 Days","3 Days", "5 Days"]
        self.Enterfrequency.show()
        self.Enterfrequency.selectionAction = { [unowned self] (index, item) in
            self.frequencyindex = index
            self.frequencylbl.text = item
            self.delegate?.changefrqquencyindex(index: index)
        }
    }
}

