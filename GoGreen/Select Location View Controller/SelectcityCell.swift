//
//  SelectcityCell.swift
//  GoGreen
//
//  Created by Sonu on 20/06/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit
import PullToRefresh

protocol addrefresherdelegate
{
    func refrteshercall(completionHandler: @escaping (_ success:Bool?) -> ())

    //func refrteshercall()
    
}

class SelectcityCell: UICollectionViewCell
{
    
    @IBOutlet var selectcitytableview : UITableView!
    @IBOutlet var shadowview : UIView!
    var delegaterefresh : addrefresherdelegate?
    let refresher = PullToRefresh()
    var refreshControl = UIRefreshControl()
    
    func refreshdata()
    {
        self.selectcitytableview.addPullToRefresh(refresher)
        {
            self.delegaterefresh?.refrteshercall(completionHandler: { (status) in
                 self.selectcitytableview.endRefreshing(at: .top)
                let contentOffset = self.selectcitytableview.contentOffset
                self.selectcitytableview.layoutIfNeeded()
                self.selectcitytableview.setContentOffset(.zero, animated: false)
                self.selectcitytableview.contentOffset = .zero
                self.selectcitytableview.setContentOffset(.zero, animated: true)
                self.selectcitytableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.selectcitytableview.reloadData ()
            })
            
        }
    }
}

