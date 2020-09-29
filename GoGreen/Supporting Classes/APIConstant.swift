//
//  APIConstant.swift
//  kestone
//
//  Created by Prankur on 04/07/17.
//  Copyright © 2017 Com.ripenApps. All rights reserved.
//

import Foundation
import UIKit

let baseApiUrl = "http://13.126.37.218/gogreenstaging/index.php/" // production
//let baseApiUrl = "http://52.66.242.183/gogreen/index.php/" // new url
//let baseApiUrl =  "http://13.126.99.14/gogreen/index.php/"  // dev
//let baseApiUrl =  "http://13.126.99.14/gogreen/index.php/"  // dev
//"Mp0s7ZpjVLRknXNfG5qIznDLunSnBH1o71Qe0gxW2pgqm4F3a5MJtpvXNnlp5mNdoErpVZlXpBoMG3QQ9CzC14AOsWeyi1LGGd6C"
let kSecretKey = "Mp0s7ZpjVLRknXNfG5qIznDLunSnBH1o71Qe0gxW2pgqm4F3a5MJtpvXNnlp5mNdoErpVZlXpBoMG3QQ9CzC14AOsWeyi1LGGd6C" ///manjeet Test Account

let kAlertNoNetworkMessage = "A network connection is required. Please verify your network settings & try again."

let kDataBaseName = "GoGreen"
let appDelegate  = UIApplication.shared.delegate as! AppDelegate
let action = "index"
let SIGNUP = "api_v2/sign_up"
let GoogleClientid = "3784685261-fef8n0gnikb67c1e7e7752323edfa1qm.apps.googleusercontent.com"

let AppName = "Go Green"
let LOGIN = "api_v2/Login"
let FORGOTPASSWORD = "api_v2/forget_password"
let get_city = "api_v2/get_city"
let get_locality = "api_v2/get_locality"
let get_street = "api_v2/get_street"
let phone_varification = "api_v2/phone_varification"    
let inser_cardetail = "car_packages_v2/"
let change_password = "api_v2/"
let my_order = "orders_api_v2"
let Orderdetail = "orders_api_v2/"
let car_packages = "car_packages_v2"
let stop_package = "orders_api_v2"

let api = "api_v2/"


extension Notification.Name {
    static let didReceivedPushNofication = Notification.Name("didReceivedPushNofication")
}
