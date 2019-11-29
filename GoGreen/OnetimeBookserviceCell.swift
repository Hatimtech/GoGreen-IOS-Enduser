//
//  OnetimeBookserviceCell.swift
//  GoGreen
//
//  Created by Sonu on 04/07/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

class OnetimeBookserviceCell: UITableViewCell
{

    @IBOutlet var datetextf : UITextField?
    @IBOutlet var Nextbtn : UIButton!
    @IBOutlet var Agreeimage : UIImageView!
    @IBOutlet var timerlbl : UILabel!
    @IBOutlet var clickbtn : UIButton!
    @IBOutlet var selectpackageview : UIView!
    @IBOutlet var selectpackageinnerview : UIView!
    @IBOutlet weak var moneylbl: UILabel!
    //@IBOutlet weak var timelbl: UILabel!
    let picker = UIDatePicker()
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    
    func populatedata(price : String)
    {
        self.selectpackageview.layer.shadowColor = UIColor.lightGray.cgColor
        self.selectpackageview.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.selectpackageview.layer.shadowOpacity = 0.3
        self.selectpackageview.layer.shadowRadius = 10
        self.selectpackageinnerview.layer.cornerRadius = 10.0
        self.selectpackageinnerview.layer.masksToBounds = true
        moneylbl.text = price
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
    }

}
