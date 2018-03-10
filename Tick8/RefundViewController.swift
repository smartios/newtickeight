//
//  RefundViewController.swift
//  Tick8
//
//  Created by SL-167 on 11/9/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class RefundViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var dataDic = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 && (dataDic.value(forKey: "flightDetail") != nil)
        {
            return 1+((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count
        }
        else if section == 1
        {
            return 6
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                height = 50
            }
            else if indexPath.row <= ((dataDic.value(forKey: "flightDetail") as!
                NSDictionary).value(forKey: "Passenger") as! NSArray).count
            {
                height = 40
            }
            else
            {
                height = 50
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 2
            {
                height = 45
            }
            else if indexPath.row == 5
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
        
        if indexPath.section == 0 && (dataDic.value(forKey: "flightDetail") != nil)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "headerCell")!
            cell.backgroundColor = UIColor.white
            cell.contentView.backgroundColor = UIColor.white
            let heading = cell.viewWithTag(1) as! UILabel
            let count = cell.viewWithTag(2) as! UILabel
            let img = cell.viewWithTag(3) as! UIImageView
            img.isHidden = true
            
            if indexPath.row == 0
            {
                heading.text = "Traveller Information"
                heading.font = UIFont(name: "Arimo-Bold", size: 15)
                count.text = "\(((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count) Pax"
                count.isHidden = false
            }
            else
            {
                heading.text = "\((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).value(forKey: "FirstName")!) \((((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).object(at: indexPath.row-1) as! NSDictionary).value(forKey: "LastName")!)"
                heading.font = UIFont(name: "Arimo-Regular", size: 14)
                count.isHidden = true
                
                if indexPath.row == ((dataDic.value(forKey: "flightDetail") as! NSDictionary).value(forKey: "Passenger") as! NSArray).count
                {
                    img.isHidden = false
                }
            }
        }
        else if indexPath.section == 1 && indexPath.row != 4 && indexPath.row != 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "priceCell")!
            let lbl1 = cell.viewWithTag(1) as! UILabel
            let lbl2 = cell.viewWithTag(2) as! UILabel
            lbl1.font = UIFont(name: "Arimo-Regular", size: 14)
            lbl1.textColor = supportingfuction.hexStringToUIColor(hex: "666666")
            let numberFormatter = NumberFormatter()
            numberFormatter.currencyCode = .none
            numberFormatter.groupingSeparator = ","
            numberFormatter.locale = NSLocale(localeIdentifier: "fr_FR") as Locale!
            
            if #available(iOS 9.0, *) {
                numberFormatter.numberStyle = NumberFormatter.Style.decimal
            } else {
                // Fallback on earlier versions
            }
            let total = Double("\(dataDic.value(forKey: "grand_total")!)")
            let formattedNumber = numberFormatter.string(from: NSNumber(value: Int(total!)))
            let attributedString1 = NSMutableAttributedString(string: "\(formattedNumber!)", attributes: [NSFontAttributeName : UIFont.init(name: lbl2.font.fontName, size: 13)!])
            let normalString = NSMutableAttributedString(string: "\("\u{20B9}") ",  attributes: [NSFontAttributeName : UIFont.init(name: lbl2.font.fontName, size: 10.0)!])
            normalString.append(attributedString1)
            
            if indexPath.row == 0
            {
                lbl1.text = "Total Price"
                lbl2.attributedText = normalString
            }
            else if indexPath.row == 1
            {
                lbl1.text = "Tick8 Charge"
                lbl2.attributedText = normalString
            }
            else if indexPath.row == 2
            {
                lbl1.text = "Supplier Charge"
                lbl2.attributedText = normalString
            }
            else if indexPath.row == 3
            {
                cell.backgroundColor = supportingfuction.hexStringToUIColor(hex: "dedede")
                cell.contentView.backgroundColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                lbl1.textColor = supportingfuction.hexStringToUIColor(hex: "353535")
                lbl1.font = UIFont(name: "Arimo-Bold", size: 15)
                lbl1.text = "Total Refundable Price"
                lbl2.attributedText = normalString
            }
            
            lbl1.adjustsFontSizeToFitWidth = true
            lbl2.adjustsFontSizeToFitWidth = true
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "discountCell")!
            let lbl = cell.viewWithTag(1) as! UILabel
            lbl.adjustsFontSizeToFitWidth = true
        }
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "doneCell")!
            let btn = cell.viewWithTag(1) as! UIButton
            btn.layer.cornerRadius = 19
        }
        
        return cell
    }
    
    
     @IBAction func OkBtn(_ sender: UIButton) {
    
        for vc in (self.navigationController?.viewControllers)!
        {
            if vc.restorationIdentifier == "TransactionViewController"
            {
                let container = vc as! SSASideMenu
                let v = container.contentViewController as! TransactionViewController
                v.selectedState = "3"
                
                let btn2 = v.btnheader.viewWithTag(1) as! UIButton
                btn2.isSelected = false
                
                let btn1 = v.btnheader.viewWithTag(3) as! UIButton
                btn1.isSelected = true
                
                let lbl1 = v.btnheader.viewWithTag(6) as! UILabel
                lbl1.textColor = UIColor.white
                
                let lbl = v.btnheader.viewWithTag(4) as! UILabel
                lbl.textColor = supportingfuction.hexStringToUIColor(hex: "AABFDD")
                
                v.webservice()
                self.navigationController?.popToViewController(container, animated: true)
            }
        }
    }
    
