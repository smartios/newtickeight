//
//  TwoWayViewController.swift
//  Tick8
//
//  Created by singsys on 8/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class TwoWayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,Sort,filter {
    
    @IBOutlet weak var BookView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var departView: UIView!
    @IBOutlet weak var Drecord: UILabel!
    @IBOutlet weak var Arecord: UILabel!
    @IBOutlet weak var departTblView: UITableView!
    @IBOutlet weak var returnTableView: UITableView!
    var dataDic:NSMutableDictionary = NSMutableDictionary()
    var webserviceHit = false
    var selectionIndices:NSMutableArray = [-1,-1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        dataDic.setValue("1", forKey: "dSelect")
        dataDic.setValue("1", forKey: "aSelect")
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if webserviceHit == false
        {
            departTblView.isHidden = true
            returnTableView.isHidden = true
            Drecord.isHidden = true
            Arecord.isHidden = true
            self.view.backgroundColor = supportingfuction.hexStringToUIColor(hex: "ffffff")
            setValues()
            getPricing()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setValues()
    {
        let Dcity = headerView.viewWithTag(1) as! UILabel
        let Acity = headerView.viewWithTag(2) as! UILabel
        let passenger = headerView.viewWithTag(3) as! UILabel
        let date = headerView.viewWithTag(4) as! UILabel
        let economy = headerView.viewWithTag(5) as! UILabel
        let departDate = departView.viewWithTag(1) as! UILabel
        let arriveDate = departView.viewWithTag(2) as! UILabel
        let departImage = departView.viewWithTag(3) as! UIImageView
        departImage.layer.masksToBounds =  false
        departImage.layer.shadowColor = UIColor.darkGray.cgColor
        departImage.layer.shadowOffset = CGSize(width:0, height: 4)
        departImage.clipsToBounds = false
        departImage.layer.shadowOpacity = 0.6
        departImage.layer.shadowRadius = 2
        
        let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        var dateText = ""
        if dataDic.value(forKey: "PreferredDepartureTime") != nil && dataDic.value(forKey: "PreferredDepartureTime") is String
        {
            let stDate = df.date(from: dataDic.value(forKey: "PreferredDepartureTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                dateText.append("0\(components.day!) \((months.object(at: m-1) as! String))")
                departDate.text = "0\(components.day!) \((months.object(at: m-1) as! String))"
            }
            else
            {
                dateText.append("\(components.day!) \((months.object(at: m-1) as! String))")
                departDate.text = "\(components.day!) \((months.object(at: m-1) as! String))"
            }
        }
        
        if dataDic.value(forKey: "PreferredArrivalTime") != nil && dataDic.value(forKey: "PreferredArrivalTime") is String
        {
            let stDate = df.date(from: dataDic.value(forKey: "PreferredArrivalTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                dateText.append(" - 0\(components.day!) \((months.object(at: m-1) as! String))")
                arriveDate.text = "0\(components.day!) \((months.object(at: m-1) as! String))"
            }
            else
            {
                dateText.append(" - \(components.day!) \((months.object(at: m-1) as! String))")
                arriveDate.text = "\(components.day!) \((months.object(at: m-1) as! String))"
            }
        }
        
        date.text = dateText
        date.adjustsFontSizeToFitWidth = true
        
        if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Origin") is String
        {
            Dcity.text = dataDic.value(forKey: "Origin") as? String
        }
        
        if dataDic.value(forKey: "Destination") != nil && dataDic.value(forKey: "Destination") is String
        {
            Acity.text = dataDic.value(forKey: "Destination") as? String
        }
        
        passenger.text = "\(Int(dataDic.value(forKey: "AdultCount") as! String)! + Int(dataDic.value(forKey: "ChildCount") as! String)! + Int(dataDic.value(forKey: "InfantCount") as! String)!) Pax"
        passenger.adjustsFontSizeToFitWidth = true
        
        if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") is String
        {
            economy.text = (dataDic.value(forKey: "class") as! String)
        }
    }
    
    
    //MARK:- table view  handling
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == departTblView && dataDic.value(forKey: "departList") != nil && dataDic.value(forKey: "departList") is NSArray && (dataDic.value(forKey: "departList") as! NSArray).count > 0
        {
            Drecord.isHidden = true
            return (dataDic.value(forKey: "departList") as! NSArray).count
        }
        else if tableView == departTblView && webserviceHit == true
        {
            Drecord.isHidden = false
        }
        else if tableView == returnTableView && dataDic.value(forKey: "returnList") != nil && dataDic.value(forKey: "returnList") is NSArray && (dataDic.value(forKey: "returnList") as! NSArray).count > 0
        {
            Arecord.isHidden = true
            return (dataDic.value(forKey: "returnList") as! NSArray).count
        }
        else if tableView == returnTableView && webserviceHit == true
        {
            Arecord.isHidden = false
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 114
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")!
        
        let imgView = cell.viewWithTag(1) as! UIImageView
        let timeLbl = cell.viewWithTag(2) as! UILabel
        let durationLbl = cell.viewWithTag(3) as! UILabel
        let amountLbl = cell.viewWithTag(4) as! UILabel
        let wholeImg = cell.viewWithTag(6) as! UIImageView
        let refundLbl = cell.viewWithTag(8) as! UILabel
        let offeredPrice = cell.viewWithTag(7) as! UIImageView
        offeredPrice.isHidden = true
        wholeImg.isHidden = true
        
        
        if tableView == departTblView
        {
            if dataDic.value(forKey: "departList") != nil && dataDic.value(forKey: "departList") is NSArray && (dataDic.value(forKey: "departList") as! NSArray).count > 0
            {
                if (selectionIndices.object(at: 0) as! Int) == indexPath.row
                {
                    wholeImg.isHidden = false
                }
                
                let df = DateFormatter()
                df.locale =  Locale(identifier: "en_US_POSIX")
                let df1 = DateFormatter()
                df1.locale =  Locale(identifier: "en_US_POSIX")
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let dict = (dataDic.value(forKey: "departList") as! NSArray).object(at: indexPath.row) as! NSDictionary
                
                if "\(dict.value(forKey: "IsRefundable")!)" == "true" || "\(dict.value(forKey: "IsRefundable")!)" == "1"
                {
                    refundLbl.text = "Refundable"
                }
                else
                {
                    refundLbl.text = "Non-Refundable"
                }
                
                
                let label_flight = cell.viewWithTag(-100) as! UILabel
                
                
                let AirlineName = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                
                let FlightNumber =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String)
                
                let AirlineCode =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                let code = AirlineCode + " " + FlightNumber
                
                let singleAttribute1 = [ NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                let singleAttribute2 = [ NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                
                label_flight.attributedText = CommonValidations().attributedTexts(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2)

                imgView.image = UIImage(named:  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String))
                if(imgView.image == nil)
                {
                    imgView.image = #imageLiteral(resourceName: "default_airline")
                }
                
                imgView.contentMode = .scaleAspectFit
                
                let ArrTime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                let Deptime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                
                let hours:Int = dur/3600
                let minutes = (dur - (hours * 3600))/60
                
                var stop = String()
                if ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count == 1
                {
                    stop = "Non Stop"
                }
                else
                {
                    stop = "\(((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) Stop"
                }
                
                timeLbl.text = "\(Deptime) - \(ArrTime)"
                
                if hours < 10 && minutes == 0
                {
                    durationLbl.text = "0\(hours)hrs | \(stop)"
                }
               else  if hours < 10 && minutes < 10
                {
                    durationLbl.text = "0\(hours)h 0\(minutes)min | \(stop)"
                }
                else if hours > 9 && minutes == 0
                {
                    durationLbl.text = "\(hours)hrs | \(stop)"
                }
                else if hours > 9 && minutes < 10
                {
                    durationLbl.text = "\(hours)h 0\(minutes)min | \(stop)"
                }
                else if hours < 10 && minutes > 9
                {
                    durationLbl.text = "0\(hours)h \(minutes)min | \(stop)"
                }
                else
                {
                    durationLbl.text = "\(hours)h \(minutes)min | \(stop)"
                }
                
            
                var fare = 0.0
                
                if couponArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                   // offeredPrice.isHidden = false
                }
                else if corporateArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!
                    offeredPrice.isHidden = false
                }
                else
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDic.value(forKey: "mark_down_publish")!)")!
                }

                let numberFormatter = NumberFormatter()
                numberFormatter.currencyCode = .none
                numberFormatter.groupingSeparator = ","
                numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
                if #available(iOS 9.0, *) {
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                } else {
                    // Fallback on earlier versions
                }
                let formattedNumber = numberFormatter.string(from: NSNumber(value:fare))
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 15)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 12.0)!])
                normalString.append(attributedString1)
                amountLbl.attributedText = normalString
                
                timeLbl.adjustsFontSizeToFitWidth = true
                durationLbl.adjustsFontSizeToFitWidth = true
                amountLbl.adjustsFontSizeToFitWidth = true
            }
        }
        else if tableView == returnTableView
        {
            if dataDic.value(forKey: "returnList") != nil && dataDic.value(forKey: "returnList") is NSArray && (dataDic.value(forKey: "returnList") as! NSArray).count > 0
            {
                if (selectionIndices.object(at: 1) as! Int) == indexPath.row
                {
                    wholeImg.isHidden = false
                }
                
                let df = DateFormatter()
                df.locale =  Locale(identifier: "en_US_POSIX")
                let df1 = DateFormatter()
                df1.locale =  Locale(identifier: "en_US_POSIX")
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                let dict = (dataDic.value(forKey: "returnList") as! NSArray).object(at: indexPath.row) as! NSDictionary
                
                if "\(dict.value(forKey: "IsRefundable")!)" == "true" || "\(dict.value(forKey: "IsRefundable")!)" == "1"
                {
                    refundLbl.text = "Refundable"
                }
                else
                {
                    refundLbl.text = "Non-Refundable"
                }
                
                imgView.image = UIImage(named:  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String))
                imgView.contentMode = .scaleAspectFit
                
                if(imgView.image == nil)
                {
                    imgView.image = #imageLiteral(resourceName: "default_airline")
                }
                
                
                let label_flight = cell.viewWithTag(-100) as! UILabel
                
                
                let AirlineName = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                
                let FlightNumber =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String)
                
                let AirlineCode =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                let code = AirlineCode + " " + FlightNumber
                
                let singleAttribute1 = [ NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                let singleAttribute2 = [ NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                
                label_flight.attributedText = CommonValidations().attributedTexts(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2)

                
                
                let ArrTime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                let Deptime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                
                let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                
                let hours:Int = dur/3600
                let minutes = (dur - (hours * 3600))/60
                
                var stop = String()
                if ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count == 1
                {
                    stop = "Non Stop"
                }
                else
                {
                    stop = "\(((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) Stop"
                }
                
                timeLbl.text = "\(Deptime) - \(ArrTime)"
                
                if hours < 10 && minutes == 0
                {
                    durationLbl.text = "0\(hours)hrs | \(stop)"
                }
                else if hours < 10 && minutes < 10
                {
                    durationLbl.text = "0\(hours)h 0\(minutes)min | \(stop)"
                }
                else if hours > 9 && minutes == 0
                {
                    durationLbl.text = "\(hours)hrs | \(stop)"
                }
                else if hours > 9 && minutes < 10
                {
                    durationLbl.text = "\(hours)h 0\(minutes)min | \(stop)"
                }
                else if hours < 10 && minutes > 9
                {
                    durationLbl.text = "0\(hours)h \(minutes)min | \(stop)"
                }
                else
                {
                    durationLbl.text = "\(hours)h \(minutes)min | \(stop)"
                }
                
                
                
                var fare = 0.0
                if couponArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                //    offeredPrice.isHidden = false
                }
                else if corporateArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)
                        //+ Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!
                    offeredPrice.isHidden = false
                }
                else
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDic.value(forKey: "mark_down_publish")!)")!
                }

                let numberFormatter = NumberFormatter()
                numberFormatter.currencyCode = .none
                numberFormatter.groupingSeparator = ","
                numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
                if #available(iOS 9.0, *) {
                    numberFormatter.numberStyle = NumberFormatter.Style.decimal
                } else {
                    // Fallback on earlier versions
                }
                
                let formattedNumber = numberFormatter.string(from: NSNumber(value:fare))
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 15)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 12.0)!])
                normalString.append(attributedString1)
                amountLbl.attributedText = normalString
                
                timeLbl.adjustsFontSizeToFitWidth = true
                durationLbl.adjustsFontSizeToFitWidth = true
                amountLbl.adjustsFontSizeToFitWidth = true
            }
        }
        
        timeLbl.adjustsFontSizeToFitWidth = true
        durationLbl.adjustsFontSizeToFitWidth = true
        amountLbl.adjustsFontSizeToFitWidth = true
        refundLbl.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == departTblView
        {
            selectionIndices.replaceObject(at: 0, with: indexPath.row)
            bookViewData()
            self.departTblView.reloadData()
        }
        else
        {
            selectionIndices.replaceObject(at: 1, with: indexPath.row)
            bookViewData()
            self.returnTableView.reloadData()
        }
    }
    
    func bookViewData()
    {
        let departPrice = BookView.viewWithTag(1) as! UILabel
        let returnPrice = BookView.viewWithTag(2) as! UILabel
        let totalPrice = BookView.viewWithTag(3) as! UILabel
        var fareP = 0.0
        var returnP = 0.0
        departPrice.text = ""
        returnPrice.text = ""
        totalPrice.text = ""
        
        
        
        if (selectionIndices.object(at: 0) as! Int) != -1
        {
            if couponArr.contains("\(((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary).value(forKey: "Source")!)")
            {
                fareP = ceil(Double("\((((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!
            }
            else if corporateArr.contains("\(((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary).value(forKey: "Source")!)")
            {
                fareP = ceil(Double("\((((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)
            }
            else
            {
                fareP = ceil(Double("\((((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDic.value(forKey: "mark_down_publish")!)")!
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = .none
            numberFormatter.groupingSeparator = ","
            numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
            if #available(iOS 9.0, *) {
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            } else {
                // Fallback on earlier versions
            }
            let formattedNumber = numberFormatter.string(from: NSNumber(value:(Int(fareP))))
            let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: departPrice.font.fontName, size: 13)!])
            let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: departPrice.font.fontName, size: 10.0)!])
            normalString.append(attributedString1)
            departPrice.attributedText = normalString
        }
        else
        {
            departPrice.text = ""
        }
        
        
        if (selectionIndices.object(at: 1) as! Int) != -1
        {
            if couponArr.contains("\(((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary).value(forKey: "Source")!)")
            {
                returnP = ceil(Double("\((((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!
            }
            else if corporateArr.contains("\(((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary).value(forKey: "Source")!)")
            {
                returnP = ceil(Double("\((((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)
                //+ Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!
            }
            else
            {
                returnP = ceil(Double("\((((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDic.value(forKey: "mark_down_publish")!)")!
            }
        
            
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = .none
            numberFormatter.groupingSeparator = ","
            numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
            
            if #available(iOS 9.0, *) {
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            } else {
                // Fallback on earlier versions
            }
            let formattedNumber = numberFormatter.string(from: NSNumber(value:(Int(returnP))))
            let attributedString1 = NSMutableAttributedString(string:"\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: returnPrice.font.fontName, size: 13)!])
            let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: returnPrice.font.fontName, size: 10.0)!])
            normalString.append(attributedString1)
            returnPrice.attributedText = normalString
        }
        else
        {
            returnPrice.text = ""
        }
        
        
        if (selectionIndices.object(at: 1) as! Int) != -1 || (selectionIndices.object(at: 0) as! Int) != -1
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
            let formattedNumber = numberFormatter.string(from: NSNumber(value:(Int(fareP+returnP))))
            let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: returnPrice.font.fontName, size: 13)!])
            let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: returnPrice.font.fontName, size: 10.0)!])
            normalString.append(attributedString1)
            
            totalPrice.attributedText = normalString
        }
        else
        {
            totalPrice.text = ""
        }
        departPrice.adjustsFontSizeToFitWidth = true
        returnPrice.adjustsFontSizeToFitWidth = true
        totalPrice.adjustsFontSizeToFitWidth = true
    }
    
    //MARK:- button handling
    @IBAction func backbtn(_ sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func bookNowBtn(_ sender: UIButton)
    {
        if (selectionIndices.object(at: 0) as! Int) == -1
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select Departure Flight.", delay: 2.0)
            return
        }
        
        if (selectionIndices.object(at: 1) as! Int) == -1
        {
            supportingfuction.showMessageHudWithMessage(message: "Please select Return Flight.", delay: 2.0)
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FlightDetailViewController") as! FlightDetailViewController
        
        vc.dataDic.setValue((dataDic.value(forKey: "departList") as! NSArray).object(at: (selectionIndices.object(at: 0) as! Int)) as! NSDictionary, forKey: "flightDetail")
        vc.dataDic.setValue((dataDic.value(forKey: "returnList") as! NSArray).object(at: (selectionIndices.object(at: 1) as! Int)) as! NSDictionary, forKey: "flightDetail1")
         vc.from = "double"
        vc.dataDic.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
        vc.dataDic.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
        vc.dataDic.setValue("\((dataDic.value(forKey: "TraceId")!))", forKey: "TraceId")
        vc.dataDic.setValue(dataDic.value(forKey: "Origin") as? String, forKey: "Origin")
        vc.dataDic.setValue(dataDic.value(forKey: "Destination") as? String, forKey: "Destination")
        vc.dataDic.setValue(dataDic.value(forKey: "PreferredDepartureTime") as? String, forKey: "PreferredDepartureTime")
        vc.dataDic.setValue(dataDic.value(forKey: "PreferredArrivalTime") as? String, forKey: "PreferredArrivalTime")
        vc.dataDic.setValue(dataDic.value(forKey: "class") as? String, forKey: "class")
        vc.dataDic.setValue(dataDic.value(forKey: "AdultCount") as? String, forKey: "AdultCount")
        vc.dataDic.setValue(dataDic.value(forKey: "ChildCount") as? String, forKey: "ChildCount")
        vc.dataDic.setValue(dataDic.value(forKey: "InfantCount") as? String, forKey: "InfantCount")
        vc.dataDic.setValue("\((dataDic.value(forKey: "mark_up_coupon")!))", forKey: "mark_up_coupon")
        vc.dataDic.setValue("\((dataDic.value(forKey: "mark_down_publish")!))", forKey: "mark_down_publish")
        vc.dataDic.setValue("\((dataDic.value(forKey: "mark_up_corporate")!))" , forKey: "mark_up_corporate")
       
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_one_way")!))", forKey: "inter_one_way")
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_round_trip")!))", forKey: "inter_round_trip")
        vc.dataDic.setValue("\((dataDic.value(forKey: "one_way")!))" , forKey: "one_way")
        vc.dataDic.setValue("\((dataDic.value(forKey: "round_trip")!))" , forKey: "round_trip")
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_one_way2")!))", forKey: "inter_one_way2")
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_round_trip2")!))", forKey: "inter_round_trip2")
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_one_way_cap")!))" , forKey: "inter_one_way_cap")
        vc.dataDic.setValue("\((dataDic.value(forKey: "inter_round_trip_cap")!))" , forKey: "inter_round_trip_cap")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func filterBtn(_ sender: UIButton)
    {
        if (dataDic.value(forKey: "departList") != nil && dataDic.value(forKey: "departList") is NSArray && (dataDic.value(forKey: "departList") as! NSArray).count > 0) || (dataDic.value(forKey: "returnList") != nil && dataDic.value(forKey: "returnList") is NSArray && (dataDic.value(forKey: "returnList") as! NSArray).count > 0) || (dataDic.value(forKey: "nonAfilteredArray") != nil && dataDic.value(forKey: "nonAfilteredArray") is NSArray && (dataDic.value(forKey: "nonAfilteredArray") as! NSArray).count > 0) || (dataDic.value(forKey: "nonDfilteredArray") != nil && dataDic.value(forKey: "nonDfilteredArray") is NSArray && (dataDic.value(forKey: "nonDfilteredArray") as! NSArray).count > 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
            vc.delegate = self
            vc.from = "double"
            vc.dataDiction = dataDic.mutableCopy() as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    @IBAction func SortBtn(_ sender: UIButton)
    {
        if (dataDic.value(forKey: "departList") != nil && dataDic.value(forKey: "departList") is NSArray && (dataDic.value(forKey: "departList") as! NSArray).count > 0) || (dataDic.value(forKey: "returnList") != nil && dataDic.value(forKey: "returnList") is NSArray && (dataDic.value(forKey: "returnList") as! NSArray).count > 0) || (dataDic.value(forKey: "nonAfilteredArray") != nil && dataDic.value(forKey: "nonAfilteredArray") is NSArray && (dataDic.value(forKey: "nonAfilteredArray") as! NSArray).count > 0) || (dataDic.value(forKey: "nonDfilteredArray") != nil && dataDic.value(forKey: "nonDfilteredArray") is NSArray && (dataDic.value(forKey: "nonDfilteredArray") as! NSArray).count > 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
            vc.from = "double"
            vc.dataDic.setValue(dataDic.value(forKey: "aSelect") as! String, forKey: "aSelect")
            vc.dataDic.setValue(dataDic.value(forKey: "dSelect") as! String, forKey: "dSelect")
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK:- other functions and protocol
    
    func filtered(values: NSDictionary) {
        self.dataDic = (values).mutableCopy() as! NSMutableDictionary
        selectionIndices = [-1,-1]
        bookViewData()
        filterValues()
    }
    
    func filterValues()
    {
        var DflightArray = NSMutableArray()
        var AflightArray = NSMutableArray()
        
        if dataDic.value(forKey: "nonDfilteredArray") == nil
        {
            DflightArray = (dataDic.value(forKey: "departList") as! NSArray).mutableCopy() as! NSMutableArray
        }
        else
        {
            DflightArray = (dataDic.value(forKey: "nonDfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        let filteredArray:NSMutableArray = NSMutableArray()
        
        for n in 0..<DflightArray.count
        {
            let dict = (DflightArray).object(at: n) as! NSDictionary
            var stop = -1
            var stopover = ""
            if dataDic.value(forKey: "stop") != nil
            {
                stopover = dataDic.value(forKey: "stop") as! String
                stop = ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
            
            if(dataDic.value(forKey: "selected_carrier_name") == nil  || (dataDic.value(forKey: "selected_carrier_name") as! NSArray).contains((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String))) && (dataDic.value(forKey: "filtered_min_price") == nil || ceil(Double("\(dataDic.value(forKey: "filtered_min_price")!)")!) < ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!) && !(filteredArray.contains(dict))) && (dataDic.value(forKey: "filtered_max_price") == nil || ceil(Double("\(dataDic.value(forKey: "filtered_max_price")!)")!) > ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!)) && (dataDic.value(forKey: "stop") == nil || ((stopover == "stopZero") && stop == 1) || ((stopover == "stopOne") && stop == 2) || ((stopover == "stopOneMore") && stop > 2))
                
            {
                filteredArray.add(dict)
            }
        }
        
        dataDic.setValue(DflightArray, forKey: "nonDfilteredArray")
        dataDic.setValue(filteredArray, forKey: "departList")
        
        if (dataDic.value(forKey: "departList") as! NSArray).count != 0
        {
            SortTheArray()
        }
        else
        {
            self.departTblView.reloadData()
        }
        
        if dataDic.value(forKey: "nonAfilteredArray") == nil
        {
            AflightArray = (dataDic.value(forKey: "returnList") as! NSArray).mutableCopy() as! NSMutableArray
        }
        else
        {
            AflightArray = (dataDic.value(forKey: "nonAfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        filteredArray.removeAllObjects()
        for n in 0..<AflightArray.count
        {
            let dict = (AflightArray).object(at: n) as! NSDictionary
            var stop = -1
            var stopover = ""
            if dataDic.value(forKey: "stop") != nil
            {
                stopover = dataDic.value(forKey: "stop") as! String
                stop = ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
            
            if(dataDic.value(forKey: "selected_carrier_name") == nil  || (dataDic.value(forKey: "selected_carrier_name") as! NSArray).contains((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String))) && (dataDic.value(forKey: "filtered_min_price") == nil || ceil(Double("\(dataDic.value(forKey: "filtered_min_price")!)")!) < ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!) && !(filteredArray.contains(dict))) && (dataDic.value(forKey: "filtered_max_price") == nil || ceil(Double("\(dataDic.value(forKey: "filtered_max_price")!)")!) > ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!)) && (dataDic.value(forKey: "stop") == nil || ((stopover == "stopZero") && stop == 1) || ((stopover == "stopOne") && stop == 2) || ((stopover == "stopOneMore") && stop > 2))
                
            {
                filteredArray.add(dict)
            }
        }
        dataDic.setValue(AflightArray, forKey: "nonAfilteredArray")
        dataDic.setValue(filteredArray, forKey: "returnList")
        
        if (dataDic.value(forKey: "departList") as! NSArray).count != 0
        {
            SortTheArray()
        }
        else
        {
            self.returnTableView.reloadData()
        }
    }
    
    func SortTheArray()
    {
        supportingfuction.hideProgressHudInView(view: self.view)
        supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
        
        let flightDArray = (dataDic.value(forKey: "departList") as! NSArray).mutableCopy() as! NSMutableArray
        let flightAArray = (dataDic.value(forKey: "returnList") as! NSArray).mutableCopy() as! NSMutableArray
        //flightArray.count > 0
        
        if(dataDic.value(forKey: "dSelect") != nil && flightDArray.count != 0)
        {
            if  dataDic.value(forKey: "dSelect") as! String == "1"
            {
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        let price = ("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")
                        let price1 = "\((dict1.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"
                        
                        if ceil(Double(price)!) > ceil(Double(price1)!)
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if  dataDic.value(forKey: "dSelect") as! String == "2"
            {
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "dSelect") as! String == "3"
            {
                
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "dSelect") as! String == "4"
            {
                
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "dSelect") as! String == "5"
            {
                
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "dSelect") as! String == "6"
            {
                
                //for depart list
                for n in 0..<flightDArray.count - 1
                {
                    for i in (n+1)..<(flightDArray.count)
                    {
                        let dict = (flightDArray).object(at: n) as! NSDictionary
                        let dict1 = (flightDArray).object(at: i) as! NSDictionary
                        
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        let dur1:Int = Int(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        if dur > dur1
                        {
                            flightDArray.replaceObject(at: n, with: dict1)
                            flightDArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
        }
        
       
        
        
        //for return list
        if(dataDic.value(forKey: "aSelect") != nil && flightAArray.count != 0)
        {
            if dataDic.value(forKey: "aSelect") as! String == "1"
            {
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        let price = ("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")
                        let price1 = "\((dict1.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"
                        
                        if ceil(Double(price)!) > ceil(Double(price1)!)
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "aSelect") as! String == "2"
            {
                //for return list
                
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "aSelect") as! String == "6"
            {
                //for return list
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        let dur1:Int = Int(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        if dur > dur1
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "aSelect") as! String == "5"
            {
                //for return list
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if  dataDic.value(forKey: "aSelect") as! String == "4"
            {
                //for return list
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDic.value(forKey: "aSelect") as! String == "3"
            {
                //for return list
                
                for n in 0..<flightAArray.count - 1
                {
                    for i in (n+1)..<(flightAArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightAArray).object(at: n) as! NSDictionary
                        let dict1 = (flightAArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightAArray.replaceObject(at: n, with: dict1)
                            flightAArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
        }
        
        
        
        self.dataDic.setValue(flightDArray as NSArray, forKey: "departList")
        self.dataDic.setValue(flightAArray as NSArray, forKey: "returnList")
        self.departTblView.reloadData()
        self.returnTableView.reloadData()
        supportingfuction.hideProgressHudInView(view: self.view)
    }
    
    func sorting(value1:NSDictionary)
    {
        dataDic.setValue(value1.value(forKey: "dSelect") as! String, forKey: "dSelect")
        dataDic.setValue(value1.value(forKey: "aSelect") as! String, forKey: "aSelect")
        selectionIndices = [-1,-1]
        self.SortTheArray()
    }
    
    
    func getPricing()
    {
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                requestSerializer.timeoutInterval = 120
                manager.requestSerializer = requestSerializer
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.get((BASE_URL + "api/getpricing"), parameters: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                if dataFromServer.value(forKey: "data") != nil && dataFromServer.value(forKey: "data") is NSArray &&
                                    (dataFromServer.value(forKey: "data") as! NSArray).count > 0
                                {
                                    for n in 0..<(dataFromServer.value(forKey: "data") as! NSArray).count
                                    {
                                        if (((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String) == "mark_up_coupon"
                                        {
                                            self.dataDic.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_up_coupon")
                                        }
                                        else if (((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String) == "mark_down_publish"
                                        {
                                            self.dataDic.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_down_publish")
                                        }
                                        else if (((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String) == "mark_up_corporate"
                                        {
                                            self.dataDic.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_up_corporate")
                                        }
                                    }
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip")!)", forKey: "inter_round_trip")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way")!)", forKey: "inter_one_way")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "one_way")!)", forKey: "one_way")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "round_trip")!)", forKey: "round_trip")
                                    
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip2")!)", forKey: "inter_round_trip2")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way2")!)", forKey: "inter_one_way2")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way_cap")!)", forKey: "inter_one_way_cap")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip_cap")!)", forKey: "inter_round_trip_cap")
                                    self.getDepartFlightListing()
                                }
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
              //      print(error)
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
    
    func getDepartFlightListing()
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
                    NotificationCenter.default.addObserver(self, selector: #selector(TwoWayViewController.getDepartFlightListing), name: Notification.Name("ipGenerated"), object: nil)
                    return
                }
                else
                {
                     NotificationCenter.default.removeObserver(self, name: Notification.Name("ipGenerated"), object: nil)
                    params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
                }
                params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
                params.setValue(dataDic.value(forKey: "AdultCount") as! String, forKey: "AdultCount")
                params.setValue(dataDic.value(forKey: "ChildCount") as! String, forKey: "ChildCount")
                params.setValue(dataDic.value(forKey: "InfantCount") as! String, forKey: "InfantCount")
                params.setValue(false, forKey: "DirectFlight")
                params.setValue(false, forKey: "OneStopFlight")
                params.setValue("2", forKey: "JourneyType")
                
                let segmentDic = NSMutableDictionary()
                segmentDic.setValue(dataDic.value(forKey: "Origin") as! String, forKey: "Origin")
                segmentDic.setValue(dataDic.value(forKey: "Destination") as! String, forKey: "Destination")
                segmentDic.setValue(dataDic.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredDepartureTime")
                segmentDic.setValue(dataDic.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredArrivalTime")
                
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Economy"
                {
                    segmentDic.setValue("2", forKey: "FlightCabinClass")
                }
                else if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Premium Economy"
                {
                    segmentDic.setValue("3", forKey: "FlightCabinClass")
                }
                else if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Business"
                {
                    segmentDic.setValue("4", forKey: "FlightCabinClass")
                }
                else if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Premium"
                {
                    segmentDic.setValue("6", forKey: "FlightCabinClass")
                }
                else
                {
                    segmentDic.setValue("1", forKey: "FlightCabinClass")
                }
                
                let segmentDic1 = NSMutableDictionary()
                segmentDic1.setValue(dataDic.value(forKey: "Destination") as! String, forKey: "Origin")
                segmentDic1.setValue(dataDic.value(forKey: "Origin") as! String, forKey: "Destination")
                segmentDic1.setValue(dataDic.value(forKey: "PreferredArrivalTime") as! String, forKey: "PreferredDepartureTime")
                segmentDic1.setValue(dataDic.value(forKey: "PreferredArrivalTime") as! String, forKey: "PreferredArrivalTime")
                
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Economy"
                {
                    segmentDic1.setValue("2", forKey: "FlightCabinClass")
                }
                else if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Business"
                {
                    segmentDic1.setValue("4", forKey: "FlightCabinClass")
                }
                else if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Premium"
                {
                    segmentDic1.setValue("6", forKey: "FlightCabinClass")
                }
                else
                {
                    segmentDic1.setValue("1", forKey: "FlightCabinClass")
                }
                
                let search:NSMutableArray = NSMutableArray()
                search.add(segmentDic)
                search.add(segmentDic1)
                
                params.setValue(search, forKey: "Segments")
                
                manager.post(("\(BOOK_URL)Search"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                       // supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if ("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)" == "1")
                            {
                                
                                if ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).count == 2
                                {
                                    self.dataDic.setValue((((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).object(at: 0) as! NSArray), forKey: "departList")
                                    self.dataDic.setValue((((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).object(at: 1) as! NSArray), forKey: "returnList")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId")!)", forKey: "TraceId")
                                    
                                    self.view.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                                    self.webserviceHit = true
                                    self.departTblView.isHidden = false
                                    self.returnTableView.isHidden = false
                                    self.SortTheArray()
                                }
                                else if ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).count == 1
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SingleWayViewController") as! SingleWayViewController
                                    
                                    self.dataDic.setValue((((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).object(at: 0) as! NSArray), forKey: "flightList")
                                    self.dataDic.setValue("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId")!)", forKey: "TraceId")
                                    
                                    vc.dataDict = self.dataDic.mutableCopy() as! NSMutableDictionary
                                    vc.from = "internationaldouble"
                                    vc.webserviceHit = true
                                    let array:NSMutableArray = (self.navigationController?.viewControllers as! NSArray).mutableCopy() as! NSMutableArray
                                    array.replaceObject(at: array.count-1, with: vc)
                                    supportingfuction.hideProgressHudInView(view: self.view)
                                    self.navigationController?.viewControllers = array as! [UIViewController]
                                }
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "4")
                            {
                                appDel.getIpWebservice()
                                NotificationCenter.default.addObserver(self, selector: #selector(TwoWayViewController.getDepartFlightListing), name: Notification.Name("ipGenerated"), object: nil)
                                return
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "2")
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: "No Flight(s) found for this route.", delay: 2.0)
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
            //        print(error)
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
