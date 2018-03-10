//
//  LoginView.swift
//  getAvis
//
//  Created by SS142 on 01/08/16.
//  Copyright © 2016 SS142. All rights reserved.
//singsys.enterprise.

import Foundation
// Development Server

//let BASE_URL      = "http://115.249.91.204/tick8/public/"
//let BOOK_URL = "http://api.tektravels.com/BookingEngineService_Air/AirService.svc/rest/"
//production server
let BASE_URL      = "https://tick8.in/"
let BOOK_URL = "https://tboapi.travelboutiqueonline.com/AirAPI_V10/AirService.svc/rest/" //live API URL

//let BASE_URL      = "http://103.15.232.35/singsys-stg3/tick8/public/"
//staging server
//test API URL

let appDel = UIApplication.shared.delegate as! AppDelegate

let validEmail           = "Please enter valid email id."
let emptyPassword        = "Please enter password."
let validPassword        = "Password must be of at least 8 characters and maximum of 20 characters."
let validLoginPassword   = "Invalid Password."
let validConfirmPassword = "Password must be of at least 8 characters and maximum of 20 characters."
let pass                 = "Password and Confirm Password should match."
let Samephone            = "This mobile number already exists."

// signup msg
let enterFirstName   = "Please enter first name."
let enterLastName    = "Please enter last name."
let enterOtp         = "Please enter OTP."
let enterEmailMob    = "Please enter your Email Id or mobile number."
let enterEmail       = "Please enter your email id."
let enterCountryCode = "Please select your country code."
let enterMobileNum   = "Please enter mobile number."
let validMobileNum   = "Mobile Number must be of at least 8 characters and maximum of 14 characters."
let enterPassword    = "Please enter password."

//password change
let currentPass      = "Please enter your old password."
let validOldPassword = "Password must be of at least 8 characters and maximum of 20 characters."
let newPass          = "Please enter your new password."
let validNewPassword = "Password must be of at least 8 characters and maximum of 20 characters."
let conPass          = "Please retype your new password."
let Samepass         = "New Password and Retype Password should match."
let emptyProfile     = "Please upload your profile image."
let message = "Please enter message."
let device  = UIDevice.current.model

//passenger detail screen
let passenger_title = "Please select title."
let first_name = "Enter passenger's first name."
let limit_first_name = "Passenger's first name should be minimum of 2 characters and maximum of 32 characters."
let last_name  = "Enter passenger's last name."
let limit_last_name = "Passenger's last name should be minimum of 2 characters and maximum of 32 characters."
let not_match_name = "Passenger's first name and last name cannot be same."
let dob = "Enter passenger's date of birth."
let passport_number = "Enter passenger's passport number."
let passport_expiry = "Enter passenger's passport expiry date."

//homeview
let selectDepartCity = "Please select departure city."
let selectArriveCity = "Please select arrival city."
let selectDepartDate = "Please select departure date."
let selectArriveDate = "Please select arrival date."
let selectPassengers = "Please select number of adult(s)/children."
let selectClass      = "Please select class Type."
let selectCities     = "Please select cities first."
let differentCities  = "Both cities cannot be same, please select different cities."
let infants          = "Number of Infant cannot exceed the number of Adults."
let passengerlimit   = "Total number of passenger count can not be more than 9."

//API variables
let couponArr = ["24","25","26","30","31","32"]
let corporateArr = ["36","37","38"]

let fare_class:NSDictionary = [
    "A" : "First",// Discounted
    "B" : "Economy",///Coach
    "C" : "Business",
    "D" : "Business",// Discounted
    "E" : "Shuttle",
    "F" : "First",
    "G" : "Conditional",
    "H" : "Economy",
    "I" : "Business",///Coach Discounted
    "J" : "Business",
    "K" : "Economy",///Coach Discounted
    "L" : "Economy",///Coach Discounted
    "M" : "Economy",///Coach Discounted
    "N" : "Economy",///Coach Discounted
    "O" : "Economy",
    "P" : "First",
    "Q" : "Economy",///Coach Discounted
    "R" : "First",// Suite or Supersonic (discontinued)
    "S" : "Economy",///Coach
    "T" : "Economy",///Coach Discounted
    "U" : "Shuttle",
    "V" : "Economy",///Coach Discounted
    "W" : "Economy",///Coach Premium
    "X" : "Economy",///Coach Discounted
    "Y" : "Economy",///Coach
    "Z" : "Business",// Discounted
]

class CommonValidations: NSObject
{
    //MARK: Validate Email
    class func isValidEmail(testStr:String) -> Bool
    {
        
        let emailRegEx = "(?:[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[A-Za-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?\\.)+[A-Za-z0-9](?:[A-Za-z0-9-]*[A-Za-z0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[A-Za-z0-9-]*[A-Za-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: testStr)
    }
    
    class func isValidPassword(testStr:String) -> Bool
    {
        let passwordRegex:String = "(?=.*[0-9])(?=.*[a-z])(?=.*[A-Z])(?=.*[!#$%&'*+,-./:;<=>?@|~]).{8,15}"
        let passTest = NSPredicate(format:"SELF MATCHES %@", passwordRegex)
        
        return passTest.evaluate(with: testStr)
    }
    
    
    class func isValidNO(testStr:String, range: Int) -> Bool
    {
        if testStr.count < range
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    class func numberLimit(testStr:String, min: Int, max: Int) -> Bool
    {
        if testStr.count < min || testStr.count > max
        {
            return false
        }
        else
        {
            return true
        }
        
    }
    
    //MARK: Get The Color From RGB
    
    class func isValidDate(from: Date, until: Date, flag: Int) -> Bool
    {
        var value:Bool! = Bool()
        
        switch from.compare(until)
        {
        case .orderedAscending     :
            value = true
            
        case .orderedDescending    :
            value = false
            
        case .orderedSame          :
            value = true
            
        }
        
        if flag == 0
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            let from1 : NSString = dateFormatter.string(from: from) as NSString
            let until1 : NSString = dateFormatter.string(from: until) as NSString
            
            if from1 == until1
            {
                value = false
            }
            
        }
        return value
    }
    func attributedTexts(text1: String, attribs1: [String : Any]?, text2: String, attribs2: [String : Any]?) -> NSMutableAttributedString {
        
        let str = NSMutableAttributedString(string: "\(text1)  ", attributes: attribs1);
        str.append(NSAttributedString(string: text2, attributes: attribs2))
        return str
    }
    
    func attributedTextsNew(text1: String, attribs1: [String : Any]?, text2: String, attribs2: [String : Any]?, text3: String, attribs3: [String : Any]?,text4: String, attribs4: [String : Any]?) -> NSMutableAttributedString {
        
        let str = NSMutableAttributedString(string: "\(text1)  ", attributes: attribs1);
        str.append(NSAttributedString(string: text2, attributes: attribs2))
        str.append(NSAttributedString(string: text3, attributes: attribs3))
        str.append(NSAttributedString(string: text4, attributes: attribs4))
        return str
    }
    
}
