//
//  HomeViewController.swift
//  Tick8
//
//  Created by singsys on 28/7/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,cityListing, dateSelection{
    
    @IBOutlet weak var tblview: UITableView!
    var dataDic:NSMutableDictionary = NSMutableDictionary()
    var adultPassen = 1
    var childPassen = 0
    var infantPassen = 0
    var imageturn = false
    var webHit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if #available(iOS 11.0, *) {
            tblview.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        bannerWebservice()
        self.navigationController?.navigationBar.isHidden = true
        
        dataDic.setValue("FROM", forKey: "Origin")
        dataDic.setValue("", forKey: "OriginCity")
        dataDic.setValue("TO", forKey: "Destination")
        dataDic.setValue("", forKey: "DestinationCity")
//        dataDic.setValue("DEL", forKey: "Origin")
//        dataDic.setValue("Delhi", forKey: "OriginCity")
//        dataDic.setValue("India", forKey: "OriginCountry")
//        dataDic.setValue("BOM", forKey: "Destination")
//        dataDic.setValue("Mumbai", forKey: "DestinationCity")
//        dataDic.setValue("India", forKey: "DestinationCountry")
        
        dataDic.setValue("0", forKey: "return")
        dataDic.setValue("Economy", forKey: "class")
        
        let date = Date()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: date)
        components.minute = 00
        components.second = 00
        components.hour = 00
        let newDate = cal.date(from: components)
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let strDate:String = df.string(from: newDate!)
       // "2017-11-28T00:00:00"
        dataDic.setValue(strDate, forKey: "PreferredDepartureTime")
        dataDic.setValue(strDate, forKey: "PreferredArrivalTime")
        
        
        NotificationCenter.default.addObserver(self, selector:#selector(HomeViewController.bannerWebservice), name: NSNotification.Name.reachabilityChanged, object: nil);
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.isStatusBarHidden = false
    }
    
    //MARK:- tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        if indexPath.row == 0
        {
            height = 220
        }
        else if indexPath.row == 1
        {
            height = 120
        }
        else if indexPath.row == 2
        {
            height = 80
        }
        else if indexPath.row == 3
        {
            height = 90
        }
        else if indexPath.row == 4
        {
            height = 140
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "skybgCell")!
            let flightImage = cell.viewWithTag(5) as! UIImageView
            if dataDic.value(forKey: "return") == nil || "\(dataDic.value(forKey: "return")!)" == "0"
            {
                flightImage.image = #imageLiteral(resourceName: "twoWay")
                flightImage.contentMode = .scaleAspectFit
            }
            else
            {
                if imageturn == false
                {
                    flightImage.image = #imageLiteral(resourceName: "oneWayD")
                    flightImage.contentMode = .center
                }
                else
                {
                    flightImage.image = #imageLiteral(resourceName: "oneWayA")
                    flightImage.contentMode = .center
                }
            }
            
            let codeDcity = cell.viewWithTag(1) as! UILabel
            let Dpcity = cell.viewWithTag(3) as! UILabel
            
            let codeAcity = cell.viewWithTag(2) as! UILabel
            let Arcity = cell.viewWithTag(4) as! UILabel
            //  let Abtn = cell.viewWithTag(7) as! UIButton
            
            if dataDic.value(forKey: "Origin") != nil && dataDic.value(forKey: "Origin") is String
            {
                codeDcity.text = dataDic.value(forKey: "Origin") as? String
            }
            
            if dataDic.value(forKey: "OriginCity") != nil && dataDic.value(forKey: "OriginCity") is String
            {
                Dpcity.text = dataDic.value(forKey: "OriginCity") as? String
            }
            
            if dataDic.value(forKey: "Destination") != nil && dataDic.value(forKey: "Destination") is String
            {
                codeAcity.text = dataDic.value(forKey: "Destination") as? String
            }
            
            if dataDic.value(forKey: "DestinationCity") != nil && dataDic.value(forKey: "DestinationCity") is String
            {
                Arcity.text = dataDic.value(forKey: "DestinationCity") as? String
            }
            codeDcity.adjustsFontSizeToFitWidth = true
            codeAcity.adjustsFontSizeToFitWidth = true
            Dpcity.adjustsFontSizeToFitWidth = true
            Arcity.adjustsFontSizeToFitWidth = true
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "dateCell")!
            
            let DdateView = cell.viewWithTag(1)!
            let AdateView = cell.viewWithTag(2)!
            
            let DdayLbl = cell.viewWithTag(3) as! UILabel
            let DmonthLbl = cell.viewWithTag(4) as! UILabel
            let Dyrlbl = cell.viewWithTag(5) as! UILabel
            let AdayLbl = cell.viewWithTag(6) as! UILabel
            let AmonthLbl = cell.viewWithTag(7) as! UILabel
            let Ayr = cell.viewWithTag(8) as! UILabel
            let delbtn = cell.viewWithTag(11) as! UIButton
            
            let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
            if dataDic.value(forKey: "return") == nil || "\(dataDic.value(forKey: "return")!)" == "0"
            {
                AdayLbl.isHidden = false
                AmonthLbl.isHidden = false
                Ayr.isHidden = false
                delbtn.isHidden = false
            }
            else
            {
                AdayLbl.isHidden = true
                AmonthLbl.isHidden = true
                Ayr.isHidden = true
                delbtn.isHidden = true
            }
            
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            if dataDic.value(forKey: "PreferredDepartureTime") != nil && dataDic.value(forKey: "PreferredDepartureTime") is String
            {
                let stDate = df.date(from: dataDic.value(forKey: "PreferredDepartureTime") as! String)
                let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
                if components.day! < 10
                {
                    DdayLbl.text = "0\(components.day!)"
                }
                else
                {
                    DdayLbl.text = "\(components.day!)"
                }
                let m = components.month!
                DmonthLbl.text = (months.object(at: m-1) as! String)
                Dyrlbl.text = "\(components.year!)"
            }
            
            DdayLbl.adjustsFontSizeToFitWidth = true
            DmonthLbl.adjustsFontSizeToFitWidth = true
            Dyrlbl.adjustsFontSizeToFitWidth = true
            
            if dataDic.value(forKey: "PreferredArrivalTime") != nil && dataDic.value(forKey: "PreferredArrivalTime") is String
            {
                let endDate = df.date(from: dataDic.value(forKey: "PreferredArrivalTime") as! String)
                let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
                var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: endDate!)
                if components.day! < 10
                {
                    AdayLbl.text = "0\(components.day!)"
                }
                else
                {
                    AdayLbl.text = "\(components.day!)"
                }
                
                let m = components.month!
                AmonthLbl.text = (months.object(at: m-1) as! String)
                Ayr.text = "\(components.year!)"
            }
            
            AdayLbl.adjustsFontSizeToFitWidth = true
            AmonthLbl.adjustsFontSizeToFitWidth = true
            Ayr.adjustsFontSizeToFitWidth = true
            
            //for shadow on the view.
            DdateView.layer.cornerRadius = 5
            DdateView.layer.masksToBounds =  false
            DdateView.layer.shadowColor = UIColor.darkGray.cgColor
            DdateView.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            DdateView.layer.shadowOpacity = 0.5
            DdateView.layer.shadowRadius = 5
            
            AdateView.layer.cornerRadius = 5
            AdateView.layer.masksToBounds =  false
            AdateView.layer.shadowColor = UIColor.darkGray.cgColor
            AdateView.layer.shadowOffset = CGSize(width: 1, height: 1)
            AdateView.layer.shadowOpacity = 0.5
            AdateView.layer.shadowRadius = 5
            
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "passengerCell")!
            
            let Adview = cell.viewWithTag(1)!
            let Adlbl = cell.viewWithTag(2) as! UILabel
            let ChView = cell.viewWithTag(3)!
            let Chlbl = cell.viewWithTag(4) as! UILabel
            let InView = cell.viewWithTag(5)!
            let Inlbl = cell.viewWithTag(6) as! UILabel
            
            //for shadow on the view.
            Adview.layer.cornerRadius = 5
            Adview.layer.masksToBounds =  false
            Adview.layer.shadowColor = UIColor.darkGray.cgColor
            Adview.layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
            Adview.layer.shadowOpacity = 0.5
            Adview.layer.shadowRadius = 2
            
            ChView.layer.cornerRadius = 5
            ChView.layer.masksToBounds =  false
            ChView.layer.shadowColor = UIColor.darkGray.cgColor
            ChView.layer.shadowOffset = CGSize(width: 1, height: 1)
            ChView.layer.shadowOpacity = 0.5
            ChView.layer.shadowRadius = 2
            
            InView.layer.cornerRadius = 5
            InView.layer.masksToBounds =  false
            InView.layer.shadowColor = UIColor.darkGray.cgColor
            InView.layer.shadowOffset = CGSize(width: 1, height: 1)
            InView.layer.shadowOpacity = 0.5
            InView.layer.shadowRadius = 2
            
            
            //label passenger value set
            Adlbl.text = "\(adultPassen)"
            Chlbl.text = "\(childPassen)"
            Inlbl.text = "\(infantPassen)"
        }
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "classCell")!
            let collection = cell.viewWithTag(2) as! UICollectionView
            collection.delegate = self
            collection.dataSource = self
            collection.reloadData()
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "bannerCell")!
            let collection = cell.viewWithTag(1) as! UICollectionView
            collection.delegate = self
            collection.dataSource = self
            collection.reloadData()
        }
        return cell
    }
    
    
    //MARK:- Collection view functions
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size  = CGSize(width: 170, height: 100)
        
        if collectionView.tag == 2
        {
            let lbl = UILabel()
            
            if indexPath.row == 0
            {
                lbl.text = "Economy"
                size = CGSize(width: lbl.intrinsicContentSize.width+15, height: 40)
            }
            else if indexPath.row == 1
            {
                lbl.text = "Premium Economy"
                size = CGSize(width: lbl.intrinsicContentSize.width+10, height: 40)
            }
            else if indexPath.row == 2
            {
                lbl.text = "Business"
                size = CGSize(width: lbl.intrinsicContentSize.width+15, height: 40)
            }
            else if indexPath.row == 3
            {
                lbl.text = "First"
                size = CGSize(width: lbl.intrinsicContentSize.width+30, height: 40)
            }
            
        }
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 1 && dataDic.value(forKey: "banner") != nil
        {
            return (dataDic.value(forKey: "banner") as! NSArray).count
        }
        else if collectionView.tag == 2
        {
            return 4
        }
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if collectionView.tag == 1
        {
            if(Reachability.forInternetConnection().isReachable() && dataDic.value(forKey: "banner") == nil && webHit == false)
            {
                
                
            }
            
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
            let imgView = cell.viewWithTag(2) as! UIImageView
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds =  false
            cell.layer.shadowColor = UIColor.darkGray.cgColor
            cell.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
            cell.layer.shadowOpacity = 0.3
            cell.layer.shadowRadius = 1
            
            if dataDic.value(forKey: "banner") != nil
            {
                imgView.setImageWith(URL(string: "\(BASE_URL)\(((dataDic.value(forKey: "banner") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "image")!)")!, placeholderImage: #imageLiteral(resourceName: "default_coupon"))
            }
            else
            {
                
                imgView.image = #imageLiteral(resourceName: "default_coupon")
            }
        }
        else if collectionView.tag == 2
        {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: "contentCell", for: indexPath)
            let lbl = cell.viewWithTag(1) as! UILabel
            
            if indexPath.row == 0
            {
                lbl.text = "Economy"
                
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Economy"
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.shadowOpacity = 0
                    lbl.layer.borderColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    lbl.textColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0)
                }
                else
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.masksToBounds =  false
                    lbl.layer.borderColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowOffset = CGSize(width: 0.9, height: 0.9)
                    lbl.layer.shadowOpacity = 0.4
                    lbl.layer.shadowRadius = 2
                    lbl.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                }
            }
            else if indexPath.row == 1
            {
                lbl.text = "Premium Economy"
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Premium Economy"
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.shadowOpacity = 0
                    lbl.layer.borderColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    lbl.textColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0)
                }
                else
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.masksToBounds =  false
                    lbl.layer.borderColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowOffset = CGSize(width: 0.9, height: 0.9)
                    lbl.layer.shadowOpacity = 0.4
                    lbl.layer.shadowRadius = 2
                    lbl.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                }
            }
            else if indexPath.row == 2
            {
                lbl.text = "Business"
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "Business"
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.shadowOpacity = 0
                    lbl.layer.borderColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    lbl.textColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0)
                }
                else
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.masksToBounds =  false
                    lbl.layer.borderColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowOffset = CGSize(width: 0.9, height: 0.9)
                    lbl.layer.shadowOpacity = 0.4
                    lbl.layer.shadowRadius = 2
                    lbl.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                }
            }
            else if indexPath.row == 3
            {
                lbl.text = "First"
                if dataDic.value(forKey: "class") != nil && dataDic.value(forKey: "class") as! String == "First"
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.shadowOpacity = 0
                    lbl.layer.borderColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
                    lbl.textColor = UIColor(red: 21/255, green: 88/255, blue: 169/255, alpha: 1.0)
                }
                else
                {
                    lbl.layer.borderWidth = 1
                    lbl.layer.masksToBounds =  false
                    lbl.layer.borderColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowColor = UIColor.lightGray.cgColor
                    lbl.layer.shadowOffset = CGSize(width: 0.9, height: 0.9)
                    lbl.layer.shadowOpacity = 0.4
                    lbl.layer.shadowRadius = 2
                    lbl.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                }
            }
            lbl.layer.cornerRadius = 14
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            dataDic.setValue("Economy", forKey: "class")
        }
        else if indexPath.row == 1
        {
            dataDic.setValue("Premium Economy", forKey: "class")
        }
        else if indexPath.row == 2
        {
            dataDic.setValue("Business", forKey: "class")
        }
        else if indexPath.row == 3
        {
            dataDic.setValue("First", forKey: "class")
        }
        
        collectionView.reloadData()
    }
    
    
    //MARK:- button handling
    @IBAction func citySelection(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        
        if sender.tag == 6
        {
            vc.from = "cityListing1"
        }
        else
        {
            vc.from = "cityListing2"
        }
        vc.cityDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func cityList(value1: NSDictionary, value2: String)
    {
        let index = IndexPath(row: 0, section: 0)
        let cell = tblview.cellForRow(at: index)
        
        if (value2 == "destination" && (dataDic.value(forKey: "Origin") != nil) && (value1.value(forKey: "city_code") != nil) && (dataDic.value(forKey: "Origin") as! String) == value1.value(forKey: "city_code") as! String) || (value2 == "origin" && (dataDic.value(forKey: "Destination") != nil) && (value1.value(forKey: "city_code") != nil) && (dataDic.value(forKey: "Destination") as! String) == value1.value(forKey: "city_code") as! String)
        {
            supportingfuction.showMessageHudWithMessage(message: differentCities, delay: 2.0)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                // Put your code which should be executed with a delay here
                if value2 == "origin"
                {
                    let btn = cell?.viewWithTag(6) as! UIButton
                    self.citySelection(btn)
                    
                }
                else
                {
                    let btn = cell?.viewWithTag(7) as! UIButton
                    self.citySelection(btn)
                }
            })
            
            return
        }
        
        if value2 == "origin"
        {
            dataDic.setValue(value1.value(forKey: "city_code") as! String, forKey: "Origin")
            dataDic.setValue(value1.value(forKey: "city_name") as! String, forKey: "OriginCity")
            dataDic.setValue(value1.value(forKey: "country_name") as! String, forKey: "OriginCountry")
        }
        else if value2 == "destination"
        {
            dataDic.setValue(value1.value(forKey: "city_code") as! String, forKey: "Destination")
            dataDic.setValue(value1.value(forKey: "city_name") as! String, forKey: "DestinationCity")
            dataDic.setValue(value1.value(forKey: "country_name") as! String, forKey: "DestinationCountry")
        }
        
        self.tblview.reloadData()
    }
    
    @IBAction func passengerAdd(_ sender: UIButton)
    {
        
        if sender.tag == 8 && adultPassen < 9
        {
            adultPassen += 1
            //Adult add
        }
        else if sender.tag == 10 && childPassen < 9
        {
            childPassen += 1
            //children add
        }
        else if sender.tag == 12 && infantPassen < 9
        {
            infantPassen += 1
            //infant add
        }
        self.tblview.reloadData()
    }
    
    @IBAction func passengerMinus(_ sender: UIButton) {
        
        if sender.tag == 7
        {
            if adultPassen != 0
            {
                adultPassen -= 1
            }
            //Adult minus
        }
        else if sender.tag == 9
        {
            if childPassen != 0
            {
                childPassen -= 1
            }
            //children minus
        }
        else if sender.tag == 11
        {
            if infantPassen != 0
            {
                infantPassen -= 1
            }
            //infant minus
        }
        self.tblview.reloadData()
    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        dataDic.setValue("1", forKey: "return")
        self.tblview.reloadData()
    }
    
    @IBAction func sidemenu(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func switchCities(_ sender: UIButton) {
        
        if dataDic.value(forKey: "Origin") as! String == "FROM" || dataDic.value(forKey: "Destination") as! String == "TO"
        {
            return
        }
        
        let hit = sender.convert(CGPoint.zero, to: self.tblview)
        let indexPath = self.tblview.indexPathForRow(at: hit)
        let cell = tblview.cellForRow(at: indexPath!)
        
        let Dcitylbl = cell?.viewWithTag(1) as! UILabel
        let Dfcity = cell?.viewWithTag(3) as! UILabel
        
        let Acitylbl = cell?.viewWithTag(2) as! UILabel
        let Afcity = cell?.viewWithTag(4) as! UILabel
        let imgView = cell?.viewWithTag(5) as! UIImageView
        rotateView(targetView: imgView)
        
        let dcityX = Dcitylbl.frame.origin.x
        let acityX = Acitylbl.frame.origin.x
        
        UIView.animate(withDuration: 0.4) {
            Dcitylbl.frame.origin.x = acityX
            Dfcity.frame.origin.x = acityX
            Acitylbl.frame.origin.x = dcityX
            Afcity.frame.origin.x = dcityX
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            
            Dcitylbl.frame.origin.x = dcityX
            Dfcity.frame.origin.x = dcityX
            Acitylbl.frame.origin.x = acityX
            Afcity.frame.origin.x = acityX
            
            let codeD = self.dataDic.value(forKey: "Origin") as! String
            let Dcity = self.dataDic.value(forKey: "OriginCity") as! String
            let codeA = self.dataDic.value(forKey: "Destination") as! String
            let Acity = self.dataDic.value(forKey: "DestinationCity") as! String
            
            self.dataDic.setValue(codeA, forKey: "Origin")
            self.dataDic.setValue(Acity, forKey: "OriginCity")
            self.dataDic.setValue(codeD, forKey: "Destination")
            self.dataDic.setValue(Dcity, forKey: "DestinationCity")
            
            Dcitylbl.text = self.dataDic.value(forKey: "Origin") as? String
            Dfcity.text = self.dataDic.value(forKey: "OriginCity") as? String
            Acitylbl.text = self.dataDic.value(forKey: "Destination") as? String
            Afcity.text = self.dataDic.value(forKey: "DestinationCity") as? String
        }
        
        if dataDic.value(forKey: "return") != nil && "\(dataDic.value(forKey: "return")!)" == "0"
        {
            imgView.image = #imageLiteral(resourceName: "twoWay")
            imgView.contentMode = .scaleAspectFit
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) {
            self.tblview.reloadData()
        }
    }
    
    
    func selectedDate(dateSelect:NSDictionary, returnValue:String)
    {
        dataDic.setValue("\(returnValue)", forKey: "return")
        dataDic.setValue(dateSelect.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredDepartureTime")
        
        if dateSelect.value(forKey: "PreferredArrivalTime") == nil
        {
            dataDic.setValue(dateSelect.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredArrivalTime")
        }
        else
        {
            dataDic.setValue(dateSelect.value(forKey: "PreferredArrivalTime") as! String, forKey: "PreferredArrivalTime")
        }
        self.tblview.reloadData()
    }
    
    
    @IBAction func dateCell(_ sender: UIButton) {
        
        if sender.tag == 12 || (sender.tag == 13 && (dataDic.value(forKey: "return") == nil || "\(dataDic.value(forKey: "return")!)" == "0"))
        {
            if (((dataDic.value(forKey: "OriginCity")) == nil) || (dataDic.value(forKey: "OriginCity")as! String == "")) || (((dataDic.value(forKey: "DestinationCity")) == nil) || (dataDic.value(forKey: "DestinationCity") as! String == ""))
            {
                supportingfuction.showMessageHudWithMessage(message: selectCities, delay: 2.0)
                return
            }
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "DateViewController") as! DateViewController
            vc.returnJ = "\(dataDic.value(forKey: "return")!)"
            vc.dataDic.setValue(dataDic.value(forKey: "Origin") as! String, forKey: "Origin")
            vc.dataDic.setValue(dataDic.value(forKey: "Destination") as! String, forKey: "Destination")
            vc.delegate = self;
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            
            vc.dataDic.setValue(dataDic.value(forKey: "PreferredDepartureTime") as! String, forKey: "PreferredDepartureTime")
            
            if "\(dataDic.value(forKey: "return")!)" == "0"
            {
                vc.dataDic.setValue(dataDic.value(forKey: "PreferredArrivalTime") as! String, forKey: "PreferredArrivalTime")
            }
            
            let date = Date()
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: date)
            components.minute = 00
            components.second = 00
            components.hour = 00
            let newDate = cal.date(from: components)
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let strDate:String = df.string(from: newDate!)
            
            UserDefaults.standard.setValue(strDate, forKey: "fareDate")
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            dataDic.setValue("0", forKey: "return")
            self.tblview.reloadData()
        }
    }
    
    @IBAction func searchFlightBtn(_ sender: UIButton) {
        
        if (dataDic.value(forKey: "Origin") == nil) || (dataDic.value(forKey: "Origin") as! String == "") || (dataDic.value(forKey: "OriginCity") == nil) || (dataDic.value(forKey: "OriginCity") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: selectDepartCity, delay: 2.0)
            return
        }
        else if (dataDic.value(forKey: "Destination") == nil) || (dataDic.value(forKey: "Destination") as! String == "") || (dataDic.value(forKey: "DestinationCity") == nil) || (dataDic.value(forKey: "DestinationCity") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: selectArriveCity, delay: 2.0)
            return
        }
        else if (dataDic.value(forKey: "PreferredDepartureTime") == nil) || (dataDic.value(forKey: "PreferredDepartureTime") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: selectDepartDate, delay: 2.0)
            return
        }
        else if (dataDic.value(forKey: "PreferredArrivalTime") == nil) || (dataDic.value(forKey: "PreferredArrivalTime") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: selectArriveDate, delay: 2.0)
            return
        }
        else if (adultPassen == 0) && (childPassen == 0)
        {
            supportingfuction.showMessageHudWithMessage(message: selectPassengers, delay: 2.0)
            return
        }
        else if (adultPassen < infantPassen)
        {
            supportingfuction.showMessageHudWithMessage(message: infants, delay: 2.0)
            return
        }
        else if (adultPassen > 9 || childPassen > 9 || infantPassen > 9 || (adultPassen + childPassen + infantPassen) > 9)
        {
            supportingfuction.showMessageHudWithMessage(message: passengerlimit, delay: 2.0)
            return
        }
        else if (dataDic.value(forKey: "class") == nil) || (dataDic.value(forKey: "class") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: selectClass, delay: 2.0)
            return
        }
        
        searchFlightClicked()
    }
    
    func searchFlightClicked()
    {
        dataDic.setValue("\(adultPassen)", forKey: "AdultCount")
        dataDic.setValue("\(childPassen)", forKey: "ChildCount")
        dataDic.setValue("\(infantPassen)", forKey: "InfantCount")
        let storyboard = UIStoryboard(name: "Main2", bundle: nil)
        if dataDic.value(forKey: "return") != nil && dataDic.value(forKey: "return") as! String == "0"
        {
            let vc = storyboard.instantiateViewController(withIdentifier: "TwoWayViewController") as! TwoWayViewController
            vc.dataDic = dataDic.mutableCopy() as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            
            let vc = storyboard.instantiateViewController(withIdentifier: "SingleWayViewController") as! SingleWayViewController
            if dataDic.value(forKey: "OriginCountry") != nil && dataDic.value(forKey: "DestinationCountry") != nil && ("\(dataDic.value(forKey: "OriginCountry")!)" != "India" || "\(dataDic.value(forKey: "DestinationCountry")!)" != "India")
            {
                vc.from = "internationalsingle"
            }
            vc.dataDict = self.dataDic.mutableCopy() as! NSMutableDictionary
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    
    // Rotate <targetView> indefinitely
    private func rotateView(targetView: UIImageView, duration: Double = 0.5) {
        
        if imageturn == true
        {
            imageturn = false
        }
        else
        {
            imageturn = true
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations:
            {
                targetView.transform = targetView.transform.rotated(by: CGFloat(Double.pi))
        }, completion: nil)
    }
    
    func bannerWebservice()
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
                self.webHit = true
                manager.get(("\(BASE_URL)api/getCouponImages"), parameters: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        self.webHit = false
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                         
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                self.dataDic.setValue(dataFromServer.value(forKey: "data") as! NSArray, forKey: "banner")
                                self.tblview.reloadRows(at: [IndexPath(row: 4, section: 0)], with: .none)
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in

                })
            }
            else
            {
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
}
