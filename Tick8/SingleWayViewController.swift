//
//  SingleWayViewController.swift
//  Tick8
//
//  Created by singsys on 8/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class SingleWayViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, Sort,filter, PKSwipeCellDelegateProtocol {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var recordLbl: UILabel!
    var dataDict = NSMutableDictionary()
    var selectedIndex = -1
    var webserviceHit = false
    var from = ""
    private var oldStoredCell:PKSwipeTableViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if dataDict.value(forKey: "select") == nil
        {
            dataDict.setValue("1", forKey: "select")
            setValues()
        }
        
        if webserviceHit == false
        {
            recordLbl.isHidden = true
            tableView.isHidden = true
            getPricing()
        }
        
        if from == "internationaldouble"
        {
            SortTheArray()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    func setValues()
    {
        let Dcity = headerView.viewWithTag(1) as! UILabel
        let Acity = headerView.viewWithTag(2) as! UILabel
        let passenger = headerView.viewWithTag(3) as! UILabel
        let date = headerView.viewWithTag(4) as! UILabel
        let rightBtn = headerView.viewWithTag(7) as! UIButton
        let leftBtn = headerView.viewWithTag(8) as! UIButton
        let calView = headerView.viewWithTag(11)!
        let calView2 = headerView.viewWithTag(12)!
        let date2 = headerView.viewWithTag(13) as! UILabel
        
        let img = headerView.viewWithTag(20) as! UIImageView
        let economy = headerView.viewWithTag(5) as! UILabel
        let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var dateTxt = ""
        
        
        if dataDict.value(forKey: "PreferredDepartureTime") != nil && dataDict.value(forKey: "PreferredDepartureTime") is String
        {
            let stDate = df.date(from: dataDict.value(forKey: "PreferredDepartureTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                dateTxt = "0\(components.day!) \((months.object(at: m-1) as! String))"
            }
            else
            {
                dateTxt = "\(components.day!) \((months.object(at: m-1) as! String))"
            }
        }
        
        if from == "internationaldouble" &&  dataDict.value(forKey: "PreferredArrivalTime") != nil && dataDict.value(forKey: "PreferredArrivalTime") is String
        {
            let stDate = df.date(from: dataDict.value(forKey: "PreferredArrivalTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                dateTxt.append(" - 0\(components.day!) \((months.object(at: m-1) as! String))")
            }
            else
            {
                dateTxt.append(" - \(components.day!) \((months.object(at: m-1) as! String))")
            }
        }
        
        if from == "" || from == "internationalsingle"
        {
            date.text = dateTxt
            calView.isHidden = false
            calView2.isHidden = true
            leftBtn.isHidden = false
            rightBtn.isHidden = false
        }
        else
        {
            date2.text = dateTxt
            calView2.isHidden = false
            calView.isHidden = true
            leftBtn.isHidden = true
            rightBtn.isHidden = true
        }
        
        Dcity.text = ((dataDict.value(forKey: "Origin") != nil && dataDict.value(forKey: "Origin") is String) ? dataDict.value(forKey: "Origin") as? String : "")
        Acity.text = ((dataDict.value(forKey: "Destination") != nil && dataDict.value(forKey: "Destination") is String) ? dataDict.value(forKey: "Destination") as? String : "")
       
        img.image = (from == "" || from == "internationalsingle") ? #imageLiteral(resourceName: "oneWayD"): #imageLiteral(resourceName: "twoWay")
        img.contentMode = .scaleAspectFit
        
        passenger.text = "\(Int(dataDict.value(forKey: "AdultCount") as! String)!+Int(dataDict.value(forKey: "ChildCount") as! String)!+Int(dataDict.value(forKey: "InfantCount") as! String)!) Pax"
        passenger.adjustsFontSizeToFitWidth = true
        
        economy.text = ((dataDict.value(forKey: "class") != nil && dataDict.value(forKey: "class") is String) ? (dataDict.value(forKey: "class") as! String) : "")
        
        date2.adjustsFontSizeToFitWidth = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (from == "" || from == "internationalsingle" || from == "internationaldouble") && dataDict.value(forKey: "flightList") != nil && dataDict.value(forKey: "flightList") is NSArray && (dataDict.value(forKey: "flightList") as! NSArray).count > 0
        {
            recordLbl.isHidden = true
            return (dataDict.value(forKey: "flightList") as! NSArray).count
        }
        else
        {
            if webserviceHit == true
            {
                recordLbl.isHidden = false
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let dict = (dataDict.value(forKey: "flightList") as! NSArray).object(at: indexPath.row) as! NSDictionary
         if (dict.value(forKey: "Segments") as! NSArray).count == 1
         {
            return 92
         }
         else
         {
            return 167
         }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        var cell = UITableViewCell()
        
        let df = DateFormatter()
        df.locale =  Locale(identifier: "en_US_POSIX")
        let df1 = DateFormatter()
        df1.locale =  Locale(identifier: "en_US_POSIX")
        
        df1.dateFormat = "hh:mm a"
        df1.amSymbol = "AM"
        df1.pmSymbol = "PM"
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if dataDict.value(forKey: "flightList") != nil && dataDict.value(forKey: "flightList") is NSArray && (dataDict.value(forKey: "flightList") as! NSArray).count > 0
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
            
            let dict = (dataDict.value(forKey: "flightList") as! NSArray).object(at: indexPath.row) as! NSDictionary
            
              /////////////////////////////////**///////////////////
            if (dict.value(forKey: "Segments") as! NSArray).count == 1
            {
//                cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")!
                
                 var MyNewSwipecell = tableView.dequeueReusableCell(withIdentifier: "dataCell") as! MyCustomCellTableViewCell
               
                MyNewSwipecell.delegate = self
                
                let imgView = MyNewSwipecell.viewWithTag(1) as! UIImageView
                
                let label_flight = MyNewSwipecell.viewWithTag(-100) as! UILabel
                
                let AirlineName = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                
                let FlightNumber =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String)
                
                let AirlineCode =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                let code = AirlineCode + " " + FlightNumber
                
                let singleAttribute1 = [NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                let singleAttribute2 = [NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                
                label_flight.attributedText = CommonValidations().attributedTexts(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2)
                
                let timeLbl = MyNewSwipecell.viewWithTag(2) as! UILabel
                let durationLbl = MyNewSwipecell.viewWithTag(3) as! UILabel
                let amountLbl = MyNewSwipecell.viewWithTag(4) as! UILabel
                let wholeImg = MyNewSwipecell.viewWithTag(6) as! UIImageView
                let refundLbl = MyNewSwipecell.viewWithTag(8) as! UILabel
                let offeredPrice = MyNewSwipecell.viewWithTag(7) as! UIImageView
                offeredPrice.isHidden = true
                wholeImg.isHidden = true
                
                if selectedIndex == indexPath.row
                {
                    wholeImg.isHidden = false
                }
                
                //                let dict = (dataDict.value(forKey: "flightList") as! NSArray).object(at: indexPath.row) as! NSDictionary
                
                if "\(dict.value(forKey: "IsRefundable")!)" == "true" || "\(dict.value(forKey: "IsRefundable")!)" == "1"
                {
                    refundLbl.text = "Refundable"
                }
                else
                {
                    refundLbl.text = "Non-Refundable"
                }
                
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
                    stop = "\((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) Stop"
                }
                
                imgView.image = UIImage(named:  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String))
                imgView.contentMode = .scaleAspectFit
                
                if(imgView.image == nil)
                {
                   /// imgView.image =  imageLiteral(resourceName: "default_airline")
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
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDict.value(forKey: "mark_up_coupon")!)")!
                    
                    // offeredPrice.isHidden = false
                     MyNewSwipecell.isPanEnabled = false
                }
                else if corporateArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)
                    //+ Double("\(dataDict.value(forKey: "mark_up_corporate")!)")!
                    MyNewSwipecell.price_Toshow = Int(Double("\(dataDict.value(forKey: "mark_up_corporate")!)")!)
                    offeredPrice.isHidden = false
                     MyNewSwipecell.isPanEnabled = true
                   
                }
                else
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDict.value(forKey: "mark_down_publish")!)")!
                     MyNewSwipecell.isPanEnabled = false
                    
                }
                
                let formattedNumber = numberFormatter.string(from: NSNumber(value: fare))
                
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 15)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 12.0)!])
                normalString.append(attributedString1)
                amountLbl.attributedText = normalString
                
                timeLbl.adjustsFontSizeToFitWidth = true
                durationLbl.adjustsFontSizeToFitWidth = true
                amountLbl.adjustsFontSizeToFitWidth = true
                refundLbl.adjustsFontSizeToFitWidth = true
            return MyNewSwipecell
            }
                
                  //////////////////////
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "twoCell")!
                
                let label_flight = cell.viewWithTag(-100) as! UILabel
                
                
                let AirlineName = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                
                let FlightNumber =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String)
                
                let AirlineCode =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                
                let code = AirlineCode + " " + FlightNumber
                
                let singleAttribute1 = [ NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                let singleAttribute2 = [ NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                
                label_flight.attributedText = CommonValidations().attributedTexts(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2)
                
                let timeLbl = cell.viewWithTag(2) as! UILabel
                let durationLbl = cell.viewWithTag(3) as! UILabel
                let amountLbl = cell.viewWithTag(4) as! UILabel
                let wholeImg = cell.viewWithTag(6) as! UIImageView
                let imgView2 = cell.viewWithTag(9) as! UIImageView
                let durationlbl2 = cell.viewWithTag(11) as! UILabel
                let time2Lbl = cell.viewWithTag(10) as! UILabel
                let refundLbl = cell.viewWithTag(8) as! UILabel
                let offeredPrice = cell.viewWithTag(7) as! UIImageView
                offeredPrice.isHidden = true
                wholeImg.isHidden = true
                
                if selectedIndex == indexPath.row
                {
                    wholeImg.isHidden = false
                }
                
                imgView2.image = UIImage(named:  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String))
                imgView2.contentMode = .scaleAspectFit
                
                if(imgView2.image == nil)
                {
                    imgView2.image = #imageLiteral(resourceName: "default_airline")
                }
                
                let dict = (dataDict.value(forKey: "flightList") as! NSArray).object(at: indexPath.row) as! NSDictionary
                
                if "\(dict.value(forKey: "IsRefundable")!)" == "true" || "\(dict.value(forKey: "IsRefundable")!)" == "1"
                {
                    refundLbl.text = "Refundable"
                }
                else
                {
                    refundLbl.text = "Non-Refundable"
                }
                

                var fare = 0.0
                
                if couponArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + Double("\(dataDict.value(forKey: "mark_up_coupon")!)")!
               //     offeredPrice.isHidden = false
                }
                else if corporateArr.contains("\(dict.value(forKey: "Source")!)")
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)
                    //+ Double("\(dataDict.value(forKey: "mark_up_corporate")!)")!
                    offeredPrice.isHidden = false
                }
                else
                {
                    fare = ceil(Double("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - Double("\(dataDict.value(forKey: "mark_down_publish")!)")!
                }
                
                let formattedNumber = numberFormatter.string(from: NSNumber(value: fare))
                
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 15)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: amountLbl.font.fontName, size: 12.0)!])
                normalString.append(attributedString1)
                amountLbl.attributedText = normalString
                
                
                //departure flight
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
                    stop = "\((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) Stop"
                }
                
                timeLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode")!)(\(Deptime)) - \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode")!)(\(ArrTime))"
                
                
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
                
                
                //return flight
                if (dict.value(forKey: "Segments") as! NSArray).count == 2
                {
                    let ArrTime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                    
                    let Deptime = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                    
                    let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                    
                    let hours:Int = dur/3600
                    let minutes = (dur - (hours * 3600))/60
                    
                    var stop = String()
                    
                    if ((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count == 1
                    {
                        stop = "Non Stop"
                    }
                    else
                    {
                        stop = "\((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1)) Stop"
                    }
                    
                    time2Lbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode")!)(\(Deptime)) - \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode")!)(\(ArrTime))"
                    
                    if hours < 10 && minutes == 0
                    {
                        durationlbl2.text = "0\(hours)hrs | \(stop)"
                    }
                    else if hours < 10 && minutes < 10
                    {
                        durationlbl2.text = "0\(hours)h 0\(minutes)min | \(stop)"
                    }
                    else if hours > 9 && minutes == 0
                    {
                        durationlbl2.text = "\(hours)hrs | \(stop)"
                    }
                    else if hours > 9 && minutes < 10
                    {
                        durationlbl2.text = "\(hours)h 0\(minutes)min | \(stop)"
                    }
                    else if hours < 10 && minutes > 9
                    {
                        durationlbl2.text = "0\(hours)h \(minutes)min | \(stop)"
                    }
                    else
                    {
                        durationlbl2.text = "\(hours)h \(minutes)min | \(stop)"
                    }
                    let label_flight_second = cell.viewWithTag(-200) as! UILabel
                    
                    
                    let AirlineName2 = (((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String)
                    
                    let FlightNumber2 =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String)
                    
                    let AirlineCode2 =  (((((dict.value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String)
                    
                    var code1 = AirlineCode2 + " " + FlightNumber2
                    
                    let singleAttribute3 = [ NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                    let singleAttribute4 = [ NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                    
                    label_flight_second.attributedText = CommonValidations().attributedTexts(text1: AirlineName2, attribs1: singleAttribute3, text2: code1, attribs2: singleAttribute4)
                }
                
                
                
                timeLbl.adjustsFontSizeToFitWidth = true
                durationLbl.adjustsFontSizeToFitWidth = true
                amountLbl.adjustsFontSizeToFitWidth = true
                refundLbl.adjustsFontSizeToFitWidth = true
                time2Lbl.adjustsFontSizeToFitWidth = true
                durationlbl2.adjustsFontSizeToFitWidth = true
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        selectedIndex = indexPath.row
        self.tableView.reloadData()
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FlightDetailViewController") as! FlightDetailViewController
        vc.dataDic.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
        vc.dataDic.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
        vc.dataDic.setValue(dataDict.value(forKey: "Origin") as? String, forKey: "Origin")
        vc.dataDic.setValue("\((dataDict.value(forKey: "TraceId")!))", forKey: "TraceId")
        vc.dataDic.setValue(dataDict.value(forKey: "Destination") as? String, forKey: "Destination")
        vc.dataDic.setValue(dataDict.value(forKey: "PreferredDepartureTime") as? String, forKey: "PreferredDepartureTime")
        vc.dataDic.setValue(dataDict.value(forKey: "class") as? String, forKey: "class")
        vc.dataDic.setValue(dataDict.value(forKey: "AdultCount") as? String, forKey: "AdultCount")
        vc.dataDic.setValue(dataDict.value(forKey: "ChildCount") as? String, forKey: "ChildCount")
        vc.dataDic.setValue(dataDict.value(forKey: "InfantCount") as? String, forKey: "InfantCount")
        vc.dataDic.setValue("\((dataDict.value(forKey: "mark_up_coupon")!))", forKey: "mark_up_coupon")
        vc.dataDic.setValue("\((dataDict.value(forKey: "mark_down_publish")!))", forKey: "mark_down_publish")
        vc.dataDic.setValue("\((dataDict.value(forKey: "mark_up_corporate")!))" , forKey: "mark_up_corporate")
        
        
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_one_way")!))", forKey: "inter_one_way")
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_round_trip")!))", forKey: "inter_round_trip")
        vc.dataDic.setValue("\((dataDict.value(forKey: "one_way")!))" , forKey: "one_way")
        vc.dataDic.setValue("\((dataDict.value(forKey: "round_trip")!))" , forKey: "round_trip")
        
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_one_way2")!))", forKey: "inter_one_way2")
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_round_trip2")!))", forKey: "inter_round_trip2")
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_one_way_cap")!))" , forKey: "inter_one_way_cap")
        vc.dataDic.setValue("\((dataDict.value(forKey: "inter_round_trip_cap")!))" , forKey: "inter_round_trip_cap")
        
        
        vc.dataDic.setValue((dataDict.value(forKey: "flightList") as! NSArray).object(at: indexPath.row) as! NSDictionary, forKey: "flightDetail")
        vc.from = "single"
        
        if from == "internationalsingle"
        {
            vc.from = "internationalsingle"
        }
        else if from == "internationaldouble"
        {
            vc.dataDic.setValue(dataDict.value(forKey: "PreferredArrivalTime") as? String, forKey: "PreferredArrivalTime")
            vc.from = "internationaldouble"
        }
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
        
    
    //MARK:- button handling
    
    @IBAction func filterBtn(_ sender: UIButton)
    {
        if (dataDict.value(forKey: "flightList") != nil && dataDict.value(forKey: "flightList") is NSArray && (dataDict.value(forKey: "flightList") as! NSArray).count > 0) || (dataDict.value(forKey: "nonfilteredArray") != nil && dataDict.value(forKey: "nonfilteredArray") is NSArray && (dataDict.value(forKey: "nonfilteredArray") as! NSArray).count > 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FilterViewController") as! FilterViewController
            vc.delegate = self
            vc.from = "single"
            vc.dataDiction = dataDict.mutableCopy() as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func changeDate(_ sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this is your string date format
        let dtf = DateFormatter()
        dtf.dateFormat = "yyyy-MM-dd"
        let dateDate = dateFormatter.date(from: dataDict.value(forKey: "PreferredDepartureTime") as! String)
        
        var cal = Date()
        if sender.tag == 7
        {
            if dtf.date(from: dtf.string(from: dateDate!))?.compare(dtf.date(from: dtf.string(from: cal))!) == ComparisonResult.orderedDescending || dtf.date(from: dtf.string(from: dateDate!))?.compare(dtf.date(from: dtf.string(from: cal))!) == ComparisonResult.orderedSame
            {
                supportingfuction.showMessageHudWithMessage(message: "Selected date cannot precede today's date.", delay: 2.0)
                return
            }
            cal = Calendar.current.date(byAdding: .day, value: -1, to: dateDate!)!
        }
        else
        {
            let check = dtf.date(from: dtf.string(from: dateFormatter.date(from: dataDict.value(forKey: "PreferredDepartureTime") as! String)!))
            
            if check! > Date().addingTimeInterval(24*60*60*93)
            {
                supportingfuction.showMessageHudWithMessage(message: "Selected date cannot be later than 3 months from today.", delay: 2.0)
                return
            }
            cal = Calendar.current.date(byAdding: .day, value: 1, to: dateDate!)!
        }
        self.tableView.isHidden = true
        
        if dataDict.value(forKey: "filtered_max_price") != nil
        {
            dataDict.removeObject(forKey: "filtered_max_price")
        }
        if dataDict.value(forKey: "filtered_min_price") != nil
        {
            dataDict.removeObject(forKey: "filtered_min_price")
        }
        if dataDict.value(forKey: "stop") != nil
        {
            dataDict.removeObject(forKey: "stop")
        }
        if dataDict.value(forKey: "selected_carrier_name") != nil
        {
            dataDict.removeObject(forKey: "selected_carrier_name")
        }
        if dataDict.value(forKey: "nonfilteredArray") != nil
        {
            dataDict.removeObject(forKey: "nonfilteredArray")
        }
        
        
        dataDict.setValue(dateFormatter.string(from: cal), forKey: "PreferredDepartureTime")
        dataDict.setValue(dateFormatter.string(from: cal), forKey: "PreferredArrivalTime")
        setValues()
        getFlightListing()
    }
    
    @IBAction func sortBtn(_ sender: UIButton)
    {
        if dataDict.value(forKey: "flightList") != nil && dataDict.value(forKey: "flightList") is NSArray && (dataDict.value(forKey: "flightList") as! NSArray).count > 0 || (dataDict.value(forKey: "nonfilteredArray") != nil && dataDict.value(forKey: "nonfilteredArray") is NSArray && (dataDict.value(forKey: "nonfilteredArray") as! NSArray).count > 0)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SortViewController") as! SortViewController
            vc.from = "single"
            vc.dataDic.setValue(dataDict.value(forKey: "select") as! String, forKey: "select")
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func sorting(value1:NSDictionary)
    {
        dataDict.setValue(value1.value(forKey: "select") as! String, forKey: "select")
        SortTheArray()
    }
    
    func filtered(values: NSDictionary) {
        self.dataDict = (values).mutableCopy() as! NSMutableDictionary
        filterValues()
    }
    
    func filterValues()
    {
        var flightArray = NSMutableArray()
        
        if dataDict.value(forKey: "nonfilteredArray") == nil
        {
            flightArray = (dataDict.value(forKey: "flightList") as! NSArray).mutableCopy() as! NSMutableArray
        }
        else
        {
            flightArray = (dataDict.value(forKey: "nonfilteredArray") as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        let filteredArray:NSMutableArray = NSMutableArray()
        
        for n in 0..<flightArray.count
        {
            let dict = (flightArray).object(at: n) as! NSDictionary
            var stop = -1
            var stopover = ""
            var mark = 0.0
            var fare = 0.0
           
            //  let corporateArr = ["36","37","38"]
            
            if couponArr.contains("\(dict.value(forKey: "Source")!)")
            {
                mark = Double("\(dataDict.value(forKey: "mark_up_coupon")!)")!
                fare = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)"))!)
            }
            else
            {
                mark = -Double("\(dataDict.value(forKey: "mark_down_publish")!)")!
                fare = ceil(Double(("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"))!)
            }
            
            if dataDict.value(forKey: "stop") != nil
            {
                stopover = dataDict.value(forKey: "stop") as! String
                stop = ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
            
            if (dataDict.value(forKey: "selected_carrier_name") == nil  || (dataDict.value(forKey: "selected_carrier_name") as! NSArray).contains((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String))) && (dataDict.value(forKey: "filtered_min_price") == nil || ceil(Double("\(dataDict.value(forKey: "filtered_min_price")!)")!) <= (fare+mark) && !(filteredArray.contains(dict))) && (dataDict.value(forKey: "filtered_max_price") == nil || ceil(Double("\(dataDict.value(forKey: "filtered_max_price")!)")!) >= (fare+mark)) && (dataDict.value(forKey: "stop") == nil || ((stopover == "stopZero") && stop == 1) || ((stopover == "stopOne") && stop == 2) || ((stopover == "stopOneMore") && stop > 2))
            {
                filteredArray.add(dict)
            }
        }
        
        dataDict.setValue(flightArray, forKey: "nonfilteredArray")
        dataDict.setValue(filteredArray, forKey: "flightList")
        
        if (dataDict.value(forKey: "flightList") as! NSArray).count != 0
        {
            SortTheArray()
        }
        else
        {
            self.tableView.reloadData()
        }
    }
    
    func SortTheArray()
    {
        supportingfuction.hideProgressHudInView(view: self.view)
        supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
        
        let flightArray = (dataDict.value(forKey: "flightList") as! NSArray).mutableCopy() as! NSMutableArray
        
        if dataDict.value(forKey: "select") != nil && flightArray.count > 0
        {
            if dataDict.value(forKey: "select") as! String == "1"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        let price = ("\((dict.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")
                        let price1 = "\((dict1.value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)"
                        
                        if ceil(Double(price)!) > ceil(Double(price1)!)
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDict.value(forKey: "select") as! String == "2"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDict.value(forKey: "select") as! String == "3"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDict.value(forKey: "select") as! String == "4"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedDescending
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDict.value(forKey: "select") as! String == "5"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df1.amSymbol = "AM"
                        df1.pmSymbol = "PM"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        
                        let Deptime = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        
                        let Deptime1 = df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!
                        let result = Deptime.compare(Deptime1)
                        
                        if result == ComparisonResult.orderedAscending
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
            else if dataDict.value(forKey: "select") as! String == "6"
            {
                for n in 0..<flightArray.count - 1
                {
                    for i in (n+1)..<(flightArray.count)
                    {
                        let dict = (flightArray).object(at: n) as! NSDictionary
                        let dict1 = (flightArray).object(at: i) as! NSDictionary
                        
                        let df = DateFormatter()
                        let df1 = DateFormatter()
                        
                        df1.dateFormat = "hh:mm a"
                        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                        
                        let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        let dur1:Int = Int(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1)) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict1.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                        
                        if dur > dur1
                        {
                            flightArray.replaceObject(at: n, with: dict1)
                            flightArray.replaceObject(at: i, with: dict)
                        }
                    }
                }
            }
        }
        
        self.dataDict.setValue(flightArray as! NSArray, forKey: "flightList")
        self.tableView.reloadData()
        supportingfuction.hideProgressHudInView(view: self.view)
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
                                            self.dataDict.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_up_coupon")
                                        }
                                        else if (((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String) == "mark_down_publish"
                                        {
                                            self.dataDict.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_down_publish")
                                        }
                                        else if (((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String) == "mark_up_corporate"
                                        {
                                            self.dataDict.setValue(ceil(Double("\((((dataFromServer.value(forKey: "data") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key_value")!))")!), forKey: "mark_up_corporate")
                                        }
                                    }
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip")!)", forKey: "inter_round_trip")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way")!)", forKey: "inter_one_way")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "one_way")!)", forKey: "one_way")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "round_trip")!)", forKey: "round_trip")
                                    
                                    
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip2")!)", forKey: "inter_round_trip2")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way2")!)", forKey: "inter_one_way2")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_one_way_cap")!)", forKey: "inter_one_way_cap")
                                    self.dataDict.setValue("\((dataFromServer.value(forKey: "convenience_fee") as! NSDictionary).value(forKey: "inter_round_trip_cap")!)", forKey: "inter_round_trip_cap")
                                    
                                    self.getFlightListing()
                                }
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
               //     print(error)
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
    
    
    func getFlightListing()
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
                params.setValue(dataDict.value(forKey: "AdultCount") as! String, forKey: "AdultCount")
                params.setValue(dataDict.value(forKey: "ChildCount") as! String, forKey: "ChildCount")
                params.setValue(dataDict.value(forKey: "InfantCount") as! String, forKey: "InfantCount")
                params.setValue(false, forKey: "DirectFlight")
                params.setValue(false, forKey: "OneStopFlight")
                params.setValue("1", forKey: "JourneyType")
                
                let segmentDic = NSMutableDictionary()
                segmentDic.setValue(dataDict.value(forKey: "Origin") as! String, forKey: "Origin")
                segmentDic.setValue(dataDict.value(forKey: "Destination") as! String, forKey: "Destination")
                segmentDic.setValue(dataDict.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredDepartureTime")
               
                if dataDict.value(forKey: "PreferredArrivalTime") == nil
                {
                    segmentDic.setValue(dataDict.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredArrivalTime")
                }
                else
                {
                    segmentDic.setValue(dataDict.value(forKey: "PreferredArrivalTime") as! String, forKey: "PreferredArrivalTime")
                }
                
                if dataDict.value(forKey: "class") != nil
                {
                    if dataDict.value(forKey: "class") as! String == "Economy"
                    {
                        segmentDic.setValue("2", forKey: "FlightCabinClass")
                    }
                    else if dataDict.value(forKey: "class") as! String == "Premium Economy"
                    {
                        segmentDic.setValue("3", forKey: "FlightCabinClass")
                    }
                    else if dataDict.value(forKey: "class") as! String == "Business"
                    {
                        segmentDic.setValue("4", forKey: "FlightCabinClass")
                    }
                    else if dataDict.value(forKey: "class") as! String == "Premium"
                    {
                        segmentDic.setValue("6", forKey: "FlightCabinClass")
                    }
                    else
                    {
                        segmentDic.setValue("1", forKey: "FlightCabinClass")
                    }
                }
                
                let search:NSMutableArray = NSMutableArray()
                search.add(segmentDic)
                
                params.setValue(search, forKey: "Segments")
                
                manager.post(("\(BOOK_URL)Search"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        //supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if ("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)" == "1")
                            {
                                self.dataDict.setValue((((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSArray).object(at: 0) as! NSArray), forKey: "flightList")
                                self.dataDict.setValue("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId")!)", forKey: "TraceId")
                                self.webserviceHit = true
                                self.tableView.isHidden = false
                                self.SortTheArray()
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
               //     print(error)
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
    
    func swipeBeginInCell(cell: PKSwipeTableViewCell) {
         oldStoredCell = cell
    }
    
    func swipeDoneOnPreviousCell() -> PKSwipeTableViewCell? {
                guard let cell = oldStoredCell else {
                    return nil
                }
                return cell
    }
    
}
