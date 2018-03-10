//
//  SuccessViewController.swift
//  Tick8
//
//  Created by singsys on 9/10/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class SuccessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tblView: UITableView!
    var dataDic: NSMutableDictionary = NSMutableDictionary()
    var from = ""
    var success = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tblView.rowHeight = UITableViewAutomaticDimension;
        self.tblView.estimatedRowHeight = 500.0;
        webservice()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- tableview functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        var num = 0
        
        if success == "cancel"
        {
            if (self.from.range(of: "single") != nil)
            {
                num = 3
            }
            else
            {
                num = 4
            }
        }
        else if (self.from.range(of: "single") != nil) || (dataDic.value(forKey: "unsuccessful") != nil && (dataDic.value(forKey: "unsuccessful") as! NSArray).count == 1)
        {
            num = 5
        }
        else
        {
            num = 6
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var header:UIView = (Bundle.main.loadNibNamed("flightHeader", owner: self, options: nil)![0] as? UIView)!
        header.backgroundColor = supportingfuction.hexStringToUIColor(hex: "f5faff")
        let cityLbl = header.viewWithTag(1) as! UILabel
        let durationLbl = header.viewWithTag(2) as! UILabel
        let dateLbl = header.viewWithTag(3) as! UILabel
        var dic = NSMutableDictionary()
        
        if section ==  1 || (dataDic.value(forKey: "unsuccessful") != nil && (dataDic.value(forKey: "unsuccessful") as! NSArray).count == 1)
        {
            if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Destination") != nil
            {
                cityLbl.text = "\(dataDic.value(forKey: "Origin")!) - \(dataDic.value(forKey: "Destination")!)"
            }
            
            if (dataDic.value(forKey: "unsuccessful") == nil) || (dataDic.value(forKey: "unsuccessful") as! NSArray).contains("1")
            {
               dic = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            else if (dataDic.value(forKey: "unsuccessful") != nil && (dataDic.value(forKey: "unsuccessful") as! NSArray).contains("0"))
            {
               dic = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
           
        }
        else if section == 2 && (self.from.range(of: "double") != nil)
        {
            if from == "internationaldouble"
            {
                let arr = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).mutableCopy() as! NSMutableArray
                arr.removeObject(at: 0)
                let dic = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                dic.setValue(arr, forKey: "Segments")
                dataDic.setValue(dic, forKey: "flightDetail1")
            }
            
            if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Destination") != nil
            {
                cityLbl.text = "\(dataDic.value(forKey: "Destination")!) - \(dataDic.value(forKey: "Origin")!)"
            }
            
            dic = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }
        
        if dic.count > 0
        {
            let df = DateFormatter()
            let df1 = DateFormatter()
            
            df1.dateFormat = "hh:mm a"
            df1.amSymbol = "AM"
            df1.pmSymbol = "PM"
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if (dic.value(forKey: "Segments")) != nil
            {
                let dur:Int = Int(df.date(from: ((((dic.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dic.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dic.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
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
            
            df1.dateFormat = "dd MMM"
            dateLbl.text = "\(df1.string(from:  df.date(from: ((((dic.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))"
            
//            let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//            let df = DateFormatter()
//            df.dateFormat = "YYYY-MM-dd'T'HH:mm:ss"
//
//            let stDate = df.date(from: ((((dic.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)
//            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
//            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
//            let m = components.month!
//
//
//            if components.day! < 10
//            {
//                dateLbl.text = "0\(components.day!) \((months.object(at: m-1) as! String))"
//            }
//            else
//            {
//                dateLbl.text = "\(components.day!) \((months.object(at: m-1) as! String))"
//            }
            
            if from == "internationaldouble"
            {
                dataDic.removeObject(forKey: "flightDetail1")
            }
        }
        else
        {
            header = UIView()
            return header
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 1 || ((self.from.range(of: "double") != nil) && section == 2 && dataDic.value(forKey: "unsuccessful") == nil)
        {
            return 35
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        
//        if section == 0
//        {
//            num = 1
//        }
//            //(dataDic.value(forKey: "unsuccessful") != nil && (dataDic.value(forKey: "unsuccessful") as! NSArray).count == 1)
//        else if ((self.from.range(of: "single") != nil) && section == 1) || ((self.from.range(of: "double") != nil) && section == 1) || ((self.from.range(of: "double") != nil) && section == 2)
//        {
//            num = 1
//        }
//        else if section == ((self.from.range(of: "single") != nil) ? 2 : 3) && success != "cancel"
//        {
//            num = 1 + Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!
//        }
//        else
//        {
//            num = 1
//        }
        
        if section == (((self.from.range(of: "single") != nil) || dataDic.value(forKey: "unsuccessful") != nil)  ? 2 : 3) && success != "cancel"
        {
             num = 1 + Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!
        }
        else
        {
            num = 1
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = UITableViewAutomaticDimension
        
        if indexPath.section == 0
        {
            height = 250
        }
        else if indexPath.section == 1 || ((indexPath.section == 2) && (self.from.range(of: "double") != nil) && dataDic.value(forKey: "unsuccessful") == nil)
        {
            height = 120
        }
        else if indexPath.section == (((self.from.range(of: "single") != nil) || dataDic.value(forKey: "unsuccessful") != nil) ? 2 : 3)
        {
            if (indexPath.row == 0) || (indexPath.row < 1 + Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!)
            {
                height = 40
            }
            else
            {
                height = 50
            }
        }
        else
        {
            height = 80
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
       
        if indexPath.section == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            let img = cell.viewWithTag(1) as! UIImageView
            let booking = cell.viewWithTag(2) as! UILabel
            let trans = cell.viewWithTag(3) as! UILabel
            trans.isHidden = false
            trans.text = ""
            if success == "success"
            {
                img.image = #imageLiteral(resourceName: "success")
                
                if dataDic.value(forKey: "unsuccessful") == nil
                {
                     booking.text = "Booking Successful"
                }
                else
                {
                     booking.text = "Booking Partially Successful"
                }
               
                booking.textColor = supportingfuction.hexStringToUIColor(hex: "17c175")
                if dataDic.value(forKey: "data") != nil
                {
                    let text = "Transaction ID: \((dataDic.value(forKey: "data") as! NSDictionary).value(forKey: "payment_api_token")!)"
                    let range = (text as NSString).range(of: "Transaction ID:")
                    let attributedString = NSMutableAttributedString(string: text)
                    attributedString.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range)
                    trans.attributedText = attributedString
                }
                
            }
            else if success == "fail"
            {
                img.image = #imageLiteral(resourceName: "unsuccess")
                booking.text = "Booking Unsuccessful"
                booking.textColor = supportingfuction.hexStringToUIColor(hex: "ffc411")
                trans.isHidden = true
            }
            else if success == "cancel"
            {
                img.image = #imageLiteral(resourceName: "canceled")
                booking.text = "Payment Cancelled"
                booking.textColor = supportingfuction.hexStringToUIColor(hex: "ed5d52")
                trans.isHidden = true
            }
        }
        else if indexPath.section == 1 || (indexPath.section == 2 && (self.from.range(of: "double") != nil) && dataDic.value(forKey: "unsuccessful") == nil)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "tripCell")!
            let Dtimelbl = cell.viewWithTag(1) as! UILabel
            let Atimelbl = cell.viewWithTag(3) as! UILabel
            let DaddressLbl = cell.viewWithTag(4) as! UILabel
            let DcityLbl = cell.viewWithTag(9) as! UILabel
            let AcityLbl = cell.viewWithTag(10) as! UILabel
            let aAddresslbl = cell.viewWithTag(6) as! UILabel
            var dict = NSMutableDictionary()
            
            if indexPath.section == 1 && (dataDic.value(forKey: "flightDetail") != nil)
            {
                dict = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            else if (indexPath.section == 2)
            {
                if self.from == "internationaldouble"
                {
                    let arr = ((self.dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).mutableCopy() as! NSMutableArray
                    arr.removeObject(at: 0)
                    let dict = (self.dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dict.setValue(arr, forKey: "Segments")
                    self.dataDic.setValue(dict, forKey: "flightDetail1")
                }
                
                dict = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            
            if dict.count > 0
            {
                //let dict = dataDic.value(forKey: "flightDetail") as! NSDictionary
                let df = DateFormatter()
                let df1 = DateFormatter()
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                
                
                Dtimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                Atimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                DaddressLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                aAddresslbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                DcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                DcityLbl.adjustsFontSizeToFitWidth = true
                
                AcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                AcityLbl.adjustsFontSizeToFitWidth = true
            }
            
            if from == "internationaldouble" && dataDic.value(forKey: "flightDetail1") != nil
            {
                dataDic.removeObject(forKey: "flightDetail1")
            }
            
            Atimelbl.adjustsFontSizeToFitWidth = true
            Dtimelbl.adjustsFontSizeToFitWidth = true
        }
        else if indexPath.section == (((self.from.range(of: "single") != nil) || dataDic.value(forKey: "unsuccessful") != nil) ? 2 : 3) && success != "cancel"
        {
            
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                count.textColor = UIColor.lightGray
                heading.font = UIFont(name: "Arimo-Bold", size: 15)
                
                let imgView = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = false
                heading.text = "Traveller Information"
                count.isHidden = false
                
                count.text = (dataDic.value(forKey: "Passengers") == nil || (dataDic.value(forKey: "Passengers") as! NSArray).count == 0) ? "0 Pax" : "\((dataDic.value(forKey: "Passengers") as! NSArray).count) Pax"
                count.adjustsFontSizeToFitWidth = true
            }
            else
            {
                if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).count != 0
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                    let txtfld = cell.viewWithTag(1) as! UILabel
                    let txtfld1 = cell.viewWithTag(2) as! UILabel
                    let imgView = cell.viewWithTag(3) as! UIImageView
                    imgView.isHidden = true
                    txtfld1.isHidden = true
                    txtfld.font = UIFont(name: txtfld1.font.fontName, size: 13.0)
                    txtfld1.font = UIFont(name: "Arimo", size: 13.0)
                    
                    if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "first_name") != nil && ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "last_name") as! String != ""
                    {
                        txtfld.text = "\(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "first_name")!) \(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "last_name")!)"
                        txtfld.font = UIFont(name: "Arimo-Regular", size: 15)
                    }
                    else
                    {
                        txtfld.text = ""
                    }
                }
            }
        }
        else if indexPath.section ==  (((self.from.range(of: "single") != nil) || dataDic.value(forKey: "unsuccessful") != nil) ? 3 : 4) && success != "cancel"
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            let totalPriceLbl = cell.viewWithTag(1) as! UILabel
            totalPriceLbl.text = "Payment Info"
            totalPriceLbl.font = UIFont(name: "Arimo-Bold", size: 15)
            totalPriceLbl.textColor = UIColor.black
            
            let money = cell.viewWithTag(2) as! UILabel
            money.textColor = UIColor.black
            money.font = UIFont(name: "Arimo-Bold", size: 15)
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = .none
            numberFormatter.groupingSeparator = ","
            numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
            
            if #available(iOS 9.0, *) {
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            } else {
                // Fallback on earlier versions
            }
            
            if dataDic.value(forKey: "data") != nil
            {
                let total = Double("\((dataDic.value(forKey: "data") as! NSDictionary).value(forKey: "grand_total")!)")
                let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(total!)))
                
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                normalString.append(attributedString1)
                money.attributedText = normalString
                money.textColor = supportingfuction.hexStringToUIColor(hex: "353535")
                money.adjustsFontSizeToFitWidth = true
            }
            else
            {
                money.text = ""
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
            let btn = cell.viewWithTag(1) as! UIButton
            btn.layer.cornerRadius = 17
           
            if success == "cancel" || success == "fail"
            {
                btn.setTitle("PLAN A TRIP", for: .normal)
            }
            else if success == "success"
            {
                btn.setTitle("VIEW MORE DETAILS", for: .normal)
            }
        }
        return cell
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let viewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v = story.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
        con.restorationIdentifier = "HomeViewController"
        self.navigationController?.viewControllers = [con]
    }
    
    @IBAction func jumpBtn(_ sender: UIButton) {
        
        if success == "success"
        {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
            let v = story.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
            let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
            con.restorationIdentifier = "TransactionViewController"
            self.navigationController?.viewControllers = [con]
        }
        else if success == "cancel" || success == "fail"
        {
            let story = UIStoryboard(name: "Main", bundle: nil)
            let viewController = story.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            let v = story.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
            let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
            con.restorationIdentifier = "HomeViewController"
            self.navigationController?.viewControllers = [con]
        }
    }
    
    func webservice()
    {
        self.tblView.isHidden = true
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
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
                params.setValue("\(dataDic.value(forKey: "order_id")!)", forKey: "order_id")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/user/orderdetail"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                if ((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "order") as! NSArray).count > 0
                                {
                                    let dic = ((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "order") as! NSArray).object(at: 0) as! NSDictionary
                                    self.dataDic.setValue(dic, forKey: "data")
                                    
                                    if self.from == "success"
                                    {
                                        let arr = NSMutableArray()
                                        
                                        if "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "pnr")!)" == "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "booking_id")!)" == ""
                                        {
                                            arr.add("0")
                                            self.dataDic.setValue(arr, forKey: "unsuccessful")
                                        }
                                        
                                        if  (dic.value(forKey: "flights") as! NSArray).count == 2 && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "pnr")!)" == "" && "\(((dic.value(forKey: "flights") as! NSArray).object(at: 1) as! NSDictionary).value(forKey: "booking_id")!)" == ""
                                        {
                                            arr.add("1")
                                            self.dataDic.setValue(arr, forKey: "unsuccessful")
                                        }
                                    }
                                    self.tblView.isHidden = false
                                }
                                else
                                {
                                    self.tblView.isHidden = true
                                }
                                
                                self.tblView.reloadData()
                            }
                            else
                            {
                                self.tblView.isHidden = false
                                self.tblView.reloadData()
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    supportingfuction.hideProgressHudInView(view: self.view)
                   // print(error)
                    self.tblView.isHidden = false
                    self.tblView.reloadData()
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
