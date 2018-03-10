

//
//  FilterViewController.swift
//  Tick8
//
//  Created by singsys on 21/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

protocol filter {
    func filtered(values: NSDictionary)
}

class FilterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tblView: UITableView!
    var dataDiction = NSMutableDictionary()
    var from = ""
    var delegate:filter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((dataDiction.value(forKey: "nonfilteredArray") == nil) && from == "single") || (dataDiction.value(forKey: "nonDfilteredArray") == nil || dataDiction.value(forKey: "nonAfilteredArray") == nil) && from == "double"
        {
            getDefaultData()
        }
    }
    
    func getDefaultData()
    {
        supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait..")
        
        if from == "single"
        {
            var flightArray = NSMutableArray()
            if dataDiction.value(forKey: "nonfilteredArray") == nil
            {
                flightArray = (dataDiction.value(forKey: "flightList") as! NSArray).mutableCopy() as! NSMutableArray
            }
            else
            {
                flightArray = (dataDiction.value(forKey: "nonfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
            }
            var minPrice:Double = 0.0
            var maxPrice :Double = 0.0
            
            if couponArr.contains("\(((flightArray).object(at: 0) as! NSDictionary).value(forKey: "Source")!)")
            {
                minPrice = Double("\((((flightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                maxPrice =  Double("\((((flightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
            }
            else
            {
               minPrice = Double("\((((flightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
               maxPrice =  Double("\((((flightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
            }
            
            
            let airlineArray:NSMutableArray = NSMutableArray()
            let airlineCode:NSMutableArray = NSMutableArray()
            for n in 0..<flightArray.count
            {
                let dict = (flightArray).object(at: n) as! NSDictionary
                var price:Double = 0.0
       
                if couponArr.contains("\(dict.value(forKey: "Source")!)")
                {
                   price = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)"))!) + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                }
                else
                {
                    price = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!) - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
                }
                
                if ceil(minPrice) > ceil(Double(price))
                {
                    minPrice = ceil(Double(price))
                }
                
                if ceil(maxPrice) < ceil(Double(price))
                {
                    maxPrice = ceil(Double(price))
                }
                
                let carrier_name = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                let carrier_code = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                if !(airlineArray.contains(carrier_name))
                {
                    airlineArray.add(carrier_name)
                    airlineCode.add(carrier_code)
                }
            }
            dataDiction.setValue(airlineCode, forKey: "carrier_code")
            dataDiction.setValue(airlineArray, forKey: "carrier_name")
            dataDiction.setValue(minPrice , forKey: "min_price")
            dataDiction.setValue(maxPrice , forKey: "max_price")
        }
        else
        {
            var DflightArray = NSMutableArray()
            var AflightArray = NSMutableArray()
            
            if dataDiction.value(forKey: "nonDfilteredArray") == nil
            {
                DflightArray = (dataDiction.value(forKey: "departList") as! NSArray).mutableCopy() as! NSMutableArray
            }
            else
            {
                DflightArray = (dataDiction.value(forKey: "nonDfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
            }
            
            if dataDiction.value(forKey: "nonAfilteredArray") == nil
            {
                AflightArray = (dataDiction.value(forKey: "returnList") as! NSArray).mutableCopy() as! NSMutableArray
            }
            else
            {
                AflightArray = (dataDiction.value(forKey: "nonAfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
            }
            
            var minDPrice:Double = 0.0
            var maxDPrice :Double = 0.0
            
            var minAPrice:Double = 0.0
            var maxAPrice :Double = 0.0
            
            if couponArr.contains("\(((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Source")!)")
            {
                minDPrice = Double("\((((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                maxDPrice = Double("\((((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                
                minAPrice = Double("\((((AflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                maxAPrice = Double("\((((AflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")! + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
            }
            else
            {
                minDPrice = Double("\((((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
                maxDPrice = Double("\((((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
                
                minAPrice = Double("\((((AflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
                maxAPrice = Double("\((((AflightArray).object(at: 0) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")! - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
            }
            
            
            let airlineArray:NSMutableArray = NSMutableArray()
            let airlineCode:NSMutableArray = NSMutableArray()
            
            for n in 0..<DflightArray.count
            {
                let dict = (DflightArray).object(at: n) as! NSDictionary
                let price = ("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")
                
                if ceil(minDPrice) > ceil(Double(price)!)
                {
                    minDPrice = ceil(Double(price)!)
                }
                
                if ceil(maxDPrice) < ceil(Double(price)!)
                {
                    maxDPrice = ceil(Double(price)!)
                }
                
                let carrier_name = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                let carrier_code = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                if !(airlineArray.contains(carrier_name))
                {
                    airlineArray.add(carrier_name)
                    airlineCode.add(carrier_code)
                }
            }
            
            for n in 0..<AflightArray.count
            {
                let dict = (AflightArray).object(at: n) as! NSDictionary
                var price:Double = 0.0
                
                if couponArr.contains("\(((DflightArray).object(at: 0) as! NSDictionary).value(forKey: "Source")!)")
                {
                    price = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!) + Double("\(dataDiction.value(forKey: "mark_up_coupon")!)")!
                }
                else
                {
                    price = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!) - Double("\(dataDiction.value(forKey: "mark_down_publish")!)")!
                }
               
                
                if ceil(minAPrice) > ceil(Double(price))
                {
                    minAPrice = ceil(Double(price))
                }
                
                if ceil(maxAPrice) < ceil(Double(price))
                {
                    maxAPrice = ceil(Double(price))
                }
                
                let return_carrier_name = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                
                if !(airlineArray.contains(return_carrier_name))
                {
                    airlineArray.add(return_carrier_name)
                }
            }
            
            if maxAPrice < maxDPrice
            {
                dataDiction.setValue(maxDPrice , forKey: "max_price")
            }
            else
            {
                dataDiction.setValue(maxAPrice , forKey: "max_price")
            }
            
            if minAPrice < minDPrice
            {
                dataDiction.setValue(minAPrice , forKey: "min_price")
            }
            else
            {
                dataDiction.setValue(minDPrice , forKey: "min_price")
            }
            
            dataDiction.setValue(airlineCode, forKey: "carrier_code")
            dataDiction.setValue(airlineArray, forKey: "carrier_name")
        }
        
        supportingfuction.hideProgressHudInView(view: self.view)
        self.tblView.reloadData()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Range Slider

    func rangeSliderValueChanged(_ rangeSlider: RangeSlider) {
        
        let hit = rangeSlider.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        let cell = tblView.cellForRow(at: indexPath!)
        let startLbl = cell?.viewWithTag(1) as! UILabel
        let endLbl = cell?.viewWithTag(2) as! UILabel
        
        let numberFormatter = NumberFormatter()
        numberFormatter.currencyCode = .none
        numberFormatter.groupingSeparator = ","
        numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
        
        if #available(iOS 9.0, *) {
            numberFormatter.numberStyle = NumberFormatter.Style.decimal
        } else {
            // Fallback on earlier versions
        }
        let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(ceil(rangeSlider.lowerValue))))
        let formattedNumber1 = numberFormatter.string(from: NSNumber(value: Int(ceil(rangeSlider.upperValue))))
        startLbl.text = "\("\u{20B9}") \(formattedNumber!)"
        endLbl.text = "\("\u{20B9}") \(formattedNumber1!)"
        
        dataDiction.setValue(String(format:"%.f", rangeSlider.lowerValue), forKey: "filtered_min_price")
        dataDiction.setValue(String(format:"%.f", rangeSlider.upperValue), forKey: "filtered_max_price")
    }

    //MARK:- TableView Delegates
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0
        {
             return 3
        }
        else
        {
            if dataDiction.value(forKey: "carrier_name") != nil
            {
               return (dataDiction.value(forKey: "carrier_name") as! NSArray).count
            }
            return 0
        }
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
       
        if indexPath.section == 0
        {
            if indexPath.row == 0 || indexPath.row == 1
            {
                height = 120
            }
            else if indexPath.row == 2
            {
                height = 30
            }
        }
        else if indexPath.section == 1
        {
            height = 50
        }
        
        return height
    }

    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "rangeCell")!
                let rangeSlidr  = cell.viewWithTag(3) as! RangeSlider
                let minlbl = cell.viewWithTag(1) as! UILabel
                let maxLbl = cell.viewWithTag(2) as! UILabel

                
                let numberFormatter = NumberFormatter()
                numberFormatter.currencyCode = .none
                numberFormatter.groupingSeparator = ","
                numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
                
                if #available(iOS 9.0, *) {
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                } else {
                    // Fallback on earlier versions
                }
                
                if dataDiction.value(forKey: "max_price") != nil
                {
                    rangeSlidr.maximumValue = dataDiction.value(forKey: "max_price") as! Double
                    if dataDiction.value(forKey: "filtered_max_price") == nil
                    {
                        rangeSlidr.upperValue = dataDiction.value(forKey: "max_price") as! Double
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: ceil(dataDiction.value(forKey: "max_price") as! Double)))
                        maxLbl.text =  "\("\u{20B9}") \(formattedNumber!)"
                    }
                    else
                    {
                        rangeSlidr.upperValue = Double("\(dataDiction.value(forKey: "filtered_max_price")!)")!
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double("\(dataDiction.value(forKey: "filtered_max_price")!)")!))
                        maxLbl.text =  "\("\u{20B9}") \(formattedNumber!)"
                    }
                }
                
                if dataDiction.value(forKey: "min_price") != nil
                {
                    rangeSlidr.minimumValue = dataDiction.value(forKey: "min_price") as! Double
                   
                    if dataDiction.value(forKey: "filtered_min_price") == nil
                    {
                        rangeSlidr.lowerValue = dataDiction.value(forKey: "min_price") as! Double
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: ceil(dataDiction.value(forKey: "min_price") as! Double)))
                         minlbl.text =  "\("\u{20B9}") \(formattedNumber!)"
                    }
                    else
                    {
                        rangeSlidr.lowerValue = Double("\(dataDiction.value(forKey: "filtered_min_price")!)")!
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: Double("\(dataDiction.value(forKey: "filtered_min_price")!)")!))
                         minlbl.text =  "\("\u{20B9}") \(formattedNumber!)"
                    }
                }
                
                rangeSlidr.addTarget(self, action: #selector(FilterViewController.rangeSliderValueChanged(_:)), for: .valueChanged)
            }
            else
            if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "stopCell")!
                let stopZ = cell.viewWithTag(1) as! UIButton
                let stopZLbl = cell.viewWithTag(2) as! UILabel
                let stopZLblS = cell.viewWithTag(3) as! UILabel
                let stopO = cell.viewWithTag(4) as! UIButton
                let stopOLbl = cell.viewWithTag(5) as! UILabel
                let stopOLblS = cell.viewWithTag(6) as! UILabel
                let stopOM = cell.viewWithTag(7) as! UIButton
                let stopOMLbl = cell.viewWithTag(8) as! UILabel
                let stopOMLblS = cell.viewWithTag(9) as! UILabel
                
                stopZ.layer.cornerRadius = 5
                stopO.layer.cornerRadius = 5
                stopOM.layer.cornerRadius = 5
                
                if dataDiction.value(forKey: "stop") != nil && dataDiction.value(forKey: "stop") as! String == "stopZero"
                {
                    stopZ.isSelected = true
                    stopZ.layer.borderWidth = 2
                    stopZ.layer.shadowOpacity = 0
                    stopZ.layer.borderColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    stopZLbl.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)
                    stopZLblS.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)
                    
                    stopO.layer.borderWidth = 1
                    stopO.layer.masksToBounds =  false
                    stopO.layer.borderColor = UIColor.lightGray.cgColor
                    stopO.layer.shadowColor = UIColor.darkGray.cgColor
                    stopO.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopO.layer.shadowOpacity = 0.5
                    stopO.layer.shadowRadius = 2
                    stopO.isSelected = false
                    stopOLbl.textColor = UIColor.darkGray
                    stopOLblS.textColor = UIColor.darkGray
                    
                    stopOM.layer.borderWidth = 1
                    stopOM.layer.masksToBounds =  false
                    stopOM.layer.borderColor = UIColor.lightGray.cgColor
                    stopOM.layer.shadowColor = UIColor.darkGray.cgColor
                    stopOM.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopOM.layer.shadowOpacity = 0.5
                    stopOM.layer.shadowRadius = 2
                    stopOM.isSelected = false
                    stopOMLbl.textColor = UIColor.darkGray
                    stopOMLblS.textColor = UIColor.darkGray
                    

                }
                else if dataDiction.value(forKey: "stop") != nil && dataDiction.value(forKey: "stop") as! String == "stopOne"
                {
                    stopO.isSelected = true
                    stopO.layer.borderWidth = 2
                    stopO.layer.shadowOpacity = 0
                    stopO.layer.borderColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    stopOLbl.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)
                    stopOLblS.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)
                    
                    stopZ.layer.borderWidth = 1
                    stopZ.layer.masksToBounds =  false
                    stopZ.layer.borderColor = UIColor.lightGray.cgColor
                    stopZ.layer.shadowColor = UIColor.darkGray.cgColor
                    stopZ.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopZ.layer.shadowOpacity = 0.5
                    stopZ.layer.shadowRadius = 2
                    stopZ.isSelected = false
                    stopZLbl.textColor = UIColor.darkGray
                    stopZLblS.textColor = UIColor.darkGray
                    
                    stopOM.layer.borderWidth = 1
                    stopOM.layer.masksToBounds =  false
                    stopOM.layer.borderColor = UIColor.lightGray.cgColor
                    stopOM.layer.shadowColor = UIColor.darkGray.cgColor
                    stopOM.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopOM.layer.shadowOpacity = 0.5
                    stopOM.layer.shadowRadius = 2
                    stopOM.isSelected = false
                    stopOMLbl.textColor = UIColor.darkGray
                    stopOMLblS.textColor = UIColor.darkGray

                }
                else if dataDiction.value(forKey: "stop") != nil && dataDiction.value(forKey: "stop") as! String == "stopOneMore"
                {
                    stopOM.isSelected = true
                    stopOM.layer.borderWidth = 2
                    stopOM.layer.shadowOpacity = 0
                    stopOM.layer.borderColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    stopOMLbl.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)
                    stopOMLblS.textColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0)

                    stopZ.layer.borderWidth = 1
                    stopZ.layer.masksToBounds =  false
                    stopZ.layer.borderColor = UIColor.lightGray.cgColor
                    stopZ.layer.shadowColor = UIColor.darkGray.cgColor
                    stopZ.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopZ.layer.shadowOpacity = 0.5
                    stopZ.layer.shadowRadius = 2
                    stopZ.isSelected = false
                    stopZLbl.textColor = UIColor.darkGray
                    stopZLblS.textColor = UIColor.darkGray
                    
                    stopO.layer.borderWidth = 1
                    stopO.layer.masksToBounds =  false
                    stopO.layer.borderColor = UIColor.lightGray.cgColor
                    stopO.layer.shadowColor = UIColor.darkGray.cgColor
                    stopO.layer.shadowOffset = CGSize(width: 1, height: 1)
                    stopO.layer.shadowOpacity = 0.5
                    stopO.layer.shadowRadius = 2
                    stopO.isSelected = false
                    stopOLbl.textColor = UIColor.darkGray
                    stopOLblS.textColor = UIColor.darkGray
                }
                else
                {
                    stopOM.layer.borderWidth = 1
                    stopOM.layer.masksToBounds =  false
                    stopOM.layer.borderColor = UIColor.lightGray.cgColor
                    stopOM.layer.shadowColor = UIColor.darkGray.cgColor
                    stopOM.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                    stopOM.layer.shadowOpacity = 0.5
                    stopOM.layer.shadowRadius = 2
                    stopOM.backgroundColor = UIColor.white
                    stopOMLbl.textColor = UIColor.darkGray
                    stopOMLblS.textColor = UIColor.darkGray
                    
                    stopZ.layer.borderWidth = 1
                    stopZ.layer.masksToBounds =  false
                    stopZ.layer.borderColor = UIColor.lightGray.cgColor
                    stopZ.layer.shadowColor = UIColor.darkGray.cgColor
                    stopZ.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                    stopZ.layer.shadowOpacity = 0.5
                    stopZ.layer.shadowRadius = 2
                    stopZ.backgroundColor = UIColor.white
                    stopZLbl.textColor = UIColor.darkGray
                    stopZLblS.textColor = UIColor.darkGray

                    
                    stopO.layer.borderWidth = 1
                    stopO.layer.masksToBounds =  false
                    stopO.layer.borderColor = UIColor.lightGray.cgColor
                    stopO.layer.shadowColor = UIColor.darkGray.cgColor
                    stopO.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
                    stopO.layer.shadowOpacity = 0.5
                    stopO.layer.shadowRadius = 2
                    stopO.backgroundColor = UIColor.white
                    stopOLbl.textColor = UIColor.darkGray
                    stopOLblS.textColor = UIColor.darkGray

                }
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "airCell")!
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "airlineCell")!
            let imgView = cell.viewWithTag(1) as! UIImageView
            let airname = cell.viewWithTag(2) as! UILabel
            let checkBtn = cell.viewWithTag(3) as! UIButton
            checkBtn.layer.cornerRadius = checkBtn.frame.width/2
            checkBtn.isSelected = false
            
            if dataDiction.value(forKey: "carrier_name") != nil
            {
                airname.text = (dataDiction.value(forKey: "carrier_name") as! NSArray).object(at: indexPath.row) as? String
                imgView.image = UIImage(named: ((dataDiction.value(forKey: "carrier_code") as! NSArray).object(at: indexPath.row) as? String)!)
            }
            
            if imgView.image == nil
            {
                imgView.image = #imageLiteral(resourceName: "default_airline")
            }
            
            if dataDiction.value(forKey: "selected_carrier_name") != nil && ((dataDiction.value(forKey: "selected_carrier_name") as! NSArray).contains("\((dataDiction.value(forKey: "carrier_name") as! NSArray).object(at: indexPath.row))"))
            {
                checkBtn.isSelected = true
            }
        }
        return cell
    }
    
    
    @IBAction func stopBtn(_ sender: UIButton) {
        
        if sender.tag == 1
        {
            dataDiction.setValue("stopZero", forKey: "stop")
        }
        else if sender.tag == 4
        {
            dataDiction.setValue("stopOne", forKey: "stop")
        }
        else if sender.tag == 7
        {
            dataDiction.setValue("stopOneMore", forKey: "stop")
        }
        self.tblView.reloadData()
    }
    
    @IBAction func filterBtn(_ sender: UIButton) {
        delegate.filtered(values: dataDiction)
//        if dataDiction.value(forKey: "filtered_max_price") != nil{
//            dataDiction.removeObject(forKey: "filtered_max_price")
//        }
//        if dataDiction.value(forKey: "filtered_min_price") != nil{
//            dataDiction.removeObject(forKey: "filtered_min_price")
//        }
//        if dataDiction.value(forKey: "max_price") != nil{
//            dataDiction.removeObject(forKey: "max_price")
//        }
//        if dataDiction.value(forKey: "min_price") != nil{
//            dataDiction.removeObject(forKey: "min_price")
//        }
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectBtn(_ sender: UIButton)
    {
        let hit = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        var arr:NSMutableArray = NSMutableArray()
        
        if dataDiction.value(forKey: "selected_carrier_name") == nil
        {
            dataDiction.setValue(arr, forKey: "selected_carrier_name")
        }
        else
        {
            arr = (dataDiction.value(forKey: "selected_carrier_name") as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        if dataDiction.value(forKey: "selected_carrier_name") != nil && (arr.contains("\((dataDiction.value(forKey: "carrier_name") as! NSArray).object(at: (indexPath?.row)!))"))
        {
            (arr).remove("\((dataDiction.value(forKey: "carrier_name") as! NSArray).object(at: (indexPath?.row)!))")
        }
        else
        {
            
            arr.add("\((dataDiction.value(forKey: "carrier_name") as! NSArray).object(at: (indexPath?.row)!))")
        }
        
        self.dataDiction.setValue(arr, forKey: "selected_carrier_name")
        self.tblView.reloadRows(at: [(indexPath)!], with: .none)
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resetBtn(_ sender: UIButton) {
        dataDiction.removeObject(forKey: "selected_carrier_name")
        dataDiction.removeObject(forKey: "filtered_min_price")
        dataDiction.removeObject(forKey: "filtered_max_price")
        dataDiction.removeObject(forKey: "stop")
        
        
        if dataDiction.value(forKey: "nonfilteredArray") != nil && from == "single"
        {
            dataDiction.setValue(dataDiction.value(forKey: "nonfilteredArray") as! NSArray, forKey: "flightList")
        }
        else if from == "double"
        {
            if  dataDiction.value(forKey: "nonDfilteredArray") != nil
            {
                dataDiction.setValue(dataDiction.value(forKey: "nonDfilteredArray") as! NSArray, forKey: "departList")
            }
            
            if  dataDiction.value(forKey: "nonAfilteredArray") != nil
            {
                dataDiction.setValue(dataDiction.value(forKey: "nonAfilteredArray") as! NSArray, forKey: "returnList")
            }
        }
        
        self.tblView.reloadData()
    }
}