//    {
//    AirlineCode = 9W;
//    AirlineRemark = "this is 9w.";
//    BaggageAllowance = "30 KG";
//    Fare =     {
//    AdditionalTxnFeeOfrd = 0;
//    AdditionalTxnFeePub = 0;
//    BaseFare = 5800;
//    ChargeBU =         (
//    {
//    key = TBOMARKUP;
//    value = 0;
//    },
//    {
//    key = CONVENIENCECHARGE;
//    value = 0;
//    },
//    {
//    key = OTHERCHARGE;
//    value = 150;
//    }
//    );
//    CommissionEarned = 0;
//    Currency = INR;
//    Discount = 0;
//    IncentiveEarned = 0;
//    OfferedFare = 27465;
//    OtherCharges = 150;
//    PGCharge = 0;
//    PLBEarned = 0;
//    PublishedFare = 27465;
//    ServiceFee = 0;
//    Tax = 21515;
//    TaxBreakup =         (
//    {
//    key = YQTax;
//    value = 18116;
//    },
//    {
//    key = YR;
//    value = 387;
//    },
//    {
//    key = PSF;
//    value = 0;
//    },
//    {
//    key = UDF;
//    value = 0;
//    },
//    {
//    key = JNTax;
//    value = 0;
//    },
//    {
//    key = INTax;
//    value = 0;
//    },
//    {
//    key = TransactionFee;
//    value = 0;
//    },
//    {
//    key = OtherTaxes;
//    value = 0;
//    }
//    );
//    TdsOnCommission = 0;
//    TdsOnIncentive = 0;
//    TdsOnPLB = 0;
//    TotalBaggageCharges = 0;
//    TotalMealCharges = 0;
//    TotalSeatCharges = 0;
//    TotalSpecialServiceCharges = 0;
//    YQTax = 18116;
//    };
//    FareBreakdown =     (
//    {
//    AdditionalTxnFeeOfrd = 0;
//    AdditionalTxnFeePub = 0;
//    BaseFare = 5800;
//    Currency = INR;
//    PGCharge = 0;
//    PassengerCount = 1;
//    PassengerType = 1;
//    Tax = 21515;
//    YQTax = 18116;
//    }
//    );
//    FareRules =     (
//    {
//    Airline = 9W;
//    Destination = BOM;
//    FareBasisCode = K2E3MSAS;
//    FareRestriction = N;
//    FareRuleDetail = "";
//    Origin = DEL;
//    },
//    {
//    Airline = 9W;
//    Destination = SIN;
//    FareBasisCode = K2E3MSAS;
//    FareRestriction = Y;
//    FareRuleDetail = "";
//    Origin = BOM;
//    },
//    {
//    Airline = 9W;
//    Destination = DEL;
//    FareBasisCode = K2E3MSAS;
//    FareRestriction = Y;
//    FareRuleDetail = "";
//    Origin = SIN;
//    }
//    );
//    GSTAllowed = 0;
//    IsLCC = 0;
//    IsRefundable = 0;
//    LastTicketDate = 28NOV17;
//    ResultIndex = OB37;
//    Segments =     (
//    (
//    {
//    Airline =                 {
//    AirlineCode = 9W;
//    AirlineName = "Jet Airways";
//    FareClass = K;
//    FlightNumber = 354;
//    OperatingCarrier = 9W;
//    };
//    Baggage = "30 KG";
//    CabinBaggage = "<null>";
//    Craft = 739;
//    Destination =                 {
//    Airport =                     {
//    AirportCode = BOM;
//    AirportName = Mumbai;
//    CityCode = BOM;
//    CityName = Mumbai;
//    CountryCode = IN;
//    CountryName = India;
//    Terminal = 2;
//    };
//    ArrTime = "2017-11-28T21:50:00";
//    };
//    Duration = 0;
//    FlightStatus = Confirmed;
//    GroundTime = 0;
//    IsETicketEligible = 1;
//    Mile = 0;
//    NoOfSeatAvailable = 4;
//    Origin =                 {
//    Airport =                     {
//    AirportCode = DEL;
//    AirportName = "Indira Gandhi Airport";
//    CityCode = DEL;
//    CityName = Delhi;
//    CountryCode = IN;
//    CountryName = India;
//    Terminal = 3;
//    };
//    DepTime = "2017-11-28T19:45:00";
//    };
//    Remark = "<null>";
//    SegmentIndicator = 1;
//    Status = "";
//    StopOver = 0;
//    StopPoint = "";
//    StopPointArrivalTime = "2017-11-28T21:50:00";
//    StopPointDepartureTime = "2017-11-28T19:45:00";
//    TripIndicator = 1;
//    },
//    {
//    AccumulatedDuration = 685;
//    Airline =                 {
//    AirlineCode = 9W;
//    AirlineName = "Jet Airways";
//    FareClass = K;
//    FlightNumber = 12;
//    OperatingCarrier = 9W;
//    };
//    Baggage = "30 KG";
//    CabinBaggage = "<null>";
//    Craft = 332;
//    Destination =                 {
//    Airport =                     {
//    AirportCode = SIN;
//    AirportName = Changi;
//    CityCode = SIN;
//    CityName = Singapore;
//    CountryCode = SG;
//    CountryName = Singapore;
//    Terminal = 3;
//    };
//    ArrTime = "2017-11-29T09:40:00";
//    };
//    Duration = 0;
//    FlightStatus = Confirmed;
//    GroundTime = 0;
//    IsETicketEligible = 1;
//    Mile = 0;
//    NoOfSeatAvailable = 4;
//    Origin =                 {
//    Airport =                     {
//    AirportCode = BOM;
//    AirportName = Mumbai;
//    CityCode = BOM;
//    CityName = Mumbai;
//    CountryCode = IN;
//    CountryName = India;
//    Terminal = 2;
//    };
//    DepTime = "2017-11-29T01:45:00";
//    };
//    Remark = "<null>";
//    SegmentIndicator = 2;
//    Status = "";
//    StopOver = 0;
//    StopPoint = "";
//    StopPointArrivalTime = "2017-11-29T09:40:00";
//    StopPointDepartureTime = "2017-11-29T01:45:00";
//    TripIndicator = 1;
//    }
//    ),
//    (
//    {
//    AccumulatedDuration = 350;
//    Airline =                 {
//    AirlineCode = 9W;
//    AirlineName = "Jet Airways";
//    FareClass = K;
//    FlightNumber = 17;
//    OperatingCarrier = 9W;
//    };
//    Baggage = "30 KG";
//    CabinBaggage = "<null>";
//    Craft = 73H;
//    Destination =                 {
//    Airport =                     {
//    AirportCode = DEL;
//    AirportName = "Indira Gandhi Airport";
//    CityCode = DEL;
//    CityName = Delhi;
//    CountryCode = IN;
//    CountryName = India;
//    Terminal = 3;
//    };
//    ArrTime = "2017-12-06T23:00:00";
//    };
//    Duration = 350;
//    FlightStatus = Confirmed;
//    GroundTime = 0;
//    IsETicketEligible = 1;
//    Mile = 0;
//    NoOfSeatAvailable = 4;
//    Origin =                 {
//    Airport =                     {
//    AirportCode = SIN;
//    AirportName = Changi;
//    CityCode = SIN;
//    CityName = Singapore;
//    CountryCode = SG;
//    CountryName = Singapore;
//    Terminal = 3;
//    };
//    DepTime = "2017-12-06T19:40:00";
//    };
//    Remark = "<null>";
//    SegmentIndicator = 1;
//    Status = "";
//    StopOver = 0;
//    StopPoint = "";
//    StopPointArrivalTime = "2017-12-06T23:00:00";
//    StopPointDepartureTime = "2017-12-06T19:40:00";
//    TripIndicator = 2;
//    }
//    )
//    );
//    Source = 4;
//    TicketAdvisory = "TICKETS ARE NON-REFUNDABLE \nLAST TKT DTE 28NOV17  - DATE OF ORIGIN \n";
//    ValidatingAirline = 9W;
//    }

    
}
