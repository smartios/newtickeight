//
//  TransactionViewController.swift
//  Tick8
//
//  Created by SL-167 on 11/1/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var btnheader: UIView!
    @IBOutlet var notripLbl: UILabel!
    @IBOutlet var planTrip: UIButton!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var notripView: UIView!
    var dataDic = NSMutableDictionary()
    var selectedState = "1"
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        planTrip.layer.cornerRadius = 17
        let btn1 = btnheader.viewWithTag(1) as! UIButton
        btn1.isSelected = true
        let lbl1 = btnheader.viewWithTag(4) as! UILabel
        lbl1.textColor = UIColor.white
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(TransactionViewController.webservice), for: UIControlEvents.valueChanged)
        tblView.addSubview(refreshControl) // not required when using UITableViewController
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webservice()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tblView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        
        if selectedState == "1" && (dataDic.value(forKey: "planned") != nil)
        {
            num = (dataDic.value(forKey: "planned") as! NSArray).count
        }
        else if selectedState == "2" && (dataDic.value(forKey: "complete") != nil)
        {
            num = (dataDic.value(forKey: "complete") as! NSArray).count
        }
        else if selectedState == "3" && (dataDic.value(forKey: "cancelled") != nil)
        {
            num = (dataDic.value(forKey: "cancelled") as! NSArray).count
        }
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dataCell")!
        let patternView = cell.viewWithTag(1)!
        
        for layer in patternView.layer.sublayers!
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
        
        layOverViewBorder.frame = CGRect(x: 0, y: 0, width: view.frame.size.width-35, height: patternView.frame.size.height)
        layOverViewBorder.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: view.frame.size.width-35, height: patternView.frame.size.height), cornerRadius: 13).cgPath
        patternView.layer.addSublayer(layOverViewBorder)
        patternView.backgroundColor = UIColor.white
        
        let transId = cell.viewWithTag(2) as! UILabel
        let dateBtn = cell.viewWithTag(3) as! UIButton
        let DcityCode = cell.viewWithTag(4) as! UILabel
        let DcityFull = cell.viewWithTag(5) as! UILabel
        let img = cell.viewWithTag(6) as! UIImageView
        
        let AcityCode = cell.viewWithTag(7) as! UILabel
        let AcityFull = cell.viewWithTag(8) as! UILabel
        let money = cell.viewWithTag(9) as! UILabel
        let label_flight = cell.viewWithTag(11) as! UILabel
        
        if dataDic.value(forKey: "planned") != nil || dataDic.value(forKey: "complete") != nil || dataDic.value(forKey: "cancelled") != nil
        {
            var dic = NSMutableDictionary()
            if selectedState == "1"
            {
                dic = ((dataDic.value(forKey: "planned") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            else if selectedState == "2"
            {
                dic = ((dataDic.value(forKey: "complete") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            else if selectedState == "3"
            {
                dic = ((dataDic.value(forKey: "cancelled") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            
            if dic.value(forKey: "payment_api_token") != nil && !(dic.value(forKey: "payment_api_token") is NSNull)
            {
                let text = "Transaction ID: \(dic.value(forKey: "payment_api_token")!)"
                let range = (text as NSString).range(of: "Transaction ID:")
                let attributedString = NSMutableAttributedString(string: text)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range)
                transId.attributedText = attributedString
            }
            else
            {
                transId.text = ""
            }
            
            if dic.value(forKey: "flights") != nil && dic.value(forKey: "flights") is NSArray && (dic.value(forKey: "flights") as! NSArray).count > 0
            {
                let df = DateFormatter()
                df.locale =  Locale(identifier: "en_US_POSIX")
                let df1 = DateFormatter()
                df1.locale =  Locale(identifier: "en_US_POSIX")
                
                df1.dateFormat = "dd MMM"
                df.dateFormat = "yyyy-MM-dd HH:mm:ss"
                
                
                if "\(dic.value(forKey: "booking_type")!)" == "one-way"
                {
                    if !(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date") is NSNull)
                    {
                        let date = "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date")!)"
                        dateBtn.setTitle(df1.string(from: df.date(from: date)!), for: .normal)
                    }
                    
                    let AirlineName = " \((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_name")!)"
                    
                    let FlightNumber =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "flight_number")!)"
                    
                    let AirlineCode =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_code")!) "
                    
                    
                    
                    let pnrNumber = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "pnr")!)"
                    
                    let pnrHeading = "  PNR: "
                    
                    
                    let code = AirlineCode + FlightNumber
                    
                    var pnr = ""
                    if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                    {
                       pnr = pnrNumber
                    }else
                    {
                        pnr = "N/A"
                    }
                    
                    print("RequiredPNR0")
                    print(pnr)
                    let singleAttribute1 = [NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                    let singleAttribute2 = [NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                    
                    let singleAttribute3 = [NSForegroundColorAttributeName : UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: (0.0/255.0), alpha: 1.0) ]
                    
                   // let singleAttribute3 = [NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                    
                    
                    label_flight.attributedText = CommonValidations().attributedTextsNew(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2 , text3: pnrHeading ,attribs3: singleAttribute1, text4: pnr ,attribs4: singleAttribute3)
                    
                    img.image = #imageLiteral(resourceName: "one_way_black")
                }
                else if "\(dic.value(forKey: "booking_type")!)" == "round-trip"
                {
                    var date = ""
                    var date1 = ""
                    
                    if !(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date") is NSNull)
                    {
                        date = "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "depart_date")!)"
                    }
                    
                    if (dic.value(forKey: "flights") as! NSArray).count != 2 && (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time") != nil) && !(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time") is NSNull)
                    {
                       date1 = "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time")!)"
                    }
                    
                    
                    if (dic.value(forKey: "flights") as! NSArray).count == 2 && !(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "depart_date") is NSNull)
                    {
                        date1 = "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "depart_date")!)"
                    }
                    
                    
                    dateBtn.setTitle(((date1 != "") ? "\(df1.string(from: df.date(from: date)!))-\(df1.string(from: df.date(from: date1)!))" : "\(df1.string(from: df.date(from: date)!))"), for: .normal)
                    
                    img.image = #imageLiteral(resourceName: "two_way_black")
                    
                    //departure flight
                    let AirlineName = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_name")!)"
                    
                    let FlightNumber =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "flight_number")!)"
                    
                    let AirlineCode =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_code")!) "
                    
