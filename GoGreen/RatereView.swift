//
//  Rateview.swift
//  GoGreen
//
//  Created by Sonu on 02/08/18.
//  Copyright © 2018 Sonu. All rights reserved.
//

import UIKit

protocol StardatasentDelegate
{
    func numbercountofstar(numberofstar : String , feedback : String)
}


class RatereView: UIView
{
     @IBOutlet var start1 : UIButton!
     @IBOutlet var start2 : UIButton!
     @IBOutlet var start3 : UIButton!
     @IBOutlet var start4 : UIButton!
     @IBOutlet var start5 : UIButton!
     @IBOutlet var feedbacktextview : UITextView!
     @IBOutlet var ratelbl : UILabel!
     @IBOutlet var userlbl : UILabel!
     @IBOutlet var userimage : UIImageView!
    
      @IBOutlet var floatRatingView: FloatRatingView!
    
    
     var Delegate : StardatasentDelegate!
     var starcount = "1"
     var image_str = ""
    
    @IBAction func TaptoCrossbtn(sender : UIButton)
    {
            self.removeFromSuperview()
    }
    
    
    @IBAction func TaptoSubmitbtn(sender : UIButton)
    {
        if feedbacktextview.text.isEmpty
        {
            if let topController = UIApplication.topViewController()
            {
                 self.emptyalertpopshow(view:topController , Titlestr : AppName ,descriptionStr : "Please Provide a feedback")
            }
            
        }else
        {
            self.Delegate.numbercountofstar(numberofstar: starcount, feedback: feedbacktextview.text)
            self.removeFromSuperview()
        }
    }
    
    
    func emptyalertpopshow(view:UIViewController , Titlestr : String ,descriptionStr : String)
    {
        let alert = UIAlertController(title: Titlestr, message:  descriptionStr, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    
    func floatdelegatecall()
    {
        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.clear
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIViewContentMode.scaleAspectFit
        floatRatingView.type = .halfRatings
}
    
    @IBAction func Taptorateicon(sender : UIButton)
    {
        if sender.tag == 101
        {
            start1.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start2.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start3.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start4.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start5.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            starcount = "1"
            
        }else if sender.tag == 102
        {
            start5.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start1.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start2.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start3.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start4.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            starcount = "2"
            
        }else if sender.tag == 103
        {
            start5.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start1.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start2.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start3.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start4.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            starcount = "3"
            
        }else if sender.tag == 104
        {
            start5.setImage(#imageLiteral(resourceName: "star_unselected"), for: .normal)
            start1.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start2.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start3.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start4.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            starcount = "4"
            
        }else if sender.tag == 105
        {
            start5.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start1.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start2.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start3.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            start4.setImage(#imageLiteral(resourceName: "star_selected"), for: .normal)
            starcount = "5"
        }
                
    }
    
    

}


extension RatereView: FloatRatingViewDelegate
{

    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double)
    {
          starcount = String(format: "%.2f", self.floatRatingView.rating)
    }
    
    /// Returns the rating value as the user pans
    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double)
    {
        
        print(String(format: "%.2f", self.floatRatingView.rating))
       
        
    }

}

