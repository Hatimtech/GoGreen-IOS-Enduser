//
//  WelcomeVc.swift
//  Baranoy
//
//  Created by Sonu on 20/11/17.
//  Copyright © 2017 Sonu. All rights reserved.
//

import UIKit


class TutorialVC: UIViewController {
    
    
     @IBOutlet var pageController : UIPageControl!
     @IBOutlet var welcomecollectionview : UICollectionView!
     @IBOutlet var bottonbutton : UIButton!

    
    var headerlbl = ["Relax,and Leave the dirty work to us",
                     "Order on-demand or plan ahead",
                     "Convenience at your fingertips",
                     "Don’t let your friends drive dirty!"]
    
    var desclbl = ["Our team arrives fully-equipped on site  with everything they need",
                   "Tap “one time wash” for an on-demand service or book our monthly packages for exciting prices",
                   "Add cars, schedule washes, make payment, renewals",
                   "Invite your friends to download our app to earn free washes"]
    
    var tutimgs = [#imageLiteral(resourceName: "tut_1"),#imageLiteral(resourceName: "tut_2"),#imageLiteral(resourceName: "tut_3"),#imageLiteral(resourceName: "tut_4")];
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width, height: welcomecollectionview.frame.size.height)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        welcomecollectionview!.collectionViewLayout = layout
        welcomecollectionview.reloadData()
       
    }
 
    @IBAction func movetosignup(sender : UIButton)
    {
        let Signup_obj = self.storyboard?.instantiateViewController(withIdentifier: "LaunchNav")
        appDelegate.window?.rootViewController = Signup_obj
        appDelegate.window?.makeKeyAndVisible()
    }

    
    @IBAction func movetoLogin(sender : UIButton)
    {
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }

    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
}


extension TutorialVC : UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        var cell : UICollectionViewCell
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeCell", for: indexPath as IndexPath)
        let descriptionlbl = cell.viewWithTag(102) as! UILabel
        let headerlbl = cell.viewWithTag(101) as! UILabel
        let img_tut = cell.viewWithTag(103) as! UIImageView
        descriptionlbl.text = self.desclbl[indexPath.row]
        headerlbl.text = self.headerlbl[indexPath.row]
        img_tut.image = self.tutimgs[indexPath.row]
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        self.pageController.currentPage = indexPath.row
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        if(scrollView == self.welcomecollectionview)
        {
            let center = CGPoint(x: scrollView.contentOffset.x + (scrollView.frame.width / 2), y: (scrollView.frame.height / 2))
            if let indexPath = self.welcomecollectionview.indexPathForItem(at: center)
            {
                if(indexPath.row == 3)
                {
                    bottonbutton.setTitle("DONE", for: .normal)
                }
                else
                {
                    bottonbutton.setTitle("SKIP", for: .normal)
                }
            }
            else
            {
                bottonbutton.setTitle("SKIP", for: .normal)
            }
        }
    }
}