//                    let pnrNumber = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "pnr")!) "
//
//                    let pnrHeading = "  PNR: "
//                    //let pnr = pnrNumber
//
//
//                    var pnr = ""
//                    if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) != ""
//                    {
//                        pnr = pnrNumber
//                    }else
//                    {
//                        pnr = "N/A"
//                    }
//                    print("RequiredPNR1")
//                    print(pnr)
                    
                    let code = AirlineCode + FlightNumber
                    
                    let singleAttribute1 = [NSForegroundColorAttributeName: UIColor(red: (31.0/255.0), green: (88.0/255.0), blue: (169.0/255.0), alpha: 1.0)]
                    let singleAttribute2 = [NSForegroundColorAttributeName : UIColor(red: 172.0/255.0, green: 172.0/255.0, blue: (172.0/255.0), alpha: 1.0) ]
                    
                    let singleAttribute3 = [NSForegroundColorAttributeName : UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: (0.0/255.0), alpha: 1.0) ]
                
                    let str:NSMutableAttributedString  = (CommonValidations().attributedTexts(text1: AirlineName, attribs1: singleAttribute1, text2: code, attribs2: singleAttribute2))
                    
                    //return flight
                    var AirlineName1 = ""
                    var FlightNumber1 = ""
                    var AirlineCode1 = ""
                    var code1 = ""
                    var str2 = NSMutableAttributedString()
                  
                    if(((dic as NSDictionary).value(forKey: "flights") as! NSArray).count == 2)
                    {
                        AirlineName1 = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 1) as!  NSDictionary).value(forKey: "airline_name")!)"
                        
                        FlightNumber1 =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 1) as!  NSDictionary).value(forKey: "flight_number")!)"
                        
                        AirlineCode1 =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 1) as!  NSDictionary).value(forKey: "airline_code")!) "
                        
                        code1 = AirlineCode1 + FlightNumber1
                        
                        let pnrNumber = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "pnr")!) "
                        
                        let pnrNumber2 = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 1) as!  NSDictionary).value(forKey: "pnr")!) "
                        
                        let pnrHeading = "  PNR: "
                        
                        var pnr = ""
                        if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "" && pnrNumber2.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                        {
                           pnr = pnrNumber + "-\(pnrNumber2)"
                        }
                        else if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) == "" && pnrNumber2.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                        {
                            pnr = "N/A-" + pnrNumber2
                        }else if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) != "" && pnrNumber2.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                        {
                            pnr = pnrNumber + "-N/A"
                        }else
                        {
                           pnr = "N/A"
                        }
                        
                        print("RequiredPNR2")
                        print(pnr)
                        str2 = CommonValidations().attributedTextsNew(text1: AirlineName1, attribs1: singleAttribute1, text2: code1, attribs2: singleAttribute2, text3: pnrHeading ,attribs3: singleAttribute1, text4: pnr ,attribs4: singleAttribute3)
                        
                        let combination = NSMutableAttributedString()
                        combination.append(str)
                        let space = NSMutableAttributedString(string: " - ")
                        combination.append(space)
                        combination.append(str2)
                        //domesticinternational
                        label_flight.attributedText = combination
                        label_flight.adjustsFontSizeToFitWidth = true
                    }
                    else if((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_f_number") != nil && !(((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_f_number")!) is NSNull))
                    {
                         AirlineName1 = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_name")!)"
                        
                         FlightNumber1 =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "international_return_f_number")!)"
                        
                         AirlineCode1 =  "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "airline_code")!) "
                        
                        
                        let pnrNumber = "\((((dic as NSDictionary).value(forKey: "flights") as! NSArray).object(at: 0) as!  NSDictionary).value(forKey: "pnr")!) "
                        
                        let pnrHeading = "  PNR: "
                    
                        
                      //  let pnr = pnrNumber
                        
                        var pnr = ""
                        if pnrNumber.trimmingCharacters(in: .whitespacesAndNewlines) != ""
                        {
                            pnr = pnrNumber
                        }else
                        {
                            pnr = "N/A"
                        }

                        
                        print("RequiredPNR3")
                        print(pnr)
                        
                        code1 = AirlineCode1 + FlightNumber1
                        
                        str2 = CommonValidations().attributedTextsNew(text1: AirlineName1, attribs1: singleAttribute1, text2: code1, attribs2: singleAttribute2, text3: pnrHeading ,attribs3: singleAttribute1, text4: pnr ,attribs4: singleAttribute3)
                        
                        let combination = NSMutableAttributedString()
                        combination.append(str)
                        let space = NSMutableAttributedString(string: " - ")
                        combination.append(space)
                        combination.append(str2)
                        
                        label_flight.attributedText = combination
                        label_flight.adjustsFontSizeToFitWidth = true
                    }
                    else
                    {
                          label_flight.attributedText = str
                    }
                }
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
            let amount =  Double("\(dic.value(forKey: "grand_total")!)")!
            let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(amount)))
            let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 15)!])
            let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 12.0)!])
            normalString.append(attributedString1)
            money.attributedText = normalString
            
            DcityCode.text = (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "from_city_code")! is NSNull) ? "" : "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "from_city_code")!)"
            AcityCode.text = (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "to_city_code")! is NSNull) ? "" : "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "to_city_code")!)"
            DcityFull.text = (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "flight_from")! is NSNull) ? "" : "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "flight_from")!)"
            AcityFull.text = (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "flight_to")! is NSNull) ? "" : "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "flight_to")!)"
        }
        
        transId.adjustsFontSizeToFitWidth = true
        DcityCode.adjustsFontSizeToFitWidth = true
        //DcityFull.adjustsFontSizeToFitWidth = true
        AcityCode.adjustsFontSizeToFitWidth = true
        //AcityFull.adjustsFontSizeToFitWidth = true
        money.adjustsFontSizeToFitWidth = true
        dateBtn.adjustsImageWhenDisabled = true
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TransactionDetailViewController") as! TransactionDetailViewController
        
        var dic = NSMutableDictionary()
        if selectedState == "1"
        {
            dic = ((dataDic.value(forKey: "planned") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        else if selectedState == "2"
        {
            dic = ((dataDic.value(forKey: "complete") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        else if selectedState == "3"
        {
            dic = ((dataDic.value(forKey: "cancelled") as! NSArray).object(at: indexPath.row) as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        
        vc.dataDic.setValue("\(dic.value(forKey: "trace_id")!)", forKey: "TraceId")
        vc.dataDic.setValue(dic.value(forKey: "flights") as! NSArray, forKey: "flights")
        vc.dataDic.setValue("\(dic.value(forKey: "booking_type")!)", forKey: "booking_type")
        
        if(dic.value(forKey: "convenience_fee") != nil)
        {
            vc.dataDic.setValue("\(dic.value(forKey: "convenience_fee")!)", forKey: "convenience_fee")
            vc.dataDic.setValue("\(dic.value(forKey: "convenience_fee_type")!)", forKey: "convenience_fee_type")
        }
       
        if(dic.value(forKey: "charge_of_full_return") != nil && !(dic.value(forKey: "charge_of_full_return") is NSNull) && "\(dic.value(forKey: "charge_of_full_return")!)" != "")
        {
            vc.dataDic.setValue("\(dic.value(forKey: "charge_of_full_return")!)", forKey: "charge_of_full_return")
        }
        
        
        if (dic.value(forKey: "flights") as! NSArray).count == 1
        {
            if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)".trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                supportingfuction.showMessageHudWithMessage(message: "This booking was not ticketed.", delay: 2.0)
                return
            }
           
            
            if ((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).count) == 0
            {
                //\((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).count)
                vc.dataDic.setValue("0", forKey: "DepartCancel")
            }
            else
            {
                var arr = NSMutableArray()
                if let data = (((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "response") as! String).data(using: .utf8) {
                    do {
                        arr = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray).mutableCopy() as! NSMutableArray
                    } catch {
                        print(error.localizedDescription)
                    }
                }
                
                
                if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "4"
                {
                    vc.dataDic.setValue("4", forKey: "DepartCancel")
                    vc.dataDic.setValue(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "refund") as! NSArray, forKey: "refund")
                }
                else if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "1"
                {
                    vc.dataDic.setValue("1", forKey: "DepartCancel")
                }
            }
            
            if (dic.value(forKey: "flights") as! NSArray).count != 2 && (((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time") != nil) && !(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time") is NSNull)
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "international_return_time")!)", forKey: "international_return_time")
            }
            
            vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)", forKey: "PNR")
            vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)", forKey: "BookingId")
            
            if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)" != "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)" == "0"
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "first_name")!)", forKey: "first_name")
                vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "last_name")!)", forKey: "last_name")
            }
            
            vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "order_id")!)", forKey: "order_id")
        }
        else if (dic.value(forKey: "flights") as! NSArray).count == 2
        {
            if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)".trimmingCharacters(in: .whitespacesAndNewlines) == "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "pnr")!)".trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {
                supportingfuction.showMessageHudWithMessage(message: "This booking was not ticketed.", delay: 2.0)
                return
            }
            
            if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)" != ""
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)", forKey: "PNR")
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)", forKey: "BookingId")
                if ((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).count) == 0
                {
                    vc.dataDic.setValue("0", forKey: "DepartCancel")
                }
                else
                {
                    var arr = NSMutableArray()
                    if let data = (((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "response") as! String).data(using: .utf8) {
                        do {
                            arr = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray).mutableCopy() as! NSMutableArray
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "4"
                    {
                        vc.dataDic.setValue("4", forKey: "DepartCancel")
                        vc.dataDic.setValue(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "refund") as! NSArray, forKey: "refund")
                    }
                   else if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "1"
                    {
                        vc.dataDic.setValue("1", forKey: "DepartCancel")
                    }
                    
                }
                
                if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)" != "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)" == "0"
                {
                    vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "first_name")!)", forKey: "FirstName")
                    vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "last_name")!)", forKey: "LastName")
                }
                
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "order_id")!)", forKey: "order_id")
            }
            else
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "payable_amount")!)", forKey: "unsuccessful_booking_amount")
            }
            
            
            if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "pnr")!)" != ""
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "pnr")!)", forKey: "PNR1")
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "booking_id")!)", forKey: "BookingId1")
                
                if ((((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "cancelled") as! NSArray).count) == 0
                {
                    vc.dataDic.setValue("0", forKey: ((vc.dataDic.value(forKey: "DepartCancel") != nil) ? "ArriveCancel" : "DepartCancel"))
                }
                else
                {
                    var arr = NSMutableArray()
                    if let data = (((((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "cancelled") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "response") as! String).data(using: .utf8) {
                        do {
                            arr = try (JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSArray).mutableCopy() as! NSMutableArray
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                    
                    if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "4"
                    {
                        vc.dataDic.setValue("4", forKey: ((vc.dataDic.value(forKey: "DepartCancel") != nil) ? "ArriveCancel" : "DepartCancel"))
                        vc.dataDic.setValue(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "refund") as! NSArray, forKey: "refund1")
                    }
                    else if (arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus") != nil && "\((arr.object(at: 0) as! NSDictionary).value(forKey: "ChangeRequestStatus")!)" == "1"
                    {
                        vc.dataDic.setValue("1", forKey: ((vc.dataDic.value(forKey: "DepartCancel") != nil) ? "ArriveCancel" : "DepartCancel"))
                    }
                }
                
                
                
                if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "booking_id")!)" != "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "booking_id")!)" == "0"
                {
                    vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "first_name")!)", forKey: "first_name")
                    vc.dataDic.setValue("\(((dic.value(forKey: "passengers") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "last_name")!)", forKey: "last_name")
                }
                
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "order_id")!)", forKey: "order_id")
            }
            else
            {
                vc.dataDic.setValue("\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "payable_amount")!)", forKey: "unsuccessful_booking_amount")
            }
        }
        
        vc.dataDic.setValue("\(dic.value(forKey: "grand_total")!)", forKey: "grand_total")
        vc.dataDic.setValue("\(dic.value(forKey: "mark_up")!)", forKey: "mark_up")
        vc.dataDic.setValue("\(dic.value(forKey: "mark_down")!)", forKey: "mark_down")
        if dic.value(forKey: "discount") != nil && !(dic.value(forKey: "discount") is NSNull)
        {
            vc.dataDic.setValue("\(dic.value(forKey: "discount")!)", forKey: "discount")
        }
        vc.dataDic.setValue("\(selectedState)", forKey: "selected_transaction")
        vc.dataDic.setValue("\(dic.value(forKey: "payment_api_token")!)", forKey: "payment_api_token")
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK:- button handling
    @IBAction func sidemenu(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func sendtoHome(_ sender: UIButton) {
        
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc.restorationIdentifier == "HomeViewController"
            {
                _ = self.navigationController?.popToViewController(vc, animated: true)
                return
            }
        }
        
        let story = UIStoryboard(name: "Main", bundle: nil)
        let viewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v = story.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
        con.restorationIdentifier = "HomeViewController"
        self.navigationController?.viewControllers = [con]
    }
    
    @IBAction func swicthBtns(_ sender: UIButton) {
        
        let btn1 = btnheader.viewWithTag(1) as! UIButton
        let btn2 = btnheader.viewWithTag(2) as! UIButton
        let btn3 = btnheader.viewWithTag(3) as! UIButton
        btn1.isSelected = false
        btn2.isSelected = false
        btn3.isSelected = false
        let lbl1 = btnheader.viewWithTag(4) as! UILabel
        lbl1.textColor = supportingfuction.hexStringToUIColor(hex: "AABFDD")
        let lbl2 = btnheader.viewWithTag(5) as! UILabel
        lbl2.textColor = supportingfuction.hexStringToUIColor(hex: "AABFDD")
        let lbl3 = btnheader.viewWithTag(6) as! UILabel
        lbl3.textColor = supportingfuction.hexStringToUIColor(hex: "AABFDD")
        
        
        if sender.tag == 1
        {
            selectedState = "1"
            notripLbl.text = "No Trip Planned"
            sender.isSelected = true
            lbl1.textColor = UIColor.white
        }
        else if sender.tag == 2
        {
            selectedState = "2"
            notripLbl.text = "No Trip Completed"
            sender.isSelected = true
            lbl2.textColor = UIColor.white
        }
        else if sender.tag == 3
        {
            selectedState = "3"
            notripLbl.text = "No Trip Cancelled"
            sender.isSelected = true
            lbl3.textColor = UIColor.white
        }
        
        tblView.isHidden = true
        notripView.isHidden = true
        
        webservice()
    }
    
   
    func webservice()
    {
        tblView.isHidden = true
        notripView.isHidden = true
        
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                self.refreshControl.endRefreshing()
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                if (UserDefaults.standard.value(forKey: "userData") != nil) && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken") != nil
                {
                    requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                }
                else if (UserDefaults.standard.value(forKey: "user") != nil) && (UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "accessToken") != nil
                {
                    requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                }
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                
                let params = NSMutableDictionary()
                
                if selectedState == "1"
                {
                    params.setValue("planned", forKey: "list_type")
                }
                else if selectedState == "2"
                {
                    params.setValue("complete", forKey: "list_type")
                }
                else if selectedState == "3"
                {
                    params.setValue("cancelled", forKey: "list_type")
                }
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/user/transactions"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                if ((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "transactions") as! NSArray).count > 0
                                {
                                    if self.selectedState == "1"
                                    {
                                        self.dataDic.setValue(((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "transactions") as! NSArray), forKey: "planned")
                                    }
                                    else if self.selectedState == "2"
                                    {
                                        self.dataDic.setValue(((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "transactions") as! NSArray), forKey: "complete")
                                    }
                                    else if self.selectedState == "3"
                                    {
                                        self.dataDic.setValue(((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "transactions") as! NSArray), forKey: "cancelled")
                                    }
                                    self.tblView.reloadData()
                                    self.tblView.isHidden = false
                                    // self.sortArray()
                                }
                                else
                                {
                                    self.tblView.isHidden = true
                                }
                                self.notripView.isHidden = false
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    supportingfuction.hideProgressHudInView(view: self.view)
             //       print(error)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
}




