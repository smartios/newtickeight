//
//  TransactionDetailViewController.swift
//  Tick8
//
//  Created by SL-167 on 11/1/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class TransactionDetailViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var dataDic = NSMutableDictionary()
    @IBOutlet var tblView: UITableView!
    @IBOutlet var headerView: UIView!
    @IBOutlet var transView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tblView.isHidden = true
        self.headerView.isHidden = true
        self.transView.isHidden = true
        
        getFlightDetail()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    func setValues()
    {
        //for transaction id view
        let translbl = transView.viewWithTag(1) as! UILabel
        
        let pnrlbl = transView.viewWithTag(-1) as! UILabel
        
        var text3 = ""
        
        
        if (dataDic.value(forKey: "PNR1")) != nil
        {
            // return flight
            
            if  (dataDic.value(forKey: "PNR") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != "" && (dataDic.value(forKey: "PNR1") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != ""
            {
                text3 = "PNR: \(dataDic.value(forKey: "PNR") as! String) - \(dataDic.value(forKey: "PNR1") as! String)"
            }
            else if (dataDic.value(forKey: "PNR") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != "" && (dataDic.value(forKey: "PNR1") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
              text3 = "PNR: \(dataDic.value(forKey: "PNR") as! String) - N/A"
            }
            else if (dataDic.value(forKey: "PNR") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "" && (dataDic.value(forKey: "PNR1") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != ""
            {
              text3 = "PNR: N/A - \(dataDic.value(forKey: "PNR1") as! String)"
            }
        }else
        {
            // single flight
            if let x = (dataDic.value(forKey: "PNR") as? String)
            {
                 text3 = "PNR: \(x)"
            }else
            {
               text3 = "PNR: N/A"
            }
        }
        
        let range3 = (text3 as NSString).range(of: "PNR:")
        let attributedString3 = NSMutableAttributedString(string: text3)
        attributedString3.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range3)
        pnrlbl.attributedText = attributedString3
        
        
        
        let status = transView.viewWithTag(2) as! UILabel
        let text = "Transaction ID: \(dataDic.value(forKey: "payment_api_token")!)"
        let range = (text as NSString).range(of: "Transaction ID:")
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range)
        translbl.attributedText = attributedString
        
        
        var text1: NSString = "Status: "
        let range1 = (text1 as NSString).range(of: "Status:")
        var range2 = (text1 as NSString).range(of: " ")
        var attributedString1 = NSMutableAttributedString(string: text1 as String)
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range1)
        
        if dataDic.value(forKey: "selected_transaction") != nil && "\(dataDic.value(forKey: "selected_transaction")!)" == "1"
        {
            text1 = text1.appending("Planned") as NSString
            range2 = (text1 as NSString).range(of: "Planned")
            attributedString1 = NSMutableAttributedString(string: text1 as String)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "ffc411") , range: range2)
        }
        else if dataDic.value(forKey: "selected_transaction") != nil && "\(dataDic.value(forKey: "selected_transaction")!)" == "2"
        {
            text1 = text1.appending("Completed") as NSString
            range2 = (text1 as NSString).range(of: "Completed")
            attributedString1 = NSMutableAttributedString(string: text1 as String)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "17c175") , range: range2)
        }
        else if dataDic.value(forKey: "selected_transaction") != nil && "\(dataDic.value(forKey: "selected_transaction")!)" == "3"
        {
            text1 = text1.appending("Cancelled") as NSString
            range2 = (text1 as NSString).range(of: "Cancelled")
            attributedString1 = NSMutableAttributedString(string: text1 as String)
            attributedString1.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "ed5d52") , range: range2)
        }
        
        status.attributedText = attributedString1
        status.adjustsFontSizeToFitWidth = true
        translbl.adjustsFontSizeToFitWidth = true
        //for header view
        let Dcity = headerView.viewWithTag(1) as! UILabel
        let Acity = headerView.viewWithTag(2) as! UILabel
        let passenger = headerView.viewWithTag(3) as! UILabel
        let dateTxt = headerView.viewWithTag(4) as! UILabel
        let economy = headerView.viewWithTag(5) as! UILabel
        let img = headerView.viewWithTag(11) as! UIImageView
        
        if dataDic.value(forKey: "flights") != nil && dataDic.value(forKey: "flights") is NSArray && (dataDic.value(forKey: "flights") as! NSArray).count > 0
        {
            let df = DateFormatter()
            df.locale =  Locale(identifier: "en_US_POSIX")
            let df1 = DateFormatter()
            df1.locale =  Locale(identifier: "en_US_POSIX")
            
            df1.dateFormat = "dd MMM"
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            
            if "\(dataDic.value(forKey: "booking_type")!)" == "one-way"
            {
                if !(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date") is NSNull)
                {
                    let date = "\(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date")!)"
                    dateTxt.text = "\(df1.string(from: df.date(from: date)!))"
                }
                img.image = #imageLiteral(resourceName: "oneWayD")
            }
            else if "\(dataDic.value(forKey: "booking_type")!)" == "round-trip"
            {
                let date = (!(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date") is NSNull) ? "\(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date")!)" : "")
                
                var date1 = ""
                
                if (dataDic.value(forKey: "flights") as! NSArray).count != 2 && dataDic.value(forKey: "international_return_time") != nil
                {
                    date1 = "\(dataDic.value(forKey: "international_return_time")!)"
                }
                else if (dataDic.value(forKey: "flights") as! NSArray).count == 2 && !(((dataDic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "depart_date") is NSNull)
                {
                    date1 = "\(((dataDic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "depart_date")!)"
                }
                
                dateTxt.text = ((date1 != "") ? "\(df1.string(from: df.date(from: date)!))-\(df1.string(from: df.date(from: date1)!))" : "\(df1.string(from: df.date(from: date)!))")
                
                img.image =  #imageLiteral(resourceName: "twoWay")
            }
            
            Dcity.text = (((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "from_city_code")! is NSNull) ? "" : "\(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "from_city_code")!)"
            Acity.text = (((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "to_city_code")! is NSNull) ? "" : "\(((dataDic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "to_city_code")!)"
        }
        
        
        if (dataDic.value(forKey: "flightDetail") != nil) && ((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FareClass") != nil && ((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FareClass") is String
        {
            for i in fare_class.allKeys
            {
                if "\(i)" == "\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FareClass")!)"
                {
                    economy.text = fare_class.value(forKey: "\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FareClass")!)") as? String
                }
            }
            
            passenger.text = "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count) Pax"
            passenger.adjustsFontSizeToFitWidth = true
        }
        
        dateTxt.adjustsFontSizeToFitWidth = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- tableview functions
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header:UIView = (Bundle.main.loadNibNamed("flightHeader", owner: self, options: nil)![0] as? UIView)!
        header.backgroundColor = UIColor.clear
        header.backgroundColor = UIColor(red: 245/255, green: 250/255, blue: 255/255, alpha: 1.0)
        let cityLbl = header.viewWithTag(1) as! UILabel
        let durationLbl = header.viewWithTag(2) as! UILabel
        let dateLbl = header.viewWithTag(3) as! UILabel
        var dic = NSMutableDictionary()
        
        if section == 0 && dataDic.value(forKey: "flightDetail") != nil
        {
            if (dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Origin") != nil && (dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Destination") != nil
            {
                cityLbl.text = "\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Origin")!) - \((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Destination")!)"
            }
            
            dic = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        else if dataDic.value(forKey: "flightDetail1") != nil && section == 1
        {
            if (dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Origin") != nil && (dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Destination") != nil
            {
                cityLbl.text = "\((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Destination")!) - \((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Origin")!)"
            }
            
            dic = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        if dic.count > 0
        {
            let df = DateFormatter()
            let df1 = DateFormatter()
            //&& "\(dataDic.value(forKey: "selected_transaction")!)" == "2"
            df1.dateFormat = "hh:mm a"
            df1.amSymbol = "AM"
            df1.pmSymbol = "PM"
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            
            
            if (((section == 0 && (dataDic.value(forKey: "DepartCancel") == nil || "\(dataDic.value(forKey: "DepartCancel")!)" == "0")) || (section == 1 && (dataDic.value(forKey: "ArriveCancel") == nil || "\(dataDic.value(forKey: "ArriveCancel")!)" == "0"))) && (dataDic.value(forKey: "international_return_time") == nil)) || ((dataDic.value(forKey: "DepartCancel") == nil || "\(dataDic.value(forKey: "DepartCancel")!)" == "0") && (dataDic.value(forKey: "international_return_time") != nil))
            {
                durationLbl.textColor = supportingfuction.hexStringToUIColor(hex: "353535")
                durationLbl.font = UIFont(name: "Arimo-Bold", size: 11)
                
                let dur:Int = Int(df.date(from: ((((dic.value(forKey: "Segments") as! NSArray)).object(at: ((dic.value(forKey: "Segments") as! NSArray)).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dic.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                let hours:Int = dur/3600
                let minutes = (dur - (hours * 3600))/60
                
                if hours < 10 && minutes == 0
                {
                    durationLbl.text = "0\(hours)hrs"
                }
                else if hours < 10 && minutes < 10
                {
                    durationLbl.text = "0\(hours)h 0\(minutes)min"
                }
                else if hours > 9 && minutes == 0
                {
                    durationLbl.text = "\(hours)hrs"
                }
                else if hours > 9 && minutes < 10
                {
                    durationLbl.text = "\(hours)h 0\(minutes)min"
                }
                else if hours < 10 && minutes > 9
                {
                    durationLbl.text = "0\(hours)h \(minutes)min"
                }
                else
                {
                    durationLbl.text = "\(hours)h \(minutes)min"
                }
            }
            else
            {
                header.backgroundColor = UIColor.clear
                header.backgroundColor = supportingfuction.hexStringToUIColor(hex: "ffefef")
                durationLbl.textColor = supportingfuction.hexStringToUIColor(hex: "ed5d52")
                durationLbl.numberOfLines = 0
                durationLbl.font = UIFont(name: "Arimo", size: 11)
                
                if ((dataDic.value(forKey: "DepartCancel") == nil || "\(dataDic.value(forKey: "DepartCancel")!)" == "1")) || ((dataDic.value(forKey: "ArriveCancel") == nil || "\(dataDic.value(forKey: "ArriveCancel")!)" == "1"))
                {
                    durationLbl.text = "Cancellation\nPending"
                }
                else if ((dataDic.value(forKey: "DepartCancel") == nil || "\(dataDic.value(forKey: "DepartCancel")!)" == "4")) || ((dataDic.value(forKey: "ArriveCancel") == nil || "\(dataDic.value(forKey: "ArriveCancel")!)" == "4"))
                {
                    durationLbl.text = "Cancellation\nSuccessful"
                }
            }
            
            df1.dateFormat = "dd MMM"
            dateLbl.text = "\(df1.string(from:  df.date(from: ((((dic.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))"
        }
        else
        {
            header.isHidden = true
        }
        return header
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 || ((dataDic.value(forKey: "flightDetail1") != nil) && section == 1)
        {
            return 35
        }
        return 0
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var num = 3
        
        if dataDic.value(forKey: "flightDetail1") != nil && dataDic.value(forKey: "flightDetail") != nil
        {
            num = num + 1
        }
        
        //        if ((dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "4") || (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "4"))
        //        {
        //            num = num + 1
        //        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var num = 0
        
        
        if (dataDic.value(forKey: "flightDetail") != nil)
        {
            if section == 0
            {
                num = (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count
            }
            else if dataDic.value(forKey: "flightDetail1") != nil && section == 1
            {
                num = (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count
            }
            else if (dataDic.value(forKey: "flightDetail1") != nil && section == 2) || (dataDic.value(forKey: "flightDetail1") == nil && section == 1)
            {
                num = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count + 1
            }
            else if (dataDic.value(forKey: "flightDetail1") != nil && section == 3) || (dataDic.value(forKey: "flightDetail1") == nil && section == 2)
            {
                if (dataDic.value(forKey: "selected_transaction") != nil && "\(dataDic.value(forKey: "selected_transaction")!)" == "1") && ((dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "0") || (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "0"))
                {
                    num = 10
                }
                else
                {
                    num = 9
                }
                
                if dataDic.value(forKey: "unsuccessful_booking_amount") != nil
                {
                    num = num + 1
                }
            }
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 90
        
        if (dataDic.value(forKey: "flightDetail") != nil)
        {
            if indexPath.section == 0
            {
                if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 145
                }
            }
            else if dataDic.value(forKey: "flightDetail1") != nil && indexPath.section == 1
            {
                if indexPath.row < (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 145
                }
            }
            else
            {
                if indexPath.row == 0
                {
                    height = 45
                }
                else if ((dataDic.value(forKey: "flightDetail1") != nil && indexPath.section == 3) || (dataDic.value(forKey: "flightDetail1") == nil && indexPath.section == 2)) && ((indexPath.row == 9 && dataDic.value(forKey: "unsuccessful_booking_amount") == nil) || (indexPath.row == 10 && dataDic.value(forKey: "unsuccessful_booking_amount") != nil))
                {
                    height = 70
                }
                else if ((dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "4") || (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "4")) && ((indexPath.row == 8 && dataDic.value(forKey: "unsuccessful_booking_amount") == nil) || (indexPath.row == 9 && dataDic.value(forKey: "unsuccessful_booking_amount") != nil))
                    
                {
                    height = 100
                }
                else
                {
                    height = 35
                }
            }
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "tripCell")!
            
            let Dtimelbl = cell.viewWithTag(1) as! UILabel
            let DurationLbl = cell.viewWithTag(2) as! UILabel
            let Atimelbl = cell.viewWithTag(3) as! UILabel
            let DaddressLbl = cell.viewWithTag(4) as! UILabel
            let DcityLbl = cell.viewWithTag(9) as! UILabel
            let AcityLbl = cell.viewWithTag(10) as! UILabel
            let baggageLbl = cell.viewWithTag(5) as! UILabel
            let aAddresslbl = cell.viewWithTag(6) as! UILabel
            let layOverLbl = cell.viewWithTag(7) as! UILabel
            let layOverView = cell.viewWithTag(8)!
            let img = cell.viewWithTag(11) as! UIImageView
            
            if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count && dataDic.value(forKey: "flightDetail") != nil
            {
                let dict = dataDic.value(forKey: "flightDetail") as! NSDictionary
                let df = DateFormatter()
                let df1 = DateFormatter()
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                    df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                
               
                
                Dtimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                Atimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey:
                    "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                
                let hours:Int = dur/3600
                let minutes = (dur - (hours * 3600))/60
                
                if hours < 10 && minutes == 0
                {
                    DurationLbl.text = "0\(hours)hrs"
                }
                else if hours < 10 && minutes < 10
                {
                    DurationLbl.text = "0\(hours)h 0\(minutes)min"
                }
                else if hours > 9 && minutes == 0
                {
                    DurationLbl.text = "\(hours)hrs"
                }
                else if hours > 9 && minutes < 10
                {
                    DurationLbl.text = "\(hours)h 0\(minutes)min"
                }
                else if hours < 10 && minutes > 9
                {
                    DurationLbl.text = "0\(hours)h \(minutes)min"
                }
                else
                {
                    DurationLbl.text = "\(hours)h \(minutes)min"
                }
                
                var baggage = String()
                if((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Baggage") != nil && !((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Baggage")) is NSNull))
                {
                    img.isHidden = false
                    let str = ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Baggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage = "\(str)s check in baggage"
                    }
                    else
                    {
                        baggage = "\(str) check in baggage"
                    }
                }
                else
                {
                    img.isHidden = true
                }
                
                if((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") != nil && !(((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage")) is NSNull))
                {
                    img.isHidden = false
                    let str = ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage.append(" | \(str)s hand baggage")
                    }
                    else
                    {
                        baggage.append(" | \(str) hand baggage")
                    }
                }
                else
                {
                    img.isHidden = true
                }
                
                baggageLbl.text = baggage
                
                DaddressLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                aAddresslbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                DcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                DcityLbl.adjustsFontSizeToFitWidth = true
                
                AcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                AcityLbl.adjustsFontSizeToFitWidth = true
                
                
                if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count - 1
                {
                    for layer in layOverView.layer.sublayers!
                    {
                        if layer.name == "Layer1"
                        {
                            layer.removeFromSuperlayer()
                        }
                    }
                    let layOverViewBorder = CAShapeLayer()
                    layOverViewBorder.name = "Layer1"
                    layOverViewBorder.fillColor = UIColor.clear.cgColor
                    layOverViewBorder.strokeColor = UIColor.lightGray.cgColor
                    layOverViewBorder.lineDashPattern = [4, 7]
                    layOverViewBorder.frame = layOverView.bounds
                    layOverViewBorder.path = UIBezierPath(roundedRect: layOverView.bounds, cornerRadius: 10).cgPath
                    layOverView.layer.addSublayer(layOverViewBorder)
                    layOverView.backgroundColor = UIColor.white
                    
                    
                    let layovertime = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row+1) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!.timeIntervalSince( df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey:"Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!))
                    
                    let hourslayover:Int = layovertime/3600
                    let minuteslayover = (layovertime - (hourslayover * 3600))/60
                    
                    if hourslayover < 10 && minuteslayover == 0
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)hrs"
                    }
                    else if hourslayover < 10 && minuteslayover < 10
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)h 0\(minuteslayover)min"
                    }
                    else if hourslayover > 9 && minuteslayover == 0
                    {
                        layOverLbl.text = "Layover: \(hourslayover)hrs"
                    }
                    else if hourslayover > 9 && minuteslayover < 10
                    {
                        layOverLbl.text = "Layover: \(hourslayover)h 0\(minuteslayover)min"
                    }
                    else if hourslayover < 10 && minuteslayover > 9
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)h \(minuteslayover)min"
                    }
                    else
                    {
                        layOverLbl.text = "Layover: \(hourslayover)h \(minuteslayover)min"
                    }
                }
            }
            
            DurationLbl.adjustsFontSizeToFitWidth = true
            Atimelbl.adjustsFontSizeToFitWidth = true
            Dtimelbl.adjustsFontSizeToFitWidth = true
            baggageLbl.adjustsFontSizeToFitWidth = true
        }
        else if dataDic.value(forKey: "flightDetail1") != nil && indexPath.section == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "tripCell")!
            let Dtimelbl = cell.viewWithTag(1) as! UILabel
            let DurationLbl = cell.viewWithTag(2) as! UILabel
            let Atimelbl = cell.viewWithTag(3) as! UILabel
            let DaddressLbl = cell.viewWithTag(4) as! UILabel
            let DcityLbl = cell.viewWithTag(9) as! UILabel
            let AcityLbl = cell.viewWithTag(10) as! UILabel
            let baggageLbl = cell.viewWithTag(5) as! UILabel
            let aAddresslbl = cell.viewWithTag(6) as! UILabel
            let layOverLbl = cell.viewWithTag(7) as! UILabel
            let layOverView = cell.viewWithTag(8)!
            let img = cell.viewWithTag(11) as! UIImageView
            
            if indexPath.row < (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count && dataDic.value(forKey: "flightDetail1") != nil
            {
                let dict = dataDic.value(forKey: "flightDetail1") as! NSDictionary
                let df = DateFormatter()
                let df1 = DateFormatter()
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                
                Dtimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                Atimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey:"Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                
                let hours:Int = dur/3600
                let minutes = (dur - (hours * 3600))/60
                
                if hours < 10 && minutes == 0
                {
                    DurationLbl.text = "0\(hours)hrs"
                }
                else if hours < 10 && minutes < 10
                {
                    DurationLbl.text = "0\(hours)h 0\(minutes)min"
                }
                else if hours > 9 && minutes == 0
                {
                    DurationLbl.text = "\(hours)hrs"
                }
                else if hours > 9 && minutes < 10
                {
                    DurationLbl.text = "\(hours)h 0\(minutes)min"
                }
                else if hours < 10 && minutes > 9
                {
                    DurationLbl.text = "0\(hours)h \(minutes)min"
                }
                else
                {
                    DurationLbl.text = "\(hours)h \(minutes)min"
                }
                
                var baggage = String()
                if((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Baggage") != nil && !(((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Baggage")) is NSNull))
                {
                    img.isHidden = false
                    let str = ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Baggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage = "\(str)s check in baggage"
                    }
                    else
                    {
                        baggage = "\(str) check in baggage"
                    }
                }
                else
                {
                    img.isHidden = true
                }
                
                if((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") != nil && !(((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage")) is NSNull))
                {
                    img.isHidden = false
                    let str = ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage.append(" | \(str)s hand baggage")
                    }
                    else
                    {
                        baggage.append(" | \(str) hand baggage")
                    }
                }
                else
                {
                    img.isHidden = true
                }
                
                baggageLbl.text = baggage
                
                DaddressLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                aAddresslbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                DcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                DcityLbl.adjustsFontSizeToFitWidth = true
                
                AcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                AcityLbl.adjustsFontSizeToFitWidth = true
                
                
                if indexPath.row < (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray)).count - 1
                {
                    for layer in layOverView.layer.sublayers!
                    {
                        if layer.name == "Layer1"
                        {
                            layer.removeFromSuperlayer()
                        }
                    }
                    
                    let layOverViewBorder = CAShapeLayer()
                    layOverViewBorder.fillColor = UIColor.clear.cgColor
                    layOverViewBorder.name = "Layer1"
                    layOverViewBorder.strokeColor = UIColor.lightGray.cgColor
                    layOverViewBorder.lineDashPattern = [4, 7]
                    layOverViewBorder.frame = layOverView.bounds
                    layOverViewBorder.path = UIBezierPath(roundedRect: layOverView.bounds, cornerRadius: 10).cgPath
                    layOverView.layer.addSublayer(layOverViewBorder)
                    layOverView.backgroundColor = UIColor.white
                    
                    let layovertime = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row+1) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!.timeIntervalSince( df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: indexPath.row) as! NSDictionary).value(forKey:"Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!))
                    
                    let hourslayover:Int = layovertime/3600
                    let minuteslayover = (layovertime - (hourslayover * 3600))/60
                    
                    if hourslayover < 10 && minuteslayover == 0
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)hrs"
                    }
                    else if hourslayover < 10 && minuteslayover < 10
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)h 0\(minuteslayover)min"
                    }
                    else if hourslayover > 9 && minuteslayover == 0
                    {
                        layOverLbl.text = "Layover: \(hourslayover)hrs"
                    }
                    else if hourslayover > 9 && minuteslayover < 10
                    {
                        layOverLbl.text = "Layover: \(hourslayover)h 0\(minuteslayover)min"
                    }
                    else if hourslayover < 10 && minuteslayover > 9
                    {
                        layOverLbl.text = "Layover: 0\(hourslayover)h \(minuteslayover)min"
                    }
                    else
                    {
                        layOverLbl.text = "Layover: \(hourslayover)h \(minuteslayover)min"
                    }
                }
            }
            
            DurationLbl.adjustsFontSizeToFitWidth = true
            Atimelbl.adjustsFontSizeToFitWidth = true
            Dtimelbl.adjustsFontSizeToFitWidth = true
            baggageLbl.adjustsFontSizeToFitWidth = true
        }
        else if (dataDic.value(forKey: "flightDetail1") != nil && indexPath.section == 2) || (dataDic.value(forKey: "flightDetail1") == nil && indexPath.section == 1)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            let heading = cell.viewWithTag(1) as! UILabel
            let count = cell.viewWithTag(2) as! UILabel
            let imgView = cell.viewWithTag(3) as! UIImageView
            let fareBtn = cell.viewWithTag(4) as! UIButton
            fareBtn.isHidden = true
            
            if indexPath.row == 0
            {
                imgView.isHidden = false
                heading.text = "Traveller Information"
                heading.font = UIFont(name: "Arimo-Bold", size: 15)
                heading.textColor = UIColor.black
                
                count.textColor = UIColor.lightGray
                count.isHidden = false
                count.text = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") == nil || ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count == 0) ? "0 Pax" : "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count) Pax"
                count.adjustsFontSizeToFitWidth = true
            }
            else
            {
                imgView.isHidden = true
                heading.font = UIFont(name: "Arimo", size: 14)
                heading.text = "\((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).value(forKey: "FirstName")!) \((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).value(forKey: "LastName")!)"
                heading.textColor = UIColor.black
                count.isHidden = true
            }
        }
        else if (dataDic.value(forKey: "flightDetail1") != nil && indexPath.section == 3) || (dataDic.value(forKey: "flightDetail1") == nil && indexPath.section == 2)
        {
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = .none
            numberFormatter.groupingSeparator = ","
            numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
            
            if #available(iOS 9.0, *) {
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            } else {
                // Fallback on earlier versions
            }
            
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                let fareBtn = cell.viewWithTag(4) as! UIButton
                fareBtn.isHidden = false
                
                imgView.isHidden = false
                heading.text = "Payment Details"
                heading.font = UIFont(name: "Arimo-Bold", size: 15)
                heading.textColor = UIColor.black
                count.isHidden = true
            }
            else if (indexPath.row == 8 && dataDic.value(forKey: "unsuccessful_booking_amount") == nil) || (indexPath.row == 9 && dataDic.value(forKey: "unsuccessful_booking_amount") != nil)
            {
                
                cell = tableView.dequeueReusableCell(withIdentifier: "priceCell")!
                let headLbl = cell.viewWithTag(1) as! UILabel
                let priceLbl = cell.viewWithTag(2) as! UILabel
                let cancelHeadlbl = cell.viewWithTag(3) as! UILabel
                let cancelpriceLbl = cell.viewWithTag(4) as! UILabel
                let refundheadLbl = cell.viewWithTag(5) as! UILabel
                let refundpriceLbl = cell.viewWithTag(6) as! UILabel
                
                cell.contentView.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                headLbl.text = "Total"
                
                let total = Double("\(dataDic.value(forKey: "grand_total")!)")
                let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(total!)))
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 13)!])
                var normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 10)!])
                normalString.append(attributedString1)
                priceLbl.attributedText = normalString
                
                if ((dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "4") || (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "4"))
                {
                    cancelHeadlbl.text = "Cancellation Charges"
                    refundheadLbl.text = "Refund Amount"
                    
                    var refund = 0.0
                    var cancelCharge = 0.0
                    
                    if dataDic.value(forKey: "refund") != nil && (dataDic.value(forKey: "refund") as! NSArray).count > 0 && ((dataDic.value(forKey: "refund") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount") != nil && !(((dataDic.value(forKey: "refund") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount") is NSNull)
                    {
                        refund = Double("\(((dataDic.value(forKey: "refund") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount")!)")!
                        cancelCharge = Double("\(((dataDic.value(forKey: "refund") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "total_cancellation_amt")!)")!
                    }
                    
                    if dataDic.value(forKey: "refund1") != nil && (dataDic.value(forKey: "refund1") as! NSArray).count > 0 && ((dataDic.value(forKey: "refund1") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount") != nil && !(((dataDic.value(forKey: "refund1") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount") is NSNull)
                    {
                        refund = refund + Double("\(((dataDic.value(forKey: "refund1") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "amount")!)")!
                        cancelCharge = cancelCharge + Double("\(((dataDic.value(forKey: "refund") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "total_cancellation_amt")!)")!
                    }
                    
                    var formattedNumber1 = numberFormatter.string(from: NSNumber(value: Int(Double(cancelCharge))))
                    var attributedString2 = NSMutableAttributedString(string: "\(formattedNumber1!)", attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 13)!, NSForegroundColorAttributeName: supportingfuction.hexStringToUIColor(hex: "ed5252")])
                    normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 10)!,NSForegroundColorAttributeName: supportingfuction.hexStringToUIColor(hex: "ed5252")])
                    normalString.append(attributedString2)
                    cancelpriceLbl.attributedText = normalString
                    
                    
                    formattedNumber1 = numberFormatter.string(from: NSNumber(value: Int(refund)))
                    attributedString2 = NSMutableAttributedString(string: "\(formattedNumber1!)", attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 13)!, NSForegroundColorAttributeName: supportingfuction.hexStringToUIColor(hex: "ed5252")])
                    normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: priceLbl.font.fontName, size: 10)!, NSForegroundColorAttributeName: supportingfuction.hexStringToUIColor(hex: "ed5252")])
                    normalString.append(attributedString2)
                    refundpriceLbl.attributedText = normalString
                }
                
            }
            else if (indexPath.row == 8 && dataDic.value(forKey: "unsuccessful_booking_amount") != nil)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                let fareBtn = cell.viewWithTag(4) as! UIButton
                fareBtn.isHidden = true
                
                count.isHidden = false
                imgView.isHidden = true
                heading.textColor = supportingfuction.hexStringToUIColor(hex: "ed5d52")
                heading.font = UIFont(name: "Arimo", size: 14)
                heading.text = "Unsuccessful Booking Amount"
                
                let dis = ceil(Double("\(dataDic.value(forKey: "unsuccessful_booking_amount")!)")!)
                let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(dis)))
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: "Arimo-Bold", size: 13)!])
                let normalString = NSMutableAttributedString(string: "+\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: "Arimo-Bold", size: 11.0)!])
                normalString.append(attributedString1)
                count.attributedText = normalString
                count.adjustsFontSizeToFitWidth = true
                count.textColor = supportingfuction.hexStringToUIColor(hex: "ed5d52")
            }
            else if (indexPath.row == 9 && dataDic.value(forKey: "unsuccessful_booking_amount") == nil) || (indexPath.row == 10 && dataDic.value(forKey: "unsuccessful_booking_amount") != nil)
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "cancelCell")!
                let btn = cell.viewWithTag(1) as! UIButton
                btn.layer.cornerRadius = 19
            }
            else
            {
                let mark_up = Double("\(dataDic.value(forKey: "mark_up")!)")
                let mark_down = Double("\(dataDic.value(forKey: "mark_down")!)")
                
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                let fareBtn = cell.viewWithTag(4) as! UIButton
                fareBtn.isHidden = true
                
                count.isHidden = false
                imgView.isHidden = true
                heading.font = UIFont(name: "Arimo", size: 14)
                count.font = UIFont(name: "Arimo-Bold", size: 14)
                heading.textColor = UIColor.lightGray
                count.textColor = UIColor.black
                
                if indexPath.row == 1
                {
                    heading.text = "Base Fare (\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count))"
                    var total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!))
                    
                    if "\(Int(mark_up!))" != "0"
                    {
                        total = total + Int(Double("\(mark_up!)")!)
                    }
                    else if "\(Int(mark_down!))" != "0"
                    {
                        total = total - Int(Double("\(mark_down!)")!)
                    }
                    
                    if (dataDic.value(forKey: "flightDetail1") != nil) && (dataDic.value(forKey: "international_return_time") == nil)
                    {
                        total = total + Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!))
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                    normalString.append(attributedString1)
                    count.attributedText = normalString
                    count.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 2
                {
                    heading.text = "Other Charge"
                    let arr = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray
                    var total = 0
                    for n in 0..<arr.count
                    {
                        if "\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key")!)" == "OTHERCHARGE"
                        {
                            total = Int(ceil(Double("\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                        }
                    }
                    
                    if (dataDic.value(forKey: "flightDetail1") != nil) && (dataDic.value(forKey: "international_return_time") == nil)
                    {
                        let arr1 = ((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray
                        for n in 0..<arr1.count
                        {
                            if "\(((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key")!)" == "OTHERCHARGE"
                            {
                                total = total + Int(ceil(Double("\(((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                            }
                        }
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                    normalString.append(attributedString1)
                    count.attributedText = normalString
                    count.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 3
                {
                    heading.text = "Additional Taxation Fee"
                    var total = 0
                    
                    if (dataDic.value(forKey: "flightDetail1") == nil)
                    {
                        if "\(Int(Double("\(mark_up!)")!))" != "0" || "\(Int(Double("\(mark_down!)")!))" != "0"
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!))
                        }
                        else
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!))
                        }
                    }
                    else if (dataDic.value(forKey: "flightDetail1") != nil) && (dataDic.value(forKey: "international_return_time") == nil)
                    {
                        
                        if "\(Int(Double("\(mark_up!)")!))" != "0" || "\(Int(Double("\(mark_down!)")!))" != "0"
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!))
                            
                            total = total + Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!))
                        }
                        else
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!))
                            
                            total = total +  Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!))
                        }
                    }
                    
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                    normalString.append(attributedString1)
                    count.attributedText = normalString
                    count.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 4
                {
                    heading.text = "Tax"
                    var total = ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
                    
                    if (dataDic.value(forKey: "flightDetail1") != nil) && (dataDic.value(forKey: "international_return_time") == nil)
                    {
                        total = total + ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                    normalString.append(attributedString1)
                    count.attributedText = normalString
                    count.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 5
                {
                    heading.text = "Coupon Discount"
                    if dataDic.value(forKey: "discount") != nil && !(dataDic.value(forKey: "discount") is NSNull)
                    {
                        let dis = ceil(Double("\(dataDic.value(forKey: "discount")!)")!)
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(dis)))
                        let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                        let normalString = NSMutableAttributedString(string: "-\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                        normalString.append(attributedString1)
                        count.attributedText = normalString
                        count.adjustsFontSizeToFitWidth = true
                        count.textColor = supportingfuction.hexStringToUIColor(hex: "1F58A9")
                    }
                    else
                    {
                        count.text = "-"
                    }
                }
                else if indexPath.row == 6
                {
                    heading.text = "Full Refund Fee"
                    
                    if(dataDic.value(forKey: "charge_of_full_return") != nil && "\(dataDic.value(forKey: "charge_of_full_return")!)" != "")
                    {
                        count.text = "\(dataDic.value(forKey: "charge_of_full_return")!)"
                    }
                    else
                    {
                        count.text = "-"
                    }
                }
                else if indexPath.row == 7
                {
                    heading.text = "Convenience Fee"
                    var total = 0.0
                    
                    if (dataDic.value(forKey: "convenience_fee") != nil && !(dataDic.value(forKey: "convenience_fee") is NSNull) && "\(dataDic.value(forKey: "convenience_fee")!)" != "<null>")
                    {
                        total = ceil(Double("\(dataDic.value(forKey: "convenience_fee")!)")!)
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: count.font.fontName, size: 11.0)!])
                    normalString.append(attributedString1)
                    count.attributedText = normalString
                    count.adjustsFontSizeToFitWidth = true
                }
            }
        }
        
        return cell
    }
    
   
    
    //MARK:- button handling
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cancelBtn(_ sender: UIButton)
    {
        let dict = dataDic.value(forKey: "flightDetail") as! NSDictionary
        var dict1 = NSDictionary()
        
        if dataDic.value(forKey: "flightDetail1") != nil  && (dataDic.value(forKey: "international_return_time") == nil)
        {
            dict1 = (dataDic.value(forKey: "flightDetail1") as! NSDictionary)
        }
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if  (dataDic.value(forKey: "flightDetail") != nil && dataDic.value(forKey: "flightDetail1") != nil && (dataDic.value(forKey: "international_return_time") == nil)) && (df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!).compare(Date()) == ComparisonResult.orderedDescending && (df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!).compare(Date()) == ComparisonResult.orderedDescending && ("\(dataDic.value(forKey: "DepartCancel")!)" == "0" && (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "0"))
        {
            let action = UIAlertController(title: "", message: "Select to cancel", preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            cancel.setValue(supportingfuction.hexStringToUIColor(hex: "ed5d52"), forKey: "titleTextColor")
            
            let depart = UIAlertAction(title: "Departure Flight", style: .default, handler: { (alert) in
                self.performCancellation(n: 0)
            })
            depart.setValue(supportingfuction.hexStringToUIColor(hex: "1f58a9"), forKey: "titleTextColor")
            
            let returnf = UIAlertAction(title: "Return Flight", style: .default, handler: { (alert) in
                self.performCancellation(n: 1)
            })
            returnf.setValue(supportingfuction.hexStringToUIColor(hex: "1f58a9"), forKey: "titleTextColor")
            
            let both = UIAlertAction(title: "Both Flights", style: .default, handler: { (alert) in
                self.performCancellation(n: 2)
            })
            both.setValue(supportingfuction.hexStringToUIColor(hex: "1f58a9"), forKey: "titleTextColor")
            
            action.addAction(depart)
            action.addAction(returnf)
            action.addAction(both)
            action.addAction(cancel)
            self.present(action, animated: true, completion: nil)
        }
        else if ((dataDic.value(forKey: "flightDetail") != nil && (df.date(from: ((((dict.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!).compare(Date()) == ComparisonResult.orderedDescending) && (dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "0")) || (dataDic.value(forKey: "international_return_time") != nil)
        {
            self.performCancellation(n: 3)
        }
        else if (dataDic.value(forKey: "flightDetail1") != nil && dict.value(forKey: "Segments") != nil && (df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray)).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!).compare(Date()) == ComparisonResult.orderedDescending) && (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "0")
        {
            self.performCancellation(n: 4)
        }
    }
    
    
    func performCancellation(n: Int)
    {
        var message = ""
        
        if n == 0
        {
            message = "Are you sure you want to cancel depart flight?"
        }
        else if n == 1
        {
            message = "Are you sure you want to cancel return flight?"
        }
        else if n == 2
        {
            message = "Are you sure you want to cancel both flights?"
        }
        else if n == 3 || n == 4
        {
            message = "Are you sure you want to cancel the flight?"
        }
        
        let action = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let ok = UIAlertAction(title: "Yes", style: .default, handler: { (alert) in
            self.cancelFlight(n: n)
        })
        action.addAction(cancel)
        action.addAction(ok)
        
        self.present(action, animated: true, completion: nil)
    }
    
    func refund()
    {
        
        
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: "RefundViewController") as! RefundViewController
        vc.dataDic = self.dataDic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    private func stringFromHtml(string: String) -> NSAttributedString? {
        do {
            let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
            if let d = data {
                let str = try NSAttributedString(data: d,
                                                 options: [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType],
                                                 documentAttributes: nil)
                return str
            }
        } catch {
        }
        return nil
    }
    
    @IBAction func fareRuleBtn(_ sender: UIButton) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareRulesViewController") as! FareRulesViewController
        
        if dataDic.value(forKey: "flightDetail1") == nil || self.dataDic.value(forKey: "international_return_time") != nil && !(self.dataDic.value(forKey: "international_return_time") is NSNull)
        {
            vc.from = "single"
            vc.dataDic.setValue(stringFromHtml(string: "\((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "FareRuleDetail")!)"), forKey: "fareRule")
        }
        else
        {
            vc.dataDic.setValue(stringFromHtml(string: "\((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "FareRuleDetail")!)"), forKey: "fareRule")
            vc.dataDic.setValue(stringFromHtml(string: "\((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "FareRuleDetail")!)"), forKey: "fareRule1")
            vc.from = "double"
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    //MARK:- webservice
    
    func cancelFlight(n:Int)
    {
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                
                if (UserDefaults.standard.value(forKey: "userData") != nil) && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken") != nil
                {
                    requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                }
                else if (UserDefaults.standard.value(forKey: "user") != nil) && (UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "accessToken") != nil
                {
                    requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                }
                
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                let params = NSMutableDictionary()
                let arr = NSMutableArray()
                
                params.setValue("\(dataDic.value(forKey: "order_id")!)", forKey: "order_id")
                
                
                if  dataDic.value(forKey: "BookingId") != nil && (n == 0 || n == 2 || n == 3) && dataDic.value(forKey: "DepartCancel") != nil && "\(dataDic.value(forKey: "DepartCancel")!)" == "0"
                {
                    arr.add("\(dataDic.value(forKey: "BookingId")!)")
                }
                
                if (dataDic.value(forKey: "BookingId1") != nil && (n == 1 || n == 2 || n == 3)) || dataDic.value(forKey: "BookingId") == nil && (dataDic.value(forKey: "flightDetail1") != nil && (dataDic.value(forKey: "ArriveCancel") != nil && "\(dataDic.value(forKey: "ArriveCancel")!)" == "0"))
                {
                    arr.add("\(dataDic.value(forKey: "BookingId1")!)")
                }
                
                params.setValue(arr, forKey: "booking_id")
                
                manager.post(("\(BASE_URL)api/cancel-flight"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if ("\(dataFromServer.value(forKey: "status")!)" == "success")
                            {
                                if self.dataDic.value(forKey: "BookingId") != nil && (n == 0 || n == 2 || n == 3)
                                {
                                    self.dataDic.setValue((dataFromServer.value(forKey: "data") as! NSArray).count, forKey: "DepartCancel")
                                }
                                else if (self.dataDic.value(forKey: "BookingId1") != nil && (n == 1 || n == 2)) || self.dataDic.value(forKey: "BookingId") == nil
                                {
                                    self.dataDic.setValue((dataFromServer.value(forKey: "data") as! NSArray).count, forKey: "ArriveCancel")
                                }
                                else if n == 2
                                {
                                    self.dataDic.setValue((dataFromServer.value(forKey: "data") as! NSArray).count, forKey: "DepartCancel")
                                    self.dataDic.setValue((dataFromServer.value(forKey: "data") as! NSArray).count, forKey: "ArriveCancel")
                                }
                                self.tblView.reloadData()
                            }
                            else  if ("\(dataFromServer.value(forKey: "status")!)" == "error")
                            {
                                let paragraph = NSMutableParagraphStyle()
                                paragraph.alignment = .left
                                let att: NSAttributedString =  NSAttributedString(string: "This ticket cannot be cancelled for now. Reasons maybe:\n \u{2022} The booked ticket may not be ticketed yet.\n \u{2022} There may be a server issue.\n Please try after some time.", attributes: [NSParagraphStyleAttributeName :  paragraph, NSFontAttributeName: UIFont(name: "Arimo", size: 14.0)!])
                                
                                supportingfuction.hideProgressHudInView(view: self.view)
                                let action = UIAlertController(title: "Tick8", message: "", preferredStyle: .alert)
                                let cancel = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                                action.setValue(att, forKey: "attributedMessage")
                                action.addAction(cancel)
                                self.present(action, animated: true, completion: nil)
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: "\(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Error") as! NSDictionary).value(forKey: "ErrorMessage")!)", delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    //         print(error)
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    // Put your code which should be executed with a delay here
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
    
    
    func getFlightDetail()
    {
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                let params = NSMutableDictionary()
                if UserDefaults.standard.value(forKey: "EndUserIp") == nil
                {
                    appDel.getIpWebservice()
                    NotificationCenter.default.addObserver(self, selector: #selector(SingleWayViewController.getFlightListing), name: Notification.Name("ipGenerated"), object: nil)
                    return
                }
                else
                {
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("ipGenerated"), object: nil)
                    params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
                }
                
                params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
                params.setValue(dataDic.value(forKey: "TraceId") as! String, forKey: "TraceId")
                
                if dataDic.value(forKey: "flightDetail") ==  nil && dataDic.value(forKey: "BookingId") != nil && dataDic.value(forKey: "PNR") != nil
                {
                    params.setValue(dataDic.value(forKey: "BookingId") as! String, forKey: "BookingId")
                    if "\(dataDic.value(forKey: "BookingId")!)" == "0"
                    {
                        params.setValue(dataDic.value(forKey: "FirstName") as! String, forKey: "FirstName")
                        params.setValue(dataDic.value(forKey: "LastName") as! String, forKey: "LastName")
                    }
                    params.setValue(dataDic.value(forKey: "PNR") as! String, forKey: "PNR")
                }
                else if dataDic.value(forKey: "BookingId1") != nil && dataDic.value(forKey: "PNR1") != nil
                {
                    params.setValue(dataDic.value(forKey: "TraceId") as! String, forKey: "TraceId")
                    params.setValue(dataDic.value(forKey: "BookingId1") as! String, forKey: "BookingId")
                    
                    if "\(dataDic.value(forKey: "BookingId1")!)" == "0"
                    {
                        params.setValue(dataDic.value(forKey: "FirstName") as! String, forKey: "FirstName")
                        params.setValue(dataDic.value(forKey: "LastName") as! String, forKey: "LastName")
                    }
                    
                    params.setValue(dataDic.value(forKey: "PNR1") as! String, forKey: "PNR")
                }
                
                manager.post(("\(BOOK_URL)GetBookingDetails"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if ("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)" == "1")
                            {
                                if self.dataDic.value(forKey: "flightDetail") ==  nil
                                {
                                    //&& self.dataDic.value(forKey: "BookingId") != nil && self.dataDic.value(forKey: "PNR") != nil
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FlightItinerary") as! NSDictionary), forKey: "flightDetail")
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId") as! String), forKey: "TraceId")
                                    
                                    if self.dataDic.value(forKey: "international_return_time") != nil && !(self.dataDic.value(forKey: "international_return_time") is NSNull) && self.dataDic.value(forKey: "flightDetail") != nil
                                    {
                                        let segment1 = NSMutableArray()
                                        let segment2 = NSMutableArray()
                                        
                                        for i in 0..<((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).count
                                        {
                                            if "\((((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "TripIndicator")!)" == "1"
                                            {
                                                segment1.add((((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: i) as! NSDictionary))
                                            }
                                            else if "\((((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: i) as! NSDictionary).value(forKey: "TripIndicator")!)" == "2"
                                            {
                                                segment2.add((((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: i) as! NSDictionary))
                                            }
                                        }
                                        
                                        self.dataDic.setValue((self.dataDic.value(forKey: "flightDetail") as! NSDictionary), forKey: "flightDetail1")
                                        let dic1 = (self.dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                        let dic2 = (self.dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                        
                                        dic1.setValue(segment1, forKey: "Segments")
                                        dic2.setValue(segment2, forKey: "Segments")
                                        self.dataDic.setValue(dic1, forKey: "flightDetail")
                                        self.dataDic.setValue(dic2, forKey: "flightDetail1")
                                    }
                                    
                                    if self.dataDic.value(forKey: "PNR1") != nil && self.dataDic.value(forKey: "PNR") != nil && self.dataDic.value(forKey: "flightDetail1") == nil
                                    {
                                        self.getFlightDetail()
                                    }
                                    else
                                    {
                                        self.tblView.reloadData()
                                        self.setValues()
                                        self.tblView.isHidden = false
                                        self.headerView.isHidden = false
                                        self.transView.isHidden = false
                                    }
                                }
                                else if self.dataDic.value(forKey: "flightDetail1") == nil
                                {
                                    //&& self.dataDic.value(forKey: "BookingId1") != nil && self.dataDic.value(forKey: "PNR1") != nil
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FlightItinerary") as! NSDictionary), forKey: "flightDetail1")
                                    self.tblView.reloadData()
                                    self.setValues()
                                    self.tblView.isHidden = false
                                    self.headerView.isHidden = false
                                    self.transView.isHidden = false
                                }
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "4")
                            {
                                appDel.getIpWebservice()
                                NotificationCenter.default.addObserver(self, selector: #selector(SingleWayViewController.getFlightListing), name: Notification.Name("ipGenerated"), object: nil)
                                return
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "2")
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: "No detail available for this data.", delay: 2.0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    // Put your code which should be executed with a delay here
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: "\(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Error") as! NSDictionary).value(forKey: "ErrorMessage")!)", delay: 2.0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    // Put your code which should be executed with a delay here
                                    _ = self.navigationController?.popViewController(animated: true)
                                })
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    //    print(error)
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        // Put your code which should be executed with a delay here
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                })
            }
            else
            {
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                    // Put your code which should be executed with a delay here
                    _ = self.navigationController?.popViewController(animated: true)
                })
            }
        }
    }
}

