//
//  FlightDetailBookViewController.swift
//  Tick8
//
//  Created by singsys on 14/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class FlightDetailBookViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, passengerDetail {
    
    @IBOutlet weak var book: UIButton!
    @IBOutlet weak var totalPay: UIButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var headerView: UIView!
    var tapGesture = UITapGestureRecognizer()
    var from = ""
    var show = 0
    var offered = 0
    var couponOpen = false
    var fareQuoteHit = false
    var dataDic:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailBookViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailBookViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let dic = NSMutableDictionary()
        let arr = NSMutableArray()
        for _ in 0..<(Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!)
        {
            arr.add(dic)
        }
        dataDic.setValue(arr, forKey: "Passengers")
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(FlightDetailBookViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        self.tblView.rowHeight = UITableViewAutomaticDimension;
        self.tblView.estimatedRowHeight = 500.0;
        
        setTimeValues()
        setMoneyValues()
       // setValues()
        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
     func setTimeValues()
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
            img.contentMode = .center
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
    
//    func setMoneyValues()
//    {}
    
    func setMoneyValues()
    {
        //total amount value
        var dfare = 0
        var rfare = 0
        
        if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
        {
            dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
        }
        else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
        {
            var amount = 0
            if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
            {
                amount = Int("\(dataDic.value(forKey: "mark_up_corporate")!)")! * (dataDic.value(forKey: "Passengers") as! NSArray).count
            }
            dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + amount
        }
        else
        {
            dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
        }
        
        if from == "double"
        {
            if couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
            {
                rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
            }
            else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
            {
                var amount = 0
                if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                {
                    amount = Int("\(dataDic.value(forKey: "mark_up_corporate")!)")! * (dataDic.value(forKey: "Passengers") as! NSArray).count
                }
                rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + amount
            }
            else
            {
                rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
            }
        }
        
        
        var fee = 0.0
        if from == "single"
        {
            fee = Double("\(dataDic.value(forKey: "one_way")!)")!
        }
        else if from == "double"
        {
            fee = Double("\(dataDic.value(forKey: "round_trip")!)")!
        }
        else if from == "internationalsingle"
        {
            if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_one_way_cap")!)")!))!
            {
                fee = Double("\(dataDic.value(forKey: "inter_one_way")!)")!
            }
            else
            {
                fee = Double("\(dataDic.value(forKey: "inter_one_way2")!)")!
            }
            
        }
        else if from == "internationaldouble"
        {
            if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_round_trip_cap")!)")!))!
            {
                fee = Double("\(dataDic.value(forKey: "inter_round_trip")!)")!
            }
            else
            {
                fee = Double("\(dataDic.value(forKey: "inter_round_trip2")!)")!
            }
            
        }
        
        var total = dfare + rfare
        total = total + (Int(fee) * (dataDic.value(forKey: "Passengers") as! NSArray).count)
        
        if dataDic.value(forKey: "discount_value") != nil
        {
            total = total - Int("\(dataDic.value(forKey: "discount_value")!)")!
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
        let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
        
        
        let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: (totalPay.titleLabel?.font.fontName)!, size: 14)!])
        attributedString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, attributedString1.length))
        let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: (totalPay.titleLabel?.font.fontName)!, size: 11.0)!])
        normalString.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, normalString.length))
        let normalString1 = NSMutableAttributedString(string: "Total Pay ",  attributes: [NSFontAttributeName : UIFont.init(name: (totalPay.titleLabel?.font.fontName)!, size: 14.0)!])
        normalString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.white, range: NSMakeRange(0, normalString1.length))
        
        normalString.append(attributedString1)
        normalString1.append(normalString)
        
        totalPay.setAttributedTitle(normalString1, for: .normal)
        totalPay.titleLabel?.adjustsFontSizeToFitWidth = true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tblView!.contentInset = contentInsets
        tblView!.scrollIndicatorInsets = contentInsets;
    }
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tblView!.contentInset = contentInsets
        tblView!.scrollIndicatorInsets = contentInsets;
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    func doneKeyboard(textField : UITextField, width: CGFloat, height: CGFloat)
    {
        let keyboardDoneButtonShow =  UIToolbar(frame: CGRect(x: 0, y: 0, width: width, height: height/17))
        
        //Setting the style for the toolbar
        keyboardDoneButtonShow.barStyle = UIBarStyle .default
        //Making the done button and calling the textFieldShouldReturn native method for hidding the keyboard.
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.hideKeyboard))
        
        //Calculating the flexible Space.
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        //Setting the color of the button.
        doneButton.tintColor = UIColor.black
        //Making an object using the button and space for the toolbar
        let toolbarButton = [flexSpace,doneButton]
        //Adding the object for toolbar to the toolbar itself
        keyboardDoneButtonShow.setItems(toolbarButton, animated: false)
        //Now adding the complete thing against the desired textfield
        textField.inputAccessoryView = keyboardDoneButtonShow
        
    }
    
    
    //MARK:- tableview handling
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = 0
        
        if section == 0
        {
            num = 1 + Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!
        }
        else if section == 1
        {
            num = 3
        }
        else if section == 2
        {
            
            if (self.from.range(of: "single") != nil)
            {
                if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                {
                    num = 2
                    offered = 1
                }
                else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                {
                    num = 3
                    offered = 2
                }
                else
                {
                    num  = 2
                    offered = 0
                }
            }
            else
            {
                if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                {
                    num = 3
                    offered = 0
                }
                else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && corporateArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                {
                    num = 3
                    offered = 2
                }
                else
                {
                    num  = 2
                    offered = 0
                }
            }
            
        }
        else if section == 3
        {
            num = 10
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                height = 48
            }
            else
            {
                height = 40
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                height = 50
            }
            else
            {
                height = 70
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                height = 50
            }
            else if indexPath.row == 1 && couponOpen == false
            {
                height = 40
            }
            else if indexPath.row == 1 && couponOpen == true
            {
                height = 70
            }
            else if indexPath.row == 2 && offered == 1
            {
                height = 120
            }
            else if indexPath.row == 2 && offered == 2
            {
                height = UITableViewAutomaticDimension
            }
        }
        else if indexPath.section == 3
        {
            
            if indexPath.row == 0
            {
                height = 45
            }
            else if indexPath.row == 9
            {
                height = 50
            }
            else
            {
                height = 40
            }
        }
        return height
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = true
                heading.text = "Traveller Information"
                count.isHidden = false
                
                count.text = (dataDic.value(forKey: "Passengers") == nil || (dataDic.value(forKey: "Passengers") as! NSArray).count == 0) ? "0 Pax" : "\((dataDic.value(forKey: "Passengers") as! NSArray).count) Pax"
                count.adjustsFontSizeToFitWidth = true
            }
            else
            {
                if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).count != 0
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "travellerCell")!
                    let txtfld = cell.viewWithTag(2) as! UITextField
                    let editBtn = cell.viewWithTag(3) as! UIButton
                    txtfld.isEnabled = false
                    txtfld.isHidden = false
                    editBtn.isHidden = false
                    let addnewBtn = cell.viewWithTag(4) as! UIButton
                    addnewBtn.isHidden = true
                    
                    if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "first_name") != nil && ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "last_name") as! String != ""
                    {
                        txtfld.text = "\(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "first_name")!) \(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: indexPath.row - 1) as! NSDictionary).value(forKey: "last_name")!)"
                    }
                    else
                    {
                        txtfld.text = ""
                    }
                }
                else
                {
                    cell = tableView.dequeueReusableCell(withIdentifier: "travellerCell")!
                    let txtfld = cell.viewWithTag(2) as! UITextField
                    let editBtn = cell.viewWithTag(3) as! UIButton
                    let addnewBtn = cell.viewWithTag(4) as! UIButton
                    txtfld.isHidden = true
                    editBtn.isHidden = true
                    
                    if indexPath.row <= Int("\(dataDic.value(forKey: "AdultCount")!)")!
                    {
                        addnewBtn.setTitle("Add Adult\(indexPath.row)", for: .normal)
                    }
                    else if indexPath.row <= (Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")!)
                    {
                        addnewBtn.setTitle("Add Child\(indexPath.row-Int("\(dataDic.value(forKey: "AdultCount")!)")!)", for: .normal)
                    }
                    else if indexPath.row <= (Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!)
                    {
                        addnewBtn.setTitle("Add Infant\(indexPath.row-(Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")!))", for: .normal)
                    }
                }
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = false
                imgView.layer.masksToBounds =  false
                imgView.layer.shadowColor = supportingfuction.hexStringToUIColor(hex: "dedede").cgColor
                imgView.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                imgView.layer.shadowOffset = CGSize(width: 0, height: 0)
                imgView.clipsToBounds = false
                imgView.layer.shadowOpacity = 0.7
                imgView.layer.shadowRadius = 4
                
                count.isHidden = true
                heading.text = "Contact Information"
            }
            else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let txtfld = cell.viewWithTag(2) as! UITextField
                
                heading.text = "Email Id"
                if dataDic.value(forKey: "email") != nil
                {
                    txtfld.text = dataDic.value(forKey: "email") as? String
                }
                else if (UserDefaults.standard.value(forKey: "userData") != nil) && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") != nil
                {
                    txtfld.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as? String
                    dataDic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as? String, forKey: "email")
                }
                else
                {
                    txtfld.text = ""
                }
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "contactCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let txtfld = cell.viewWithTag(2) as! UITextField
                
                heading.text = "Mobile Number"
                if dataDic.value(forKey: "mobile_no") != nil
                {
                    txtfld.text = dataDic.value(forKey: "mobile_no") as? String
                }
                else if (UserDefaults.standard.value(forKey: "userData") != nil) && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") != nil
                {
                    txtfld.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") as? String
                    dataDic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") as? String, forKey: "mobile_no")
                }
                else
                {
                    txtfld.text = ""
                }
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
                let heading = cell.viewWithTag(1) as! UILabel
                let count = cell.viewWithTag(2) as! UILabel
                let imgView = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = false
                imgView.layer.masksToBounds =  false
                imgView.layer.shadowColor = supportingfuction.hexStringToUIColor(hex: "dedede").cgColor
                imgView.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                imgView.layer.shadowOffset = CGSize(width: 0, height: 0)
                imgView.clipsToBounds = false
                imgView.layer.shadowOpacity = 0.7
                imgView.layer.shadowRadius = 4
                
                count.isHidden = true
                heading.text = "Offers"
            }
            else if indexPath.row == 1 && couponOpen == false
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "travellerCell")!
                let txtfld = cell.viewWithTag(2) as! UITextField
                let editBtn = cell.viewWithTag(3) as! UIButton
                txtfld.isHidden = true
                editBtn.isHidden = true
                
                let addnewBtn = cell.viewWithTag(4) as! UIButton
                addnewBtn.isHidden = false
                addnewBtn.setTitle("Have a coupon code", for: .normal)
                addnewBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            }
            else if indexPath.row == 1 && couponOpen == true
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "couponApply")!
                let txtfld = cell.viewWithTag(1) as! UITextField
                let btn = cell.viewWithTag(2) as! UIButton
                btn.layer.cornerRadius = 15.0
                
                if dataDic.value(forKey: "coupon") != nil
                {
                    txtfld.text = dataDic.value(forKey: "coupon") as? String
                }
                else
                {
                    txtfld.text = ""
                }
                
                if dataDic.value(forKey: "discount_value") != nil
                {
                    txtfld.isEnabled = false
                    btn.isEnabled = false
                    btn.setTitle("Applied", for: .normal)
                }
                else
                {
                    txtfld.isEnabled = true
                    btn.isEnabled = true
                    btn.setTitle("Apply", for: .normal)
                }
                
            }
            else if indexPath.row == 2
            {
                if offered == 1
                {
//                    cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
//                    let img = cell.viewWithTag(1) as! UIImageView
//                    img.layer.borderWidth = 2
//                    img.layer.borderColor = supportingfuction.hexStringToUIColor(hex: "dedede").cgColor
                   
                }
                else if offered == 2
                {
                    //cell = tableView.dequeueReusableCell(withIdentifier: "cancellationCell")!
                    
                    
                    cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
                     let check = cell.viewWithTag(3) as! UIButton
                    let img = cell.viewWithTag(1) as! UIImageView
                    img.layer.borderWidth = 2
                    img.layer.borderColor = supportingfuction.hexStringToUIColor(hex: "dedede").cgColor
                    
                    let lbl = cell.viewWithTag(2) as! UILabel
                    lbl.text = "During the booking process, select 'Zero Cancellation' option by paying an additional fee of Rs. \(dataDic.value(forKey: "mark_up_corporate")!) per passenger & enjoy Zero penalty in case you wish to cancel this booking."
                    
                    if(dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1")
                    {
                        check.isSelected = true
                    }
                    else
                    {
                        check.isSelected = false
                    }
                }
            }
        }
        else if indexPath.section == 3
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
                imgView.isHidden = true
                
                count.isHidden = true
                heading.text = "Payment Details"
            }
            else if indexPath.row == 8
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "priceCell")!
                // cell.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                cell.contentView.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                let totalPriceLbl = cell.viewWithTag(1) as! UILabel
                let money = cell.viewWithTag(2) as! UILabel
                let btn = cell.viewWithTag(3) as! UIButton
                btn.isHidden = true
                totalPriceLbl.text = "Total"
                
                var dfare = 0
                var rfare = 0
                
                if (self.from.range(of: "single") != nil) || from == "internationaldouble"
                {
                    if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                        
                    }
                    else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        //&& dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                        var amount = 0
                        if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                        {
                             amount = Int("\(dataDic.value(forKey: "mark_up_corporate")!)")! * (dataDic.value(forKey: "Passengers") as! NSArray).count
                        }
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + amount
                    }
                    else
                    {
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                    }
                }
                else
                {
                    if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                        
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                    }
                    else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && corporateArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        var amount = 0
                        if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                        {
                            amount = Int("\(dataDic.value(forKey: "mark_up_corporate")!)")! * (dataDic.value(forKey: "Passengers") as! NSArray).count
                        }
                        
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + amount
                        
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + amount
                    }
                    else
                    {
                        dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                        
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                    }
                }
                
                var fee = 0.0
                if from == "single"
                {
                    fee = Double("\(dataDic.value(forKey: "one_way")!)")!
                }
                else if from == "double"
                {
                    fee = Double("\(dataDic.value(forKey: "round_trip")!)")!
                }
                else if from == "internationalsingle"
                {
                    if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_one_way_cap")!)")!))!
                    {
                        fee = Double("\(dataDic.value(forKey: "inter_one_way")!)")!
                    }
                    else
                    {
                        fee = Double("\(dataDic.value(forKey: "inter_one_way2")!)")!
                    }
                    
                }
                else if from == "internationaldouble"
                {
                    if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_round_trip_cap")!)")!))!
                    {
                        fee = Double("\(dataDic.value(forKey: "inter_round_trip")!)")!
                    }
                    else
                    {
                        fee = Double("\(dataDic.value(forKey: "inter_round_trip2")!)")!
                    }
                    
                }
                
                var total = dfare + rfare + (Int(fee) * (dataDic.value(forKey: "Passengers") as! NSArray).count)
                
                if dataDic.value(forKey: "discount_value") != nil
                {
                    total = total - Int("\(dataDic.value(forKey: "discount_value")!)")!
                }
                
                
                let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                
                let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                normalString.append(attributedString1)
                money.attributedText = normalString
                money.adjustsFontSizeToFitWidth = true
            }
            else if indexPath.row == 9
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "termsCell")!
                let tickbtn = cell.viewWithTag(1) as! UIButton
                
                if dataDic.value(forKey: "termsChecked") != nil && dataDic.value(forKey: "termsChecked") as! String == "1"
                {
                    tickbtn.isSelected = true
                }
                else
                {
                    tickbtn.isSelected = false
                }
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "priceCell")!
                cell.backgroundColor = UIColor.clear
                cell.contentView.backgroundColor = UIColor.clear
                let totalPriceLbl = cell.viewWithTag(1) as! UILabel
                let money = cell.viewWithTag(2) as! UILabel
                money.textColor = supportingfuction.hexStringToUIColor(hex: "353535")
                let delBtn = cell.viewWithTag(3) as! UIButton
                delBtn.isHidden = true
                
                
                if indexPath.row == 1
                {
                    totalPriceLbl.text = "Base Fare(\(Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")! + Int("\(dataDic.value(forKey: "InfantCount")!)")!))"
                    var total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!))
                    
                    if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        total = total + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                        total = total - Int(floor(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "CommissionEarned")!)")!))
                    }
                    else  if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                       total = total - Int(floor(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "CommissionEarned")!)")!))
                    }
                    else
                    {
                        total = total - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                    }
                    
                    if from == "double"
                    {
                        total = total + Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!))
                        
                        if couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                        {
                            total = total + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                            total = total - Int(floor(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "CommissionEarned")!)")!))
                        }
                        else if (corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)"))
                        {
                            total = total - Int(floor(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "CommissionEarned")!)")!))
                           
                        }
                        else
                        {
                             total = total - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                        }
                    }
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                    normalString.append(attributedString1)
                    money.attributedText = normalString
                    money.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 2
                {
                    totalPriceLbl.text = "Other Charge"
                    let arr = ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray
                    var total = 0
                    
                    for n in 0..<arr.count
                    {
                        if "\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key")!)" == "OTHERCHARGE"
                        {
                            total = Int(ceil(Double("\(((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "ChargeBU") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                        }
                    }
                    
                    if (self.from == "double")
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
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                    normalString.append(attributedString1)
                    money.attributedText = normalString
                    money.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 3
                {
                    totalPriceLbl.text = "Additional Taxation Fee"
                    var total = 0
                    
                    if (self.from.range(of: "single") != nil) || from == "internationaldouble"
                    {
                        if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") || corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!))
                        }
                        else
                        {
                            total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!))
                        }
                    }
                    else if from == "double"
                    {
                        if (couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")) || (corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && corporateArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)"))
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
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                    normalString.append(attributedString1)
                    money.attributedText = normalString
                    money.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 4
                {
                    totalPriceLbl.text = "Tax"
                    var total = ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
                    
                    if from == "double"
                    {
                        total = total + ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                    normalString.append(attributedString1)
                    money.attributedText = normalString
                    money.adjustsFontSizeToFitWidth = true
                }
                else if indexPath.row == 5
                {
                    totalPriceLbl.text = "Coupon Discount"
                    if dataDic.value(forKey: "discount_value") != nil
                    {
                        delBtn.isHidden = false
                        let dis = ceil(Double("\(dataDic.value(forKey: "discount_value")!)")!)
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: dis))
                        let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                        let normalString = NSMutableAttributedString(string: "-\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                        normalString.append(attributedString1)
                        money.attributedText = normalString
                        money.textColor = supportingfuction.hexStringToUIColor(hex: "1F58A9")
                        money.adjustsFontSizeToFitWidth = true
                    }
                    else
                    {
                        money.text = "-"
                        
                    }
                }
                else if indexPath.row == 6
                {
                    totalPriceLbl.text = "Full Refund Fee"
                    
                    if offered == 2 && dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                    {
                        var total = ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!)
                        
                        if (self.from.range(of: "double") != nil)
                        {
                            total = total + ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!)
                        }
                        
                        total = Double(Int(total) * (dataDic.value(forKey: "Passengers") as! NSArray).count)
                        let formattedNumber = numberFormatter.string(from: NSNumber(value: total))
                        
                        let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                        let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                        normalString.append(attributedString1)
                        money.attributedText = normalString
                        money.adjustsFontSizeToFitWidth = true
                    }
                    else
                    {
                        money.text = "-"
                    }
                }
                else if indexPath.row == 7
                {
                    totalPriceLbl.text = "Convenience Fee"
                    var total = 0.0
                    
                    if from == "single"
                    {
                        total = Double("\(dataDic.value(forKey: "one_way")!)")!
                    }
                    else if from == "double"
                    {
                        total = Double("\(dataDic.value(forKey: "round_trip")!)")!
                    }
                    else if from == "internationalsingle"
                    {
                        if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_one_way_cap")!)")!))!
                        {
                            total = Double("\(dataDic.value(forKey: "inter_one_way")!)")!
                        }
                        else
                        {
                            total = Double("\(dataDic.value(forKey: "inter_one_way2")!)")!
                        }
                        
                    }
                    else if from == "internationaldouble"
                    {
                        if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_round_trip_cap")!)")!))!
                        {
                            total = Double("\(dataDic.value(forKey: "inter_round_trip")!)")!
                        }
                        else
                        {
                            total = Double("\(dataDic.value(forKey: "inter_round_trip2")!)")!
                        }
                        
                    }
                    
                    let formattedNumber = numberFormatter.string(from: NSNumber(value: (Int(total) * (dataDic.value(forKey: "Passengers") as! NSArray).count)))
                    
                    let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 13)!])
                    let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: money.font.fontName, size: 10.0)!])
                    normalString.append(attributedString1)
                    money.attributedText = normalString
                    money.adjustsFontSizeToFitWidth = true
                }
            }
        }
        
        return cell
    }
    
    //MARK:- textfield handling
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblView.addGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.section == 1
        {
            if indexPath?.row == 1
            {
                textField.returnKeyType = .next
                textField.keyboardType = .emailAddress
            }
            else
            {
                textField.returnKeyType = .done
                textField.keyboardType = .numberPad
                doneKeyboard(textField: textField
                    , width: self.view.frame.width, height: self.view.frame.height)
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.removeGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        let cell = tblView.cellForRow(at: indexPath!)
        
        if (cell == nil)
        {
            self.view.endEditing(true)
            return
        }
        
        if indexPath?.section == 1
        {
            if indexPath?.row == 1
            {
                dataDic.setValue(textField.text, forKey: "email")
            }
            else
            {
                dataDic.setValue(textField.text, forKey: "mobile_no")
            }
        }
        else if indexPath?.section == 2
        {
            dataDic.setValue(textField.text, forKey: "coupon")
        }
        
        self.tblView.reloadData()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.section == 1
        {
            if indexPath?.row == 2
            {
                let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
                let compSepByCharInSet = string.components(separatedBy: aSet)
                let numberFiltered = compSepByCharInSet.joined(separator: "")
                if !(string == numberFiltered)
                {
                    return false
                }
                
                let currentCharacterCount = textField.text?.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string .count - range.length
                return newLength <= 14
            }
        }
        return true
    }
    //MARK:- button handling
    
    @IBAction func discountRemove(_ sender: UIButton)
    {
        if dataDic.value(forKey: "discount_value") != nil
        {
            dataDic.removeObject(forKey: "discount_value")
            couponOpen = true
            setMoneyValues()
        }
        self.tblView.reloadData()
    }
    
    @IBAction func addNewBtn(_ sender: UIButton)
    {
        let hit = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.section == 0
        {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "PassengerDetailsViewController") as! PassengerDetailsViewController
            vc.delegate = self
            vc.dataDic.setValue((indexPath?.row)!-1, forKey: "index")
            //vc.index = (indexPath?.row)!
            
            vc.isInternational = (from == "internationalsingle" || from == "internationaldouble") ? true : false
            vc.dataDic.setValue(((dataDic.value(forKey: "PreferredArrivalTime") != nil) ? (dataDic.value(forKey: "PreferredArrivalTime") as! String) : (dataDic.value(forKey: "PreferredDepartureTime") as! String)), forKey: "PreferredDepartureTime")
            
            
            if sender.tag == 3
            {
                vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "first_name") as! String, forKey: "first_name")
                vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "last_name") as! String, forKey: "last_name")
                vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "title") as! String, forKey: "title")
                
                if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "DateOfBirth") !=  nil
                {
                    vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "DateOfBirth") as! String, forKey: "DateOfBirth")
                }
                
                if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "PassportNo") !=  nil
                {
                    vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "PassportNo") as! String, forKey: "PassportNo")
                }
                
                if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "PassportExpiry") !=  nil
                {
                    vc.dataDic.setValue(((dataDic.value(forKey: "Passengers") as! NSArray).object(at: (indexPath?.row)! - 1) as! NSDictionary).value(forKey: "PassportExpiry") as! String, forKey: "PassportExpiry")
                }
            }
            
            
            if (indexPath?.row)! <= Int("\(dataDic.value(forKey: "AdultCount")!)")!
            {
                vc.isAdult = "adult"
            }
            else if (indexPath?.row)! <= (Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")!)
            {
                vc.isAdult = "child"
            }
            else
            {
                vc.isAdult = "infant"
            }
            
            self.present(vc, animated: true, completion: nil)
        }
        else
        {
            
            if UserDefaults.standard.value(forKey: "userData") == nil
            {
                supportingfuction.showMessageHudWithMessage(message: "Please login to avail offers.", delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "email") == nil || dataDic.value(forKey: "email") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: enterEmail, delay: 2.0)
                return
            }
            else if CommonValidations.isValidEmail(testStr: dataDic.value(forKey: "email") as! String) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validEmail, delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "email") as! String != (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as! String
            {
                supportingfuction.showMessageHudWithMessage(message: "The email should be same as the registered email id to avail offer.", delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "mobile_no") == nil || dataDic.value(forKey: "mobile_no") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: enterMobileNum, delay: 2.0)
                return
            }
            else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "mobile_no") as! String, min: 8, max: 14) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
                return
            }
            couponOpen = true
            self.tblView.reloadData()
        }
    }
    
    @IBAction func cancellationBtn(_ sender: UIButton)
    {
        if sender.isSelected == true
        {
            dataDic.setValue("0", forKey: "cancel")
        }
        else
        {
            dataDic.setValue("1", forKey: "cancel")
        }
        
        self.setMoneyValues()
        self.tblView.reloadData()
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        if dataDic.value(forKey: "coupon") == nil || (dataDic.value(forKey: "coupon") as! String) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter coupon code to avail discount.", delay: 2.0)
            return
        }
        
        getCoupon()
    }
    
    
    @IBAction func booBtn(_ sender: UIButton)
    {
        self.view.endEditing(true)
        
        for n in 0..<(dataDic.value(forKey: "Passengers") as! NSArray).count
        {
            if ((dataDic.value(forKey: "Passengers") as! NSArray).object(at: n) as! NSDictionary).count == 0
            {
                supportingfuction.showMessageHudWithMessage(message: "Please enter traveller's information.", delay: 2.0)
                return
            }
        }
        
        if (dataDic.value(forKey: "Passengers") as! NSArray).count < (Int("\(dataDic.value(forKey: "AdultCount")!)")! + Int("\(dataDic.value(forKey: "ChildCount")!)")!)
        {
            supportingfuction.showMessageHudWithMessage(message: "Please enter all traveller's information.", delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "email") == nil || dataDic.value(forKey: "email") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterEmail, delay: 2.0)
            return
        }
        else if CommonValidations.isValidEmail(testStr: dataDic.value(forKey: "email") as! String) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "mobile_no") == nil || dataDic.value(forKey: "mobile_no") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterMobileNum, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "mobile_no") as! String, min: 8, max: 14) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "termsChecked") == nil || dataDic.value(forKey: "termsChecked") as! String != "1"
        {
            supportingfuction.showMessageHudWithMessage(message: "Please accept terms and conditions.", delay: 2.0)
            return
        }
        
        if(fareQuoteHit == false)
        {
            getfareQuote(n: 0)
        }
        else
        {
            filterData()
        }
        
    }
    
    func filterData()
    {
        let params:NSMutableDictionary = NSMutableDictionary()
        params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
        params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
        params.setValue(dataDic.value(forKey: "TraceId") as! String, forKey: "TraceId")
        params.setValue(((self.from.range(of: "single") != nil) ? "one-way" : "round-trip"), forKey: "way")
        params.setValue(dataDic.value(forKey: "email") as? String, forKey: "contact_email")
        params.setValue(dataDic.value(forKey: "mobile_no") as? String, forKey: "contact_no")
        
        if dataDic.value(forKey: "coupon") != nil && dataDic.value(forKey: "discount_value") != nil
        {
            params.setValue(dataDic.value(forKey: "discount_value") as? String, forKey: "discount_amount")
            params.setValue(dataDic.value(forKey: "coupon") as? String, forKey: "discount_code")
            //discount_amount
        }
        else
        {
            params.setValue("", forKey: "discount_code")
            params.setValue("0", forKey: "discount_amount")
        }
        
        if (UserDefaults.standard.value(forKey: "userData") == nil)
        {
            params.setValue(dataDic.value(forKey: "email") as? String, forKey: "auth_user")
        }
        else
        {
            params.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as! String, forKey: "auth_user")
        }
        
        //convenience fee keys.
        if from == "single"
        {
            let fee = Double("\(dataDic.value(forKey: "one_way")!)")!
            params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
            params.setValue("one-way", forKey: "convenience_fee_type")
        }
        else if from == "double"
        {
            let fee = Double("\(dataDic.value(forKey: "round_trip")!)")!
            params.setValue("round_trip", forKey: "convenience_fee_type")
            params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
        }
        else if from == "internationalsingle"
        {
            if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_one_way_cap")!)")!))!
            {
                let fee = Double("\(dataDic.value(forKey: "inter_one_way")!)")!
                params.setValue("inter_one_way", forKey: "convenience_fee_type")
                params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
            }
            else
            {
                let fee = Double("\(dataDic.value(forKey: "inter_one_way2")!)")!
                params.setValue("inter_one_way2", forKey: "convenience_fee_type")
                params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
            }
        }
        else if from == "internationaldouble"
        {
            if (Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")?.isLess(than: Double("\(dataDic.value(forKey: "inter_round_trip_cap")!)")!))!
            {
                let fee = Double("\(dataDic.value(forKey: "inter_round_trip")!)")!
                params.setValue("inter_round_trip", forKey: "convenience_fee_type")
                params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
            }
            else
            {
                let fee = Double("\(dataDic.value(forKey: "inter_round_trip2")!)")!
                params.setValue("inter_round_trip2", forKey: "convenience_fee_type")
                params.setValue((Int(fee)*(dataDic.value(forKey: "Passengers") as? NSArray)!.count), forKey: "convenience_fee")
            }
            
        }
        
        let arr = (dataDic.value(forKey: "Passengers") as? NSArray)?.mutableCopy() as! NSMutableArray
        var pax = false
        for n in 0..<(dataDic.value(forKey: "Passengers") as? NSArray)!.count
        {
            let dic = ((dataDic.value(forKey: "Passengers") as? NSArray)?.object(at: n) as! NSDictionary).mutableCopy() as! NSMutableDictionary
            
            if pax == false && (dic.value(forKey: "PaxType") != nil && "\(dic.value(forKey: "PaxType")!)" == "1")
            {
                dic.setValue("1", forKey: "IsLeadPax")
                pax = true
            }
            else
            {
                dic.setValue("0", forKey: "IsLeadPax")
            }
            
            if pax == false && n == (dataDic.value(forKey: "Passengers") as? NSArray)!.count
            {
                dic.setValue("0", forKey: "IsLeadPax")
            }
            arr.replaceObject(at: n, with: dic)
        }
        params.setValue(arr, forKey: "Passengers")
        
        
        
        var total = 0
        var charge_of_full_return = 0
        let flightArray:NSMutableArray = NSMutableArray()
        var grand = 0
        
        if (self.from.range(of: "single") != nil) || from == "internationaldouble"
        {
            //single booking
            let departDic = NSMutableDictionary()
            departDic.setValue((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "from")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "from_city_code")
            
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! NSString)), forKey: "flight_number")
            
            
            if from == "internationaldouble"
            {
                departDic.setValue("\(dataDic.value(forKey: "PreferredArrivalTime")!)", forKey: "international_return_time")
                departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String), forKey: "international_arrival_time")
                
                 departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 1) as! NSArray).count-1) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String), forKey: "international_return_f_number")
            }
            
            
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "to")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "to_city_code")
            departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String), forKey: "AirlineCode")
            departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String), forKey: "AirlineName")
            departDic.setValue((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String, forKey: "ArrivalTime")
            departDic.setValue((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String, forKey: "DepartTime")
            departDic.setValue("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)", forKey: "source_code")
            departDic.setValue((("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "1" || "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "true") ? "1" : "0") , forKey: "IsRefundable")
            
            if "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsLCC")!))" == "1" || "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsLCC")!))" == "true"
            {
                departDic.setValue("lcc", forKey: "flight_type")
            }
            else
            {
                departDic.setValue("non_lcc", forKey: "flight_type")
            }
            
            departDic.setValue("\(dataDic.value(forKey: "AdultCount")!)", forKey: "Adults")
            departDic.setValue("\(dataDic.value(forKey: "ChildCount")!)", forKey: "Children")
            departDic.setValue("\(dataDic.value(forKey: "InfantCount")!)", forKey: "Infants")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String), forKey: "country_name")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryCode") as! String), forKey: "country_code")
            
            if corporateArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)")
            {
                departDic.setValue("0", forKey: "mark_up")
                departDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!))
                
                if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                {
                    charge_of_full_return = Int(ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!)) * (dataDic.value(forKey: "Passengers") as! NSArray).count
                }
                else
                {
                    charge_of_full_return = 0
                }
            }
            else if couponArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)")
            {
                departDic.setValue("\(dataDic.value(forKey: "mark_up_coupon")!)", forKey: "mark_up")
                departDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + ceil(Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!))
                charge_of_full_return = 0
            }
            else
            {
                departDic.setValue("\(dataDic.value(forKey: "mark_down_publish")!)", forKey: "mark_down")
                departDic.setValue("0", forKey: "mark_up")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - ceil(Double("\(dataDic.value(forKey: "mark_down_publish")!)")!))
                charge_of_full_return = 0
            }
            
            //fare data for all passengers
            let fare = NSMutableDictionary()
            let originDic = (dataDic.value(forKey: "flightDetail") as! NSDictionary)
            let price = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!)
            let tax = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
            let yqtax = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "YQTax")!)")!)
            let addFeePub = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!)
            let addFeeoffrd = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!)
            let other = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "OtherCharges")!)")!)
            
            for n in 0..<((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).count
            {
                if (((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String == "TransactionFee"
                {
                    let transactionFee = Int(ceil(Double("\((((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                    fare.setValue(Int(transactionFee), forKey: "TransactionFee")
                }
            }
            
            if (originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee") == nil
            {
                fare.setValue("0", forKey: "AirTransFee")
            }
            else
            {
                fare.setValue("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee")!)", forKey: "AirTransFee")
            }
            
            fare.setValue("\(Int(other))", forKey: "OtherCharges")
            fare.setValue("\(Int(addFeeoffrd))", forKey: "AdditionalTxnFeeOfrd")
            fare.setValue("\(Int(price))", forKey: "BaseFare")
            fare.setValue("\(Int(tax))", forKey: "Tax")
            fare.setValue("\(Int(yqtax))", forKey: "YQTax")
            fare.setValue("\(Int(addFeePub))", forKey: "AdditionalTxnFeePub")
            departDic.setValue(fare, forKey: "Fare")
            departDic.setValue("\(total)", forKey: "total")
            departDic.setValue((originDic.value(forKey: "FareBreakdown") as! NSArray), forKey: "FareBreakdown")
            flightArray.add(departDic)
            grand = (Int("\(departDic.value(forKey: "total")!)")!)
        }
        else
        {
            //return booking
            let departDic = NSMutableDictionary()
            departDic.setValue((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "from")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "from_city_code")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "to")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "to_city_code")
            departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String), forKey: "AirlineCode")
            departDic.setValue(((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String), forKey: "AirlineName")
            departDic.setValue((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String, forKey: "ArrivalTime")
            departDic.setValue((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String, forKey: "flight_number")
            departDic.setValue((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String, forKey: "DepartTime")
            departDic.setValue("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)", forKey: "source_code")
            departDic.setValue((("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "1" || "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "true") ? "1" : "0") , forKey: "IsRefundable")
            
            if "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsLCC")!))" == "1" || "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "IsLCC")!))" == "true"
            {
                departDic.setValue("lcc", forKey: "flight_type")
            }
            else
            {
                departDic.setValue("non_lcc", forKey: "flight_type")
            }
            
            departDic.setValue("\(dataDic.value(forKey: "AdultCount")!)", forKey: "Adults")
            departDic.setValue("\(dataDic.value(forKey: "ChildCount")!)", forKey: "Children")
            departDic.setValue("\(dataDic.value(forKey: "InfantCount")!)", forKey: "Infants")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String), forKey: "country_name")
            departDic.setValue((((((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryCode") as! String), forKey: "country_code")
            
            
            if (corporateArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)") && corporateArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)"))
            {
                if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                {
                    charge_of_full_return = Int(ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!)) * (dataDic.value(forKey: "Passengers") as! NSArray).count
                }
                else
                {
                    charge_of_full_return = 0
                }
                
                departDic.setValue("0", forKey: "mark_up")
                departDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!))
            }
            else if couponArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)") && couponArr.contains("\((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source")!)")
            {
                departDic.setValue("\(dataDic.value(forKey: "mark_up_coupon")!)", forKey: "mark_up")
                departDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + ceil(Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!))
                charge_of_full_return = 0
            }
            else
            {
                departDic.setValue("\(dataDic.value(forKey: "mark_down_publish")!)", forKey: "mark_down")
                departDic.setValue("0", forKey: "mark_up")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - ceil(Double("\(dataDic.value(forKey: "mark_down_publish")!)")!))
                charge_of_full_return = 0
            }
            
            //fare data for all passengers
            let fare = NSMutableDictionary()
            let originDic = (dataDic.value(forKey: "flightDetail") as! NSDictionary)
            let price = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!)
            let tax = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
            let yqtax = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "YQTax")!)")!)
            let addFeePub = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!)
            let addFeeoffrd = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!)
            let other = ceil(Double("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "OtherCharges")!)")!)
            
            for n in 0..<((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).count
            {
                if (((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String == "TransactionFee"
                {
                    let transactionFee = Int(ceil(Double("\((((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                    fare.setValue(Int(transactionFee), forKey: "TransactionFee")
                }
            }
            
            if (originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee") == nil
            {
                fare.setValue("0", forKey: "AirTransFee")
            }
            else
            {
                fare.setValue("\((originDic.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee")!)", forKey: "AirTransFee")
            }
            
            fare.setValue(other, forKey: "OtherCharges")
            fare.setValue("\(Int(addFeeoffrd))", forKey: "AdditionalTxnFeeOfrd")
            fare.setValue("\(Int(price))", forKey: "BaseFare")
            fare.setValue("\(Int(tax))", forKey: "Tax")
            fare.setValue("\(Int(yqtax))", forKey: "YQTax")
            fare.setValue("\(Int(addFeePub))", forKey: "AdditionalTxnFeePub")
            departDic.setValue(fare, forKey: "Fare")
            departDic.setValue("\(total)", forKey: "total")
            departDic.setValue((originDic.value(forKey: "FareBreakdown") as! NSArray), forKey: "FareBreakdown")
            flightArray.add(departDic)
            
            grand = (Int("\(departDic.value(forKey: "total")!)")!)
            
            
            
            //two way
            let returnDic = NSMutableDictionary()
            returnDic.setValue((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "from")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "from_city_code")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityName") as! String), forKey: "to")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CityCode") as! String), forKey: "to_city_code")
            returnDic.setValue(((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineCode") as! String), forKey: "AirlineCode")
            returnDic.setValue(((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "AirlineName") as! String), forKey: "AirlineName")
            returnDic.setValue((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Destination") as! NSDictionary).value(forKey: "ArrTime") as! String, forKey: "ArrivalTime")
            returnDic.setValue((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "DepTime") as! String, forKey: "DepartTime")
            returnDic.setValue("\((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source")!)", forKey: "source_code")
            returnDic.setValue((("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "1" || "\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "IsRefundable"))!)" == "true") ? "1" : "0") , forKey: "IsRefundable")
            if "\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "IsLCC")!))" == "1" || "\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "IsLCC")!))" == "true"
            {
                returnDic.setValue("lcc", forKey: "flight_type")
            }
            else
            {
                returnDic.setValue("non_lcc", forKey: "flight_type")
            }
            returnDic.setValue((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: (((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).count-1) as! NSDictionary).value(forKey: "Airline") as! NSDictionary).value(forKey: "FlightNumber") as! String, forKey: "flight_number")
            
            
            returnDic.setValue("\(dataDic.value(forKey: "AdultCount")!)", forKey: "Adults")
            returnDic.setValue("\(dataDic.value(forKey: "ChildCount")!)", forKey: "Children")
            returnDic.setValue("\(dataDic.value(forKey: "InfantCount")!)", forKey: "Infants")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryName") as! String), forKey: "country_name")
            returnDic.setValue((((((((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Segments") as! NSArray).object(at: 0) as! NSArray).object(at: 0) as! NSDictionary).value(forKey: "Origin") as! NSDictionary).value(forKey: "Airport") as! NSDictionary).value(forKey: "CountryCode") as! String), forKey: "country_code")
            
            total = 0
            
            if corporateArr.contains("\((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source")!)") && corporateArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)")
            {
                if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                {
                    charge_of_full_return = charge_of_full_return + Int(ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!)) * (dataDic.value(forKey: "Passengers") as! NSArray).count
                }
                else
                {
                    charge_of_full_return = 0
                }
                
                returnDic.setValue("0", forKey: "mark_up")
                returnDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!))
                //+ ceil(Double("\(dataDic.value(forKey: "mark_up_corporate")!)")!))
            }
            else if couponArr.contains("\((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source")!)") && couponArr.contains("\((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source")!)")
            {
                returnDic.setValue("\(dataDic.value(forKey: "mark_up_coupon")!)", forKey: "mark_up")
                returnDic.setValue("0", forKey: "mark_down")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!) + ceil(Double("\(dataDic.value(forKey: "mark_up_coupon")!)")!))
                charge_of_full_return = 0
            }
            else
            {
                returnDic.setValue("\(dataDic.value(forKey: "mark_down_publish")!)", forKey: "mark_down")
                returnDic.setValue("0", forKey: "mark_up")
                total = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!) - ceil(Double("\(dataDic.value(forKey: "mark_down_publish")!)")!))
                charge_of_full_return = 0
            }
            
            //fare data for all passengers
            let fare1 = NSMutableDictionary()
            let originDic1 = (dataDic.value(forKey: "flightDetail1") as! NSDictionary)
            let price1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "BaseFare")!)")!)
            let tax1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "Tax")!)")!)
            let yqtax1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "YQTax")!)")!)
            let addFeePub1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeePub")!)")!)
            let addFeeoffrd1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "AdditionalTxnFeeOfrd")!)")!)
            let other1 = ceil(Double("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "OtherCharges")!)")!)
            
            for n in 0..<((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).count
            {
                if (((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "key") as! String == "TransactionFee"
                {
                    let transactionFee = Int(ceil(Double("\((((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "TaxBreakup") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "value")!)")!))
                    fare1.setValue(Int(transactionFee), forKey: "TransactionFee")
                }
            }
            returnDic.setValue((originDic1.value(forKey: "FareBreakdown") as! NSArray), forKey: "FareBreakdown")
            if (originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee") == nil
            {
                fare1.setValue("0", forKey: "AirTransFee")
            }
            else
            {
                fare1.setValue("\((originDic1.value(forKey: "Fare") as! NSDictionary).value(forKey: "AirTransFee")!)", forKey: "AirTransFee")
            }
            
            fare1.setValue("\(Int(other1))", forKey: "OtherCharges")
            fare1.setValue("\(Int(addFeeoffrd1))", forKey: "AdditionalTxnFeeOfrd")
            fare1.setValue("\(Int(price1))", forKey: "BaseFare")
            fare1.setValue("\(Int(tax1))", forKey: "Tax")
            fare1.setValue("\(Int(yqtax1))", forKey: "YQTax")
            fare1.setValue("\(Int(addFeePub1))", forKey: "AdditionalTxnFeePub")
            returnDic.setValue(fare1, forKey: "Fare")
            returnDic.setValue("\(total)", forKey: "total")
            flightArray.add(returnDic)
            
            grand = grand + Int("\(returnDic.value(forKey: "total")!)")!
        }
        params.setValue("\(charge_of_full_return)", forKey: "charge_of_full_return")
        params.setValue(flightArray, forKey: "flights")
        
        if dataDic.value(forKey: "discount_value") != nil
        {
            grand = grand - Int("\(dataDic.value(forKey: "discount_value")!)")!
        }
        
        if dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
        {
            grand = grand + charge_of_full_return
        }
        
        grand = grand + Int("\(params.value(forKey: "convenience_fee")!)")!
        params.setValue(grand, forKey: "grand_total")
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
        //        vc.from = self.from
        //        vc.dataDic = self.dataDic
        //        vc.dataDic.setValue("410", forKey: "order_id")
        //        vc.success = "fail"
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        if ((UserDefaults.standard.value(forKey: "userData") != nil) && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken") != nil) || (UserDefaults.standard.value(forKey: "user") != nil)
        {
            bookingService(params: params)
        }
        else if UserDefaults.standard.value(forKey: "user") == nil
        {
            getAccessToken(data: params)
        }
    }
    
    
    @IBAction func termsCheckBtn(_ sender: UIButton)
    {
        if sender.isSelected == true
        {
            dataDic.setValue("0", forKey: "termsChecked")
            sender.isSelected = false
        }
        else
        {
            dataDic.setValue("1", forKey: "termsChecked")
            sender.isSelected = true
        }
        
        self.tblView.reloadData()
    }
    
    
    @IBAction func TermsConditionBtn(_ sender: UIButton) {
        let story = UIStoryboard(name: "Main", bundle: nil)
        let second = story.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
        second.headerString = "Terms & Condition"
        self.navigationController?.pushViewController(second, animated: true)
    }
    
    
    @IBAction func fareRulesBtn(_ sender: UIButton)
    {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "FareRulesViewController") as! FareRulesViewController
        vc.dataDic.setValue((dataDic.value(forKey: "fareRule") as! NSAttributedString), forKey: "fareRule")
        vc.from = "single"
        if from == "double"
        {
            vc.from = "double"
            vc.dataDic.setValue((dataDic.value(forKey: "fareRule1") as! NSAttributedString), forKey: "fareRule1")
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    
    //MARK:- other functions
    
    func passenger(value1:NSMutableDictionary)
    {
        var arr = NSMutableArray()
        
        if dataDic.value(forKey: "Passengers") != nil
        {
            arr = (dataDic.value(forKey: "Passengers") as! NSArray).mutableCopy() as! NSMutableArray
        }
        
        if value1.value(forKey: "index") != nil
        {
            let index = Int("\(value1.value(forKey: "index")!)")
            value1.removeObject(forKey: "index")
            arr.replaceObject(at: index!, with: value1)
        }
        else
        {
            arr.add(value1)
        }
        dataDic.setValue(arr, forKey: "Passengers")
     //   self.setValues()
        self.tblView.reloadData()
    }
    
    
    //MARK:- webservices
    
    func getAccessToken(data: NSMutableDictionary)
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
                manager.requestSerializer.timeoutInterval = 120
                
                let params = NSMutableDictionary()
                params.setValue("ios", forKey: "device_type")
                if UserDefaults.standard.value(forKey: "device_token") != nil
                {
                    params.setValue(UserDefaults.standard.value(forKey: "device_token") as! String, forKey: "device_token")
                }
                else
                {
                    params.setValue("", forKey: "device_token")
                }
                params.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
                params.setValue(dataDic.value(forKey: "email") as! String, forKey: "email")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                
                manager.post((BASE_URL + "api/getaccesstoken"), parameters: params, constructingBodyWith: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                let dic = NSMutableDictionary()
                                dic.setValue(dataFromServer.value(forKey: "access_token") as! String, forKey: "accessToken")
                                dic.setValue(self.dataDic.value(forKey: "email") as! String, forKey: "email")
                                UserDefaults.standard.setValue(dic, forKey: "user")
                                self.bookingService(params: data)
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    // print(error)
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
    
    func getCoupon()
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
                manager.requestSerializer.timeoutInterval = 120
                
                let params = NSMutableDictionary()
                params.setValue(dataDic.value(forKey: "coupon") as! String, forKey: "coupon_name")
                
                if UserDefaults.standard.value(forKey: "email") != nil
                {
                    params.setValue(UserDefaults.standard.value(forKey: "email") as! String, forKey: "email")
                }
                else
                {
                    params.setValue(dataDic.value(forKey: "email") as! String, forKey: "email")
                }
                
                
                var dfare = 0
                var rfare = 0
                
                if couponArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)")
                {
                    dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                    
                }
                else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Source"))!)") && dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                {
                    dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_corporate")!)")!
                }
                else
                {
                    dfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                }
                
                if from == "double"
                {
                    if couponArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)")
                    {
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_coupon")!)")!
                    }
                    else if corporateArr.contains("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Source"))!)") && dataDic.value(forKey: "cancel") != nil && "\(dataDic.value(forKey: "cancel")!)" == "1"
                    {
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "OfferedFare")!)")!)) + Int("\(dataDic.value(forKey: "mark_up_corporate")!)")!
                    }
                    else
                    {
                        rfare = Int(ceil(Double("\(((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "Fare") as! NSDictionary).value(forKey: "PublishedFare")!)")!)) - Int("\(dataDic.value(forKey: "mark_down_publish")!)")!
                    }
                }
                
                
                let grand = dfare + rfare
                params.setValue("\(grand)", forKey: "grand_total")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                
                manager.post((BASE_URL + "api/isCouponValid"), parameters: params, constructingBodyWith: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                                self.dataDic.setValue("\((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "discount_value")!)", forKey: "discount_value")
                                self.tblView.reloadData()
                                self.setMoneyValues()
                          //      self.setValues()
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
                })
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
    
    func getfareQuote(n: Int)
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
                manager.requestSerializer.timeoutInterval = 120
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                let params = NSMutableDictionary()
                
                if UserDefaults.standard.value(forKey: "EndUserIp") == nil
                {
                    appDel.getIpWebservice()
                    NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailBookViewController.getfareQuote), name: Notification.Name("ipGenerated"), object: nil)
                    return
                }
                else
                {
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("ipGenerated"), object: nil)
                    params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
                }
                
               // params.setValue(UserDefaults.standard.value(forKey: "EndUserIp"), forKey: "EndUserIp")
                params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
                params.setValue(dataDic.value(forKey: "TraceId") as! String, forKey: "TraceId")
                
                if n == 0
                {
                    params.setValue((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
                }
                else
                {
                    params.setValue((dataDic.value(forKey: "flightDetail1") as! NSDictionary).value(forKey: "ResultIndex") as! String, forKey: "ResultIndex")
                }
                
                manager.post(("\(BOOK_URL)FareQuote"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            self.fareQuoteHit = true
                            
                            if  (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)" == "1") && (dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "IsPriceChanged") != nil && ("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "IsPriceChanged")!)" == "1"))
                            {
                                
                                if(self.dataDic.value(forKey: "coupon") != nil)
                                {
                                    self.dataDic.removeObject(forKey: "coupon")
                                }
                                
                                if n == 0
                                {
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSDictionary), forKey: "flightDetail")
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId") as! String), forKey: "TraceId")
                                    self.dataDic.setValue("true", forKey: "priceChanged")
                                }
                                else if n == 1
                                {
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSDictionary), forKey: "flightDetail1")
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId") as! String), forKey: "TraceId")
                                }
                                
                                supportingfuction.hideProgressHudInView(view: self.view)
                                if(self.from == "double" && n == 0)
                                {
                                   
                                    self.getfareQuote(n: 1)
                                }
                                else
                                {
                                    self.tblView.reloadData()
                                    self.setMoneyValues()
                                    //self.setValues()
                                    supportingfuction.showMessageHudWithMessage(message: "The price for the flight(s) are changed. Please confirm.", delay: 2.0)
                                }
                                
                            }
                            else if ("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)" == "1")
                            {
                                if n == 0
                                {
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSDictionary), forKey: "flightDetail")
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId") as! String), forKey: "TraceId")
                                    
                                    if (self.from.range(of: "single") != nil) || self.from == "internationaldouble"
                                    {
                                        supportingfuction.hideProgressHudInView(view: self.view)
                                    }
                                    else
                                    {
                                        self.getfareQuote(n: 1)
                                        return
                                    }
                                }
                                else if n == 1
                                {
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Results") as! NSDictionary), forKey: "flightDetail1")
                                    self.dataDic.setValue(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "TraceId") as! String), forKey: "TraceId")
                                    supportingfuction.hideProgressHudInView(view: self.view)
                                    
                                    if(self.dataDic.value(forKey: "priceChanged") != nil)
                                    {
                                        self.tblView.reloadData()
                                        self.setMoneyValues()
                                        //self.setValues()
                                        supportingfuction.showMessageHudWithMessage(message: "The price for the flight(s) are changed. Please confirm.", delay: 2.0)
                                        return
                                    }
                                }
                                else
                                {
                                    supportingfuction.hideProgressHudInView(view: self.view)
                                    return
                                }
                                
                                self.filterData()
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "4")
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                appDel.getIpWebservice()
                                NotificationCenter.default.addObserver(self, selector: #selector(FlightDetailBookViewController.getfareQuote), name: Notification.Name("ipGenerated"), object: nil)
                                return
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: "\(((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "Error") as! NSDictionary).value(forKey: "ErrorMessage")!)", delay: 2.0)
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    // Put your code which should be executed with a delay here
                                    
                                })
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    // print(error)
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
    
    
    func bookingService(params: NSMutableDictionary)
    {
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
                    params.setValue("\((UserDefaults.standard.value(forKey: "user") as! NSDictionary).value(forKey: "email")!)", forKey: "auth_user")
                }
                
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/user/book-flight"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "PaymentViewController") as! PaymentViewController
                                vc.url = "\((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "checkout_url")!)"
                                vc.dataDic = self.dataDic.mutableCopy() as! NSMutableDictionary
                                vc.dataDic.setValue("\(((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "order") as! NSDictionary).value(forKey: "id")!)", forKey: "order_id")
                                vc.from = self.from
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                            else if (dataFromServer.value(forKey: "error") != nil && dataFromServer.value(forKey: "error") as! String == "Unauthenticated")
                            {
                                self.getAccessToken(data: params)
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                    supportingfuction.hideProgressHudInView(view: self.view)
                    if let urlResponse = requestOperation?.response as? HTTPURLResponse {
                        let status = urlResponse.statusCode
                        if status == 401
                        {
                            
                            
                            
                            UserDefaults.standard.removeObject(forKey: "userData")
                            let story = UIStoryboard(name: "Main", bundle: nil)
                            let vc = story.instantiateViewController(withIdentifier:  "LoginViewController") as! LoginViewController
                            self.navigationController?.setViewControllers([vc], animated: true)
                            supportingfuction.showMessageHudWithMessage(message: "Please login to continue.", delay: 2.0)
                            return
                        }
                        //                        print(status)
                    }
                    
                    //                    print(error)
                    
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





