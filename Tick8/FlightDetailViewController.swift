//
//  FlightDetailViewController.swift
//  Tick8
//
//  Created by singsys on 11/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class FlightDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tblView: UITableView!
    var dataDic = NSMutableDictionary()
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()
        self.tblView.isHidden = true
        self.tblView.rowHeight = UITableViewAutomaticDimension;
        self.tblView.estimatedRowHeight = 500.0;
        
        if (self.from.range(of: "single") != nil) || from == "internationaldouble"
        {
            getFareRule(n: 0)
        }
        else
        {
            getFareRule(n: 0)
            getFareRule(n: 1)
        }
        
        
        // Do any additional setup after loading the view.
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
        let dateView = headerView.viewWithTag(4) as! UILabel
        let economy = headerView.viewWithTag(5) as! UILabel
        let img = headerView.viewWithTag(11) as! UIImageView
        
        if (self.from.range(of: "single") != nil)
        {
            img.image = #imageLiteral(resourceName: "oneWayD")
        }
        else
        {
            img.image = #imageLiteral(resourceName: "twoWay")
        }
        
        let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        var date = ""
        
        if dataDic.value(forKey: "PreferredDepartureTime") != nil && dataDic.value(forKey: "PreferredDepartureTime") is String
        {
            let stDate = df.date(from: dataDic.value(forKey: "PreferredDepartureTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            
            if components.day! < 10
            {
                date = "0\(components.day!) \((months.object(at: m-1) as! String)) "
            }
            else
            {
                date = "\(components.day!) \((months.object(at: m-1) as! String)) "
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
                date.append("- 0\(components.day!) \((months.object(at: m-1) as! String))")
            }
            else
            {
                date.append("- \(components.day!) \((months.object(at: m-1) as! String))")
            }
        }
        
        dateView.text = date
        dateView.adjustsFontSizeToFitWidth = true
        if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Origin") is String
        {
            Dcity.text = dataDic.value(forKey: "Origin") as? String
        }
        
        if dataDic.value(forKey: "Destination") != nil && dataDic.value(forKey: "Destination") is String
        {
            Acity.text = dataDic.value(forKey: "Destination") as? String
        }
        
        if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") is String
        {
            economy.text = dataDic.value(forKey: "class") as? String
        }
        
        passenger.text = "\(Int(dataDic.value(forKey: "AdultCount") as! String)! + Int(dataDic.value(forKey: "ChildCount") as! String)! + Int(dataDic.value(forKey: "InfantCount") as! String)!) Pax"
        passenger.adjustsFontSizeToFitWidth = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- table view handling
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if (self.from.range(of: "single") != nil) && dataDic.value(forKey: "fareRule") != nil
        {
            return 2
        }
        else if (self.from.range(of: "single") != nil) && dataDic.value(forKey: "fareRule") == nil
        {
            return 1
        }
        else if (from == "double" || from == "internationaldouble") && dataDic.value(forKey: "fareRule") != nil
        {
            return 3
        }
        else if (from == "double" || from == "internationaldouble") && dataDic.value(forKey: "fareRule") == nil
        {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header:UIView = (Bundle.main.loadNibNamed("flightHeader", owner: self, options: nil)![0] as? UIView)!
        header.backgroundColor = UIColor.clear
        header.backgroundColor = UIColor(red: 245/255, green: 250/255, blue: 255/255, alpha: 1.0)
        let cityLbl = header.viewWithTag(1) as! UILabel
        let durationLbl = header.viewWithTag(2) as! UILabel
        let dateLbl = header.viewWithTag(3) as! UILabel
        var dict = NSMutableDictionary()
        
        if section == 0 && ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments")) != nil
        {
            dict = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Destination") != nil
            {
                cityLbl.text = "\(dataDic.value(forKey: "Origin")!) - \(dataDic.value(forKey: "Destination")!)"
            }
        }
        else if (from == "double" || from == "internationaldouble") && section == 1
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
            
            dict = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        }

        if dict.count > 0
        {
            let df = DateFormatter()
            let df1 = DateFormatter()
            
            df1.dateFormat = "hh:mm a"
            df1.amSymbol = "AM"
            df1.pmSymbol = "PM"
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
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
            
            df1.dateFormat = "dd MMM"
            dateLbl.text = "\(df1.string(from:  df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))"
            
//            let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
//
//            let stDate = df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)
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
            
            if from == "internationaldouble" && dataDic.value(forKey: "flightDetail1") != nil
            {
                dataDic.removeObject(forKey: "flightDetail1")
            }
        }
        else
        {
            //if ((self.from.range(of: "single") != nil) && section == 1) || (from == "double" && section == 2) || (from == "internationaldouble" && section == 2)
            header.isHidden = true
            return header
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if (self.from.range(of: "single") != nil) && section == 0 && (dataDic.value(forKey: "flightDetail") != nil)
        {
                return (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
        }
        else if from == "double"
        {
            if section == 0 && (dataDic.value(forKey: "flightDetail") != nil)
            {
                return (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
            else if section == 1 && (dataDic.value(forKey: "flightDetail1") != nil)
            {
                return (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
        }
        else if from == "internationaldouble"
        {
            if section == 0 && (dataDic.value(forKey: "flightDetail") != nil)
            {
                return (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count
            }
            else if section == 1 && (dataDic.value(forKey: "flightDetail") != nil)
            {
                return (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count
            }
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 200
        
        if (self.from.range(of: "single") != nil) && dataDic.value(forKey: "flightDetail") != nil
        {
            if indexPath.section == 0
            {
                if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 135
                }
            }
            else
            {
                height = UITableViewAutomaticDimension
            }
        }
        else
        {
            if indexPath.section == 0
            {
                if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 145
                }
            }
            else if indexPath.section == 1 && from == "double"
            {
                if  (dataDic.value(forKey: "flightDetail1") != nil) && indexPath.row < (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 135
                }
            }
            else if indexPath.section == 1 && from == "internationaldouble"
            {
                if indexPath.row < (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count - 1
                {
                    height = 185
                }
                else
                {
                    height = 135
                }
            }
            else
            {
                height = UITableViewAutomaticDimension
            }
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0 || ((from == "double" || from == "internationaldouble") && indexPath.section == 1)
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
            var dict = NSMutableDictionary()
            
            if indexPath.section == 0
            {
                dict = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            else
            {
                if from == "internationaldouble"
                {
                    let arr = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).mutableCopy() as! NSMutableArray
                    arr.removeObject(at: 0)
                    let dic = (dataDic.value(forKey: "flightDetail") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                    dic.setValue(arr, forKey: "Segments")
                    dataDic.setValue(dic, forKey: "flightDetail1")
                }
                
                dict = (dataDic.value(forKey: "flightDetail1") as! NSDictionary).mutableCopy() as! NSMutableDictionary
            }
            
            if dict.count > 0
            {
              //  let dict = dataDic.value(forKey: "flightDetail") as! NSDictionary
                let df = DateFormatter()
                let df1 = DateFormatter()
                
                df1.dateFormat = "hh:mm a"
                df1.amSymbol = "AM"
                df1.pmSymbol = "PM"
                df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                
                
                Dtimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!)
                
                Atimelbl.text = df1.string(from: df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey:
                    "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!)
                
                let dur:Int = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!.timeIntervalSince(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!))
                
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
                if((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Baggage") != nil && !(((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Baggage")) is NSNull))
                {
                    let str = ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Baggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage = "\(str)s check in baggage"
                    }
                    else
                    {
                        baggage = "\(str) check in baggage"
                    }
                    
                }
                
                if((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") != nil && !(((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage")) is NSNull))
                {
                    let str = ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "CabinBaggage") as! String).trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                    
                    if str.contains("kg") || str.contains("Kg")
                    {
                        baggage.append(" | \(str)s hand baggage")
                    }
                    else
                    {
                        baggage.append(" | \(str) hand baggage")
                    }
                    
                }
                baggageLbl.text = baggage
                
                DaddressLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                aAddresslbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "AirportName") as! String)"
                
                DcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                DcityLbl.adjustsFontSizeToFitWidth = true
                
                AcityLbl.text = "\((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), \((((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String)"
                AcityLbl.adjustsFontSizeToFitWidth = true
                
                
                if indexPath.row < ((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count - 1
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
                    
                    
                    let layovertime = Int(df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row+1) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String)!.timeIntervalSince( df.date(from: ((((dict.value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey:"Destination") as! NSDictionary).value(forKey: "ArrTime") as! String)!))
                    
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
            
            if from == "internationaldouble" && dataDic.value(forKey: "flightDetail1") != nil
            {
                dataDic.removeObject(forKey: "flightDetail1")
            }
            
            DurationLbl.adjustsFontSizeToFitWidth = true
            Atimelbl.adjustsFontSizeToFitWidth = true
            Dtimelbl.adjustsFontSizeToFitWidth = true
            baggageLbl.adjustsFontSizeToFitWidth = true
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "fareCell")!
            let penaltylbl = cell.viewWithTag(1) as! UILabel
            penaltylbl.numberOfLines = 3
            
            if dataDic.value(forKey: "fareRule") != nil
            {
                penaltylbl.attributedText = (dataDic.value(forKey: "fareRule") as! NSAttributedString)
            }
        }
         return cell
    }
        
        //MARK:- button handling
        @IBAction func backBtn(_ sender: UIButton) {
            _ = self.navigationController?.popViewController(animated: true)
        }
        
        @IBAction func continueBtn(_ sender: UIButton)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FlightDetailBookViewController") as! FlightDetailBookViewController
            vc.dataDic.setValue(dataDic.value(forKey: "Origin") as? String, forKey: "Origin")
            vc.dataDic.setValue(dataDic.value(forKey: "Destination") as? String, forKey: "Destination")
            vc.dataDic.setValue(dataDic.value(forKey: "PreferredDepartureTime") as? String, forKey: "PreferredDepartureTime")
            vc.dataDic.setValue(dataDic.value(forKey: "class") as? String, forKey: "class")
            vc.dataDic.setValue(dataDic.value(forKey: "AdultCount") as? String, forKey: "AdultCount")
            vc.dataDic.setValue(dataDic.value(forKey: "ChildCount") as? String, forKey: "ChildCount")
            vc.dataDic.setValue(dataDic.value(forKey: "InfantCount") as? String, forKey: "InfantCount")
            vc.dataDic.setValue(dataDic.value(forKey: "flightDetail") as? NSDictionary, forKey: "flightDetail")
            vc.dataDic.setValue(dataDic.value(forKey: "fareRule") as? NSAttributedString, forKey: "fareRule")
   
            vc.dataDic.setValue("\((dataDic.value(forKey: "TraceId")!))", forKey: "TraceId")
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
            
            vc.from = "single"
            
            if from == "internationalsingle"
            {
                vc.from = "internationalsingle"
            }
            else if from == "double"
            {
                vc.from = "double"
                vc.dataDic.setValue(dataDic.value(forKey: "fareRule1") as? NSAttributedString, forKey: "fareRule1")
                vc.dataDic.setValue(dataDic.value(forKey: "PreferredArrivalTime") as? String, forKey: "PreferredArrivalTime")
                vc.dataDic.setValue(dataDic.value(forKey: "flightDetail1") as? NSDictionary, forKey: "flightDetail1")
            }
            else if from == "internationaldouble"
            {
                vc.from = "internationaldouble"
                vc.dataDic.setValue(dataDic.value(forKey: "PreferredArrivalTime") as? String, forKey: "PreferredArrivalTime")
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        @IBAction func viewfareRules(_ sender: UIButton)
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareRulesViewController") as! FareRulesViewController
            
            if (from.range(of: "single") != nil) || from == "internationaldouble"
            {
                vc.dataDic.setValue((dataDic.value(forKey: "fareRule") as! NSAttributedString), forKey: "fareRule")
                vc.from = "single"
            }
            else
            {
                vc.dataDic.setValue((dataDic.value(forKey: "fareRule") as! NSAttributedString), forKey: "fareRule")
                vc.from = "double"
                vc.dataDic.setValue((dataDic.value(forKey: "fareRule1") as! NSAttributedString), forKey: "fareRule1")
            }
            
            self.present(vc, animated: true, completion: nil)
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
    
        
        func getFareRule(n: Int)
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
                    
                    manager.requestSerializer = requestSerializer
                    requestSerializer.timeoutInterval = 120
                    
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                    let params = NSMutableDictionary()
                    if UserDefaults.standard.value(forKey: "EndUserIp") == nil
                    {
                        appDel.getIpWebservice()
                        NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailViewController.getFareRule), name: Notification.Name("ipGenerated"), object: nil)
                        return
                    }
                    else
                    {
                         NotificationCenter.default.removeObserver(self, name: Notification.Name("ipGenerated"), object: nil)
                        params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
                    }
                    
                    params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
                    params.setValue(dataDic.value(forKey: "TraceId") as! String, forKey: "TraceId")
                    
                    if n == 0
                    {
                        params.setValue((dataDic.value(forKey: "flightDetail") as? NSDictionary)?.value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
                    }
                    else
                    {
                        params.setValue((dataDic.value(forKey: "flightDetail1") as? NSDictionary)?.value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
                    }
                    
                    manager.post(("\(BOOK_URL)FareRule"), parameters: params, progress: nil, success:
                        {
                            requestOperation, response  in
                            
                            var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                            
                            if response is NSDictionary
                            {
                                dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                           
                                if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "4")
                                {
                                    appDel.getIpWebservice()
                                    NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailViewController.getFareRule), name: Notification.Name("ipGenerated"), object: nil)
                                    return
                                }
                                else if ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") != nil) && ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") is NSArray) && ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") as! NSArray).count != 0
                                {
                                    if ((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) is NSDictionary && (((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "FareRuleDetail") != nil
                                    {
                                        let html = (((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "FareRules") as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "FareRuleDetail") as! String
                                        
                                        if (self.from.range(of: "single") != nil) || self.from == "internationaldouble"
                                        {
                                            self.dataDic.setValue(self.stringFromHtml(string: html)!, forKey: "fareRule")
                                            self.tblView.isHidden = false
                                            self.tblView.reloadData()
                                            supportingfuction.hideProgressHudInView(view: self.view)
                                        }
                                        else
                                        {
                                            if n == 0
                                            {
                                                self.dataDic.setValue(self.stringFromHtml(string: html)!, forKey: "fareRule")
                                            }
                                            else
                                            {
                                                self.dataDic.setValue(self.stringFromHtml(string: html)!, forKey: "fareRule1")
                                            }
                                            
                                            if self.dataDic.value(forKey: "fareRule") != nil && self.dataDic.value(forKey: "fareRule1") != nil
                                            {
                                                self.tblView.isHidden = false
                                                self.tblView.reloadData()
                                                supportingfuction.hideProgressHudInView(view: self.view)
                                            }
                                        }
                                    }
                                }
                                else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "1")
                                {
                                    self.tblView.isHidden = false
                                    self.tblView.reloadData()
                                    supportingfuction.hideProgressHudInView(view: self.view)
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
                    supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
                    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                        // Put your code which should be executed with a delay here
                        _ = self.navigationController?.popViewController(animated: true)
                    })
                }
            }
        }
        
}