//
//FlightItinerary =         {
//    AirlineCode = LH;
//    AirlineRemark = "";
//    BookingId = 45394;
//    CancellationCharges = "<null>";
//    CreditNoteCreatedOn = "<null>";
//    CreditNoteNo = "<null>";
//    Destination = LON;
//    Fare =             {
//        AdditionalTxnFeeOfrd = 0;
//        AdditionalTxnFeePub = 0;
//        BaseFare = 17200;
//        ChargeBU =                 (
//            {
//                key = TBOMARKUP;
//                value = 0;
//        },
//            {
//                key = CONVENIENCECHARGE;
//                value = 0;
//        },
//            {
//                key = OTHERCHARGE;
//                value = 10;
//        }
//        );
//        CommissionEarned = 0;
//        Currency = INR;
//        Discount = 0;
//        IncentiveEarned = 0;
//        OfferedFare = 56990;
//        OtherCharges = 10;
//        PGCharge = 0;
//        PLBEarned = 0;
//        PublishedFare = 56990;
//        ServiceFee = 0;
//        Tax = 39780;
//        TaxBreakup =                 (
//            {
//                key = YQ;
//                value = 24650;
//        },
//            {
//                key = YR;
//                value = 1233;
//        },
//            {
//                key = K3;
//                value = 2155;
//        },
//            {
//                key = IN;
//                value = 54;
//        },
//            {
//                key = WO;
//                value = 154;
//        },
//            {
//                key = DE;
//                value = 553;
//        },
//            {
//                key = RA;
//                value = 2848;
//        },
//            {
//                key = GB;
//                value = 6468;
//        },
//            {
//                key = UB;
//                value = 1665;
//        }
//        );
//        TdsOnCommission = 0;
//        TdsOnIncentive = 0;
//        TdsOnPLB = 0;
//        TotalBaggageCharges = 0;
//        TotalMealCharges = 0;
//        TotalSeatCharges = 0;
//        TotalSpecialServiceCharges = 0;
//        YQTax = 24650;
//    };
//    FareRules =             (
//        {
//            Airline = LH;
//            Destination = MUC;
//            FareBasisCode = LRCAA;
//            FareRestriction = N;
//            FareRuleDetail = "<ul><li><b>Advance Purchase</b><br>Fare Component <b>LRCAA</b>&emsp; Sector <b>DEL-LON</b> &nbsp;Fare Component <b>TRCAA</b>&emsp; Sector <b>LON-DEL</b> &nbsp;<ul><li>Earliest reservation date before departure <b>No restriction</b></li><li>Earliest ticketing date before departure <b>No restriction</b></li><li>Latest reservation date before departure <b>13DEC17  2359</b></li><li>Latest ticketing date before departure <b>27NOV17  2359</b></li><li>Latest ticketing date after reservation <b>27NOV17  2359</b></li></ul></li><li><b>Minimum Stay</b><br>Fare Component <b>TRCAA</b>&emsp; Sector <b>LON-DEL</b> &nbsp;<ul><li>Travel must commence after <b>25DEC17  0000 from LHR</b></li></ul></li><li><b>Maximum Stay</b><br>Fare Component <b>TRCAA</b>&emsp; Sector <b>LON-DEL</b> &nbsp;<ul><li>Travel must be completed before <b>No restriction</b></li><li>Travel must commence before <b>20DEC18  0000 from LHR</b></li></ul></li><fieldset><legend><b><b>Adult</b><br></b></legend><ul><li><b>Revalidation/Reissue</b><br>Fare Component <b>LRCAA</b>&emsp; Sector <b>DEL-LON</b> &nbsp;<ul><li>Revalidation before/after departure, including failure to show at first/subsequent flight(s) : <b>Allowed with Restrictions</b></li><li>Reissue before/after departure, including failure to show at first/subsequent flight(s) : <b>Allowed with Restrictions</b></li><li>Revalidation/Reissue request, including failure to show at first flight, must be made prior to <b>22NOV18  0000</b></li><li>Revalidation/Reissue request, including failure to show at subsequent flight(s), must be made prior to <b>20DEC18  0000</b></li><li><b>Prior to Departure of journey</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li><li><b>Failure to show at first flight</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li><li><b>After departure of journey</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li><li><b>Failure to show at subsequent flight(s)</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li></ul></li><li><b>Revalidation/Reissue</b><br>Fare Component <b>TRCAA</b>&emsp; Sector <b>LON-DEL</b> &nbsp;<ul><li>Revalidation, including failure to show at subsequent flight(s) : <b>Allowed with Restrictions</b></li><li>Reissue, including failure to show at subsequent flight(s) : <b>Allowed with Restrictions</b></li><li>Revalidation/Reissue request, including failure to show at first flight, must be made prior to <b>22NOV18  0000</b></li><li>Revalidation/Reissue request, including failure to show at subsequent flight(s), must be made prior to <b>20DEC18  0000</b></li><li><b>Prior to Departure of journey</b><ul><u>Revalidation</u> : <b>Allowed with Restrictions</b><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u> : <b>Allowed with Restrictions</b><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li><li><b>Failure to show at first flight</b><ul><li>Revalidation : <b>Not Allowed</b></li><li>Reissue : <b>Not Allowed</b></li></ul></li><li><b>After departure of journey</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li><li><b>Failure to show at subsequent flight(s)</b><ul><u>Revalidation</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum revalidation penalty fee for entire ticket (per revalidation) : <b>10015 INR</b></li><u>Reissue</u><li>Penalty fee : <b>10015 INR(at today exchange rates 10015 INR) </b></li><li>Maximum reissue penalty fee for entire ticket (per reissue) : <b>10015 INR</b></li></ul></li></ul></li><li><b>Refund</b><br>Fare Component <b>LRCAA</b>&emsp; Sector <b>DEL-LON</b> &nbsp;<ul><li>Refund before/after departure, including failure to show at first/subsequent flight(s) : <b>Allowed with Restrictions</b></li><li><b>Prior to Departure of journey</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></td></tr><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>Failure to show at first flight</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></li><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>After departure of journey</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></li><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>Failure to show at subsequent flight(s)</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></li><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li></ul></li><li><b>Refund</b><br>Fare Component <b>TRCAA</b>&emsp; Sector <b>LON-DEL</b> &nbsp;<ul><li>Refund, including failure to show at first flight : <b>Allowed with Restrictions</b></li><li><b>Prior to Departure of journey</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></td></tr><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>Failure to show at first flight</b><ul><li>Penalty fee : <b>14640 INR(at today exchange rates 14640 INR) </b></li><li>Maximum Refund penalty fee for entire ticket : <b>14640 INR</b></li><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>After departure of journey</b><ul><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li><li><b>Failure to show at subsequent flight(s)</b><ul><li>Refund request must be made prior to : <b>No restriction</b></li></ul></li></ul></li><br><b>* Revalidation is a modification of the original ticket without any reissue of a new ticket.</b><br><b>* For Reissue, Penalty fees are in addition to any difference in fare.</b><br><b>* For Refund, certain Taxes are non-refundable.</b></ul></fieldset></ul>";
//            Origin = DEL;
//    },
//        {
//            Airline = LH;
//            Destination = LHR;
//            FareBasisCode = LRCAA;
//            FareRestriction = Y;
//            FareRuleDetail = "Please refer above.";
//            Origin = MUC;
//    },
//        {
//            Airline = LH;
//            Destination = MUC;
//            FareBasisCode = TRCAA;
//            FareRestriction = N;
//            FareRuleDetail = "Please refer above.";
//            Origin = LHR;
//    },
//        {
//            Airline = LH;
//            Destination = DEL;
//            FareBasisCode = TRCAA;
//            FareRestriction = Y;
//            FareRuleDetail = "Please refer above.";
//            Origin = MUC;
//    }
//    );
//    FareType = RP;
//    InvoiceAmount = 56990;
//    InvoiceCreatedOn = "2017-11-22T11:33:08";
//    InvoiceNo = "IW/1718/2778";
//    InvoiceStatus = 3;
//    IsDomestic = 0;
//    IsLCC = 0;
//    IsManual = 0;
//    IssuancePcc = DELWI2216;
//    NonRefundable = 0;
//    Origin = DEL;
//    PNR = VY5KI4;
//    Passenger =             (
//        {
//            AddressLine1 = "Delhi, India";
//            City = Delhi;
//            ContactNo = 9044443264;
//            CountryCode = IN;
//            DateOfBirth = "1993-11-22T00:00:00";
//            Email = "vaibhav@singsys.com";
//            FFAirlineCode = "<null>";
//            FFNumber = "<null>";
//            Fare =                     {
//                AdditionalTxnFeeOfrd = 0;
//                AdditionalTxnFeePub = 0;
//                BaseFare = 17200;
//                ChargeBU =                         (
//                    {
//                        key = TBOMARKUP;
//                        value = 0;
//                },
//                    {
//                        key = CONVENIENCECHARGE;
//                        value = 0;
//                },
//                    {
//                        key = OTHERCHARGE;
//                        value = 10;
//                }
//                );
//                CommissionEarned = 0;
//                Currency = INR;
//                Discount = 0;
//                IncentiveEarned = 0;
//                OfferedFare = 56990;
//                OtherCharges = 10;
//                PGCharge = 0;
//                PLBEarned = 0;
//                PublishedFare = 56990;
//                ServiceFee = 0;
//                Tax = 39780;
//                TaxBreakup =                         (
//                    {
//                        key = YQ;
//                        value = 24650;
//                },
//                    {
//                        key = YR;
//                        value = 1233;
//                },
//                    {
//                        key = K3;
//                        value = 2155;
//                },
//                    {
//                        key = IN;
//                        value = 54;
//                },
//                    {
//                        key = WO;
//                        value = 154;
//                },
//                    {
//                        key = DE;
//                        value = 553;
//                },
//                    {
//                        key = RA;
//                        value = 2848;
//                },
//                    {
//                        key = GB;
//                        value = 6468;
//                },
//                    {
//                        key = UB;
//                        value = 1665;
//                }
//                );
//                TdsOnCommission = 0;
//                TdsOnIncentive = 0;
//                TdsOnPLB = 0;
//                TotalBaggageCharges = 0;
//                TotalMealCharges = 0;
//                TotalSeatCharges = 0;
//                TotalSpecialServiceCharges = 0;
//                YQTax = 24650;
//            };
//            FirstName = Jignesh;
//            Gender = 2;
//            IsLeadPax = 1;
//            LastName = Paori;
//            Meal =                     {
//                Code = "<null>";
//                Description = "<null>";
//            };
//            Nationality = IN;
//            PassportNo = 345698765;
//            PaxId = 62903;
//            PaxType = 1;
//            SegmentAdditionalInfo =                     (
//                {
//                    Baggage = "1 Units";
//                    FareBasis = LRCAA;
//                    Meal = "0 Platter";
//                    NVA = "";
//                    NVB = "";
//                    Seat = "";
//                    SpecialService = "";
//            },
//                {
//                    Baggage = "1 Units";
//                    FareBasis = LRCAA;
//                    Meal = "0 Platter";
//                    NVA = "";
//                    NVB = "";
//                    Seat = "";
//                    SpecialService = "";
//            },
//                {
//                    Baggage = "1 Units";
//                    FareBasis = TRCAA;
//                    Meal = "0 Platter";
//                    NVA = "";
//                    NVB = "";
//                    Seat = "";
//                    SpecialService = "";
//            },
//                {
//                    Baggage = "1 Units";
//                    FareBasis = TRCAA;
//                    Meal = "0 Platter";
//                    NVA = "";
//                    NVB = "";
//                    Seat = "";
//                    SpecialService = "";
//            }
//            );
//            Ticket =                     {
//                IssueDate = "2017-11-22T11:33:08";
//                Remarks = "";
//                ServiceFeeDisplayType = ShowInTax;
//                Status = OK;
//                TicketId = 37223;
//                TicketNumber = 5665133514;
//                ValidatingAirline = 220;
//            };
//            Title = Mrs;
//        }
//    );
//    Remarks = "";
//    Segments =             (
//        {
//            Airline =                     {
//                AirlineCode = LH;
//                AirlineName = Lufthansa;
//                FareClass = L;
//                FlightNumber = 763;
//                OperatingCarrier = LH;
//            };
//            AirlinePNR = VY5KI4;
//            Baggage = "<null>";
//            CabinBaggage = "<null>";
//            Craft = 359;
//            Destination =                     {
//                Airport =                         {
//                    AirportCode = MUC;
//                    AirportName = "Franz Josef Strauss";
//                    CityCode = MUC;
//                    CityName = Munich;
//                    CountryCode = DE;
//                    CountryName = Germany;
//                    Terminal = "2 ";
//                };
//                ArrTime = "2017-12-20T05:40:00";
//            };
//            Duration = 0;
//            FlightStatus = Confirmed;
//            GroundTime = 0;
//            IsETicketEligible = 0;
//            Mile = 0;
//            Origin =                     {
//                Airport =                         {
//                    AirportCode = DEL;
//                    AirportName = DEL;
//                    CityCode = DEL;
//                    CityName = Delhi;
//                    CountryCode = IN;
//                    CountryName = India;
//                    Terminal = "3 ";
//                };
//                DepTime = "2017-12-20T01:50:00";
//            };
//            Remark = "FULLY FLAT BED IN BUSINESS CLASS. SEE WWW.LH.COM, PLS INSERT PSGR CTC ALSO FOR RETURN FLIGHT, SEE RTSVC";
//            SegmentIndicator = 1;
//            Status = HK;
//            StopOver = 0;
//            StopPoint = "";
//            StopPointArrivalTime = "<null>";
//            StopPointDepartureTime = "<null>";
//            TripIndicator = 1;
//    },
//        {
//            AccumulatedDuration = 705;
//            Airline =                     {
//                AirlineCode = LH;
//                AirlineName = Lufthansa;
//                FareClass = L;
//                FlightNumber = 2470;
//                OperatingCarrier = LH;
//            };
//            AirlinePNR = VY5KI4;
//            Baggage = "<null>";
//            CabinBaggage = "<null>";
//            Craft = 32A;
//            Destination =                     {
//                Airport =                         {
//                    AirportCode = LHR;
//                    AirportName = Heathrow;
//                    CityCode = LON;
//                    CityName = London;
//                    CountryCode = GB;
//                    CountryName = "United Kingdom";
//                    Terminal = "2 ";
//                };
//                ArrTime = "2017-12-20T08:05:00";
//            };
//            Duration = 0;
//            FlightStatus = Confirmed;
//            GroundTime = 0;
//            IsETicketEligible = 0;
//            Mile = 0;
//            Origin =                     {
//                Airport =                         {
//                    AirportCode = MUC;
//                    AirportName = "Franz Josef Strauss";
//                    CityCode = MUC;
//                    CityName = Munich;
//                    CountryCode = DE;
//                    CountryName = Germany;
//                    Terminal = "2 ";
//                };
//                DepTime = "2017-12-20T07:00:00";
//            };
//            Remark = "<null>";
//            SegmentIndicator = 2;
//            Status = HK;
//            StopOver = 0;
//            StopPoint = "";
//            StopPointArrivalTime = "<null>";
//            StopPointDepartureTime = "<null>";
//            TripIndicator = 1;
//    },
//        {
//            Airline =                     {
//                AirlineCode = LH;
//                AirlineName = Lufthansa;
//                FareClass = T;
//                FlightNumber = 2471;
//                OperatingCarrier = LH;
//            };
//            AirlinePNR = VY5KI4;
//            Baggage = "<null>";
//            CabinBaggage = "<null>";
//            Craft = 32A;
//            Destination =                     {
//                Airport =                         {
//                    AirportCode = MUC;
//                    AirportName = "Franz Josef Strauss";
//                    CityCode = MUC;
//                    CityName = Munich;
//                    CountryCode = DE;
//                    CountryName = Germany;
//                    Terminal = "2 ";
//                };
//                ArrTime = "2018-01-08T11:30:00";
//            };
//            Duration = 0;
//            FlightStatus = Confirmed;
//            GroundTime = 0;
//            IsETicketEligible = 0;
//            Mile = 0;
//            Origin =                     {
//                Airport =                         {
//                    AirportCode = LHR;
//                    AirportName = Heathrow;
//                    CityCode = LON;
//                    CityName = London;
//                    CountryCode = GB;
//                    CountryName = "United Kingdom";
//                    Terminal = "2 ";
//                };
//                DepTime = "2018-01-08T08:45:00";
//            };
//            Remark = "<null>";
//            SegmentIndicator = 1;
//            Status = HK;
//            StopOver = 0;
//            StopPoint = "";
//            StopPointArrivalTime = "<null>";
//            StopPointDepartureTime = "<null>";
//            TripIndicator = 2;
//    },
//        {
//            AccumulatedDuration = 600;
//            Airline =                     {
//                AirlineCode = LH;
//                AirlineName = Lufthansa;
//                FareClass = T;
//                FlightNumber = 4287;
//                OperatingCarrier = LH;
//            };
//            AirlinePNR = VY5KI4;
//            Baggage = "<null>";
//            CabinBaggage = "<null>";
//            Craft = 346;
//            Destination =                     {
//                Airport =                         {
//                    AirportCode = DEL;
//                    AirportName = DEL;
//                    CityCode = DEL;
//                    CityName = Delhi;
//                    CountryCode = IN;
//                    CountryName = India;
//                    Terminal = "3 ";
//                };
//                ArrTime = "2018-01-09T00:15:00";
//            };
//            Duration = 0;
//            FlightStatus = Confirmed;
//            GroundTime = 0;
//            IsETicketEligible = 0;
//            Mile = 0;
//            Origin =                     {
//                Airport =                         {
//                    AirportCode = MUC;
//                    AirportName = "Franz Josef Strauss";
//                    CityCode = MUC;
//                    CityName = Munich;
//                    CountryCode = DE;
//                    CountryName = Germany;
//                    Terminal = "2 ";
//                };
//                DepTime = "2018-01-08T14:30:00";
//            };
//            Remark = "FULLY FLAT BED IN BUSINESS CLASS. SEE WWW.LH.COM, PLS INSERT PSGR CTC ALSO FOR RETURN FLIGHT, SEE RTSVC";
//            SegmentIndicator = 2;
//            Status = HK;
//            StopOver = 0;
//            StopPoint = "";
//            StopPointArrivalTime = "<null>";
//            StopPointDepartureTime = "<null>";
//            TripIndicator = 2;
//    }
//    );
//    Source = 4;
//    Status = 5;
//    ValidatingAirlineCode = LH;
//};
//ResponseStatus = 1;
//TraceId = "38fb3fbf-1c50-470a-99cd-d3c5db2862f7";

