 //
 //  DateViewController.swift
 //  Tick8
 //
 //  Created by singsys on 31/8/17.
 //  Copyright © 2017 singsys. All rights reserved.
 //
 
 import UIKit
 
 protocol dateSelection {
    func selectedDate(dateSelect:NSDictionary, returnValue:String)
 }
 
 
 class DateViewController: UIViewController {
    
    var dataDic = NSMutableDictionary()
    var searchArray:NSMutableArray = NSMutableArray()
    
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var calendarView: UIView!
    var returnJ:String = "0"
    var delegate:dateSelection!
    var dateToSend = String()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(DateViewController.dateSelected(date:)), name: Notification.Name("dateSelected"), object: nil)
        
        
        let cView = DIYExampleViewController(nibName: "DIYExampleViewController", bundle: nil)
        cView.multiple = (returnJ == "1") ? false : true
        cView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 64 - 105 - 40 - 30)
    
        self.addChildViewController(cView)
        self.calendarView.addSubview(cView.view)
        self.calendarView.isHidden = true
        
        setDeafultValues()
        getCallList()
        
        NotificationCenter.default.post(name: Notification.Name("defaultSelected"), object: dataDic)

    }
    
    func getCallList()
    {
        supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
        dateToSend = UserDefaults.standard.value(forKey: "fareDate") as! String
        flightFareWebService(dateToSend1: dateToSend)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    func dateSelected(date:NSNotification)
    {
        let dic = (date.object as! NSDictionary)
        
        if (dic.value(forKey: "start_date") != nil && dic.value(forKey: "end_date") != nil) && (dic.value(forKey: "start_date") as! Date) > (dic.value(forKey: "end_date") as! Date)
        {
            
            let temp = dic.value(forKey: "start_date") as! Date
            dic.setValue(dic.value(forKey: "end_date") as! Date, forKey: "start_date")
            dic.setValue(temp, forKey: "end_date")
            
        }
        
        if (dic.value(forKey: "start_date") != nil && dic.value(forKey: "start_date") is Date)
        {
            let startdate = dic.value(forKey: "start_date") as! Date
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: startdate)
            components.minute = 00
            components.second = 00
            components.hour = 00
            let newDate = cal.date(from: components)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let strDate:String = df.string(from: newDate!)
            dataDic.setValue(strDate, forKey: "PreferredDepartureTime")
        }
        
        
        if (dic.value(forKey: "end_date") != nil && dic.value(forKey: "end_date") is Date)
        {
            let enddate = dic.value(forKey: "end_date") as! Date
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: enddate)
            components.minute = 00
            components.second = 00
            components.hour = 00
            let newDate = cal.date(from: components)
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let strDate:String = df.string(from: newDate!)
            dataDic.setValue(strDate, forKey: "PreferredArrivalTime")
        }
        
        setDeafultValues()
    }
    
    func setDeafultValues()
    {
        let DdateView = dateView.viewWithTag(1)!
        let AdateView = dateView.viewWithTag(2)!
        
        let DdayLbl = dateView.viewWithTag(3) as! UILabel
        let DmonthLbl = dateView.viewWithTag(4) as! UILabel
        let DyearLbl = dateView.viewWithTag(5) as! UILabel
        let AdayLbl = dateView.viewWithTag(6) as! UILabel
        let AmonthLbl = dateView.viewWithTag(7) as! UILabel
        let Ayr = dateView.viewWithTag(8) as! UILabel
        let delbtn = dateView.viewWithTag(11) as! UIButton
        
        
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let months:NSMutableArray = ["Jan","Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
        
        
        
        if dataDic.value(forKey: "PreferredDepartureTime") != nil && dataDic.value(forKey: "PreferredDepartureTime") is String
        {
            let stDate = df.date(from: dataDic.value(forKey: "PreferredDepartureTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: stDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                DdayLbl.text = "0\(components.day!)"
            }
            else
            {
                DdayLbl.text = "\(components.day!)"
            }
            DmonthLbl.text = (months.object(at: m-1) as! String)
            DyearLbl.text = "\(components.year!)"
        }
        
        
        if dataDic.value(forKey: "PreferredArrivalTime") != nil && dataDic.value(forKey: "PreferredArrivalTime") is String
        {
            let endDate = df.date(from: dataDic.value(forKey: "PreferredArrivalTime") as! String)
            let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
            var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: endDate!)
            let m = components.month!
            
            if components.day! < 10
            {
                AdayLbl.text = "0\(components.day!)"
            }
            else
            {
                AdayLbl.text = "\(components.day!)"
            }
            AmonthLbl.text = (months.object(at: m-1) as! String)
            Ayr.text = "\(components.year!)"
        }
        
        if "\(returnJ)" == "0"
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
    
    //MARK:- string to date conversion
    func convertDateFormatter(date: String) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//this is your string date format
        var dateDate = dateFormatter.date(from: date)
        let calendar = NSCalendar.current
        var components = calendar.dateComponents([.day, .month, .year], from: dateDate! as Date)

        components.month = components.month! + 1
        if components.month! > 12
        {
            components.month = 1
            components.year = components.year! + 1
        }
        
        dateDate = calendar.date(from: components)
        
        return dateFormatter.string(from: dateDate!)
    }
    
    
    
    //MARK:- button handling
    
    @IBAction func dateCell(_ sender: UIButton) {
        if sender.tag == 12
        {
            
        }
        else if sender.tag == 13
        {
            if "\(returnJ)" == "0"
            {
                return
            }
            
            if dataDic.value(forKey: "PreferredArrivalTime") == nil
            {
                dataDic.setValue(dataDic.value(forKey: "PreferredDepartureTime"), forKey: "PreferredArrivalTime")
            }
            returnJ = "0"
            
            for childView in self.childViewControllers
            {
                childView.view.removeFromSuperview()
                childView.didMove(toParentViewController: nil)
                childView.removeFromParentViewController()
            }
            
            let cView = DIYExampleViewController(nibName: "DIYExampleViewController", bundle: nil)
            if returnJ == "1"
            {
                cView.multiple = false
            }
            else
            {
                cView.multiple = true
            }
            cView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calendarView.frame.size.height)
            
            NotificationCenter.default.post(name: Notification.Name("defaultSelected"), object: dataDic)
            
            self.addChildViewController(cView)
            self.calendarView.addSubview(cView.view)
            
            if searchArray.count > 0
            {
            NotificationCenter.default.post(name: Notification.Name("calendarFare"), object: self.searchArray)
            }
            
            setDeafultValues()
        }
    }
    
    
    @IBAction func deleteBtn(_ sender: UIButton) {
        returnJ = "1"
        
        for childView in self.childViewControllers
        {
            childView.view.removeFromSuperview()
            childView.didMove(toParentViewController: nil)
            childView.removeFromParentViewController()
        }
        
        dataDic.removeObject(forKey: "PreferredArrivalTime")
        let cView = DIYExampleViewController(nibName: "DIYExampleViewController", bundle: nil)
        if returnJ == "1"
        {
            cView.multiple = false
        }
        else
        {
            cView.multiple = true
        }
        cView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.calendarView.frame.size.height)
       // cView.view.frame.size = self.calendarView.frame.size
        
        NotificationCenter.default.post(name: Notification.Name("defaultSelected"), object: dataDic)
        
        self.addChildViewController(cView)
        self.calendarView.addSubview(cView.view)
        
        if searchArray.count > 0
        {
            NotificationCenter.default.post(name: Notification.Name("calendarFare"), object: self.searchArray)
        }
    
        setDeafultValues()
    }
    
    
    @IBAction func backBtn(_sender: UIButton)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func okBtn(_sender: UIButton) {
        
        delegate.selectedDate(dateSelect: dataDic, returnValue:returnJ)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func flightFareWebService(dateToSend1:String)
    {
        
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Content-Type")
                // requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 60
                
                let segmentDic = NSMutableDictionary()
                
                segmentDic.setValue(dataDic.value(forKey: "Origin") as! String, forKey: "Origin")
                segmentDic.setValue(dataDic.value(forKey: "Destination") as! String, forKey: "Destination")
                segmentDic.setValue("1", forKey: "FlightCabinClass")
                segmentDic.setValue(dateToSend1, forKey: "PreferredDepartureTime")
                
                let segmentAray = NSMutableArray()
                
                segmentAray.add(segmentDic)
                
                let params = NSMutableDictionary()
                
                if UserDefaults.standard.value(forKey: "EndUserIp") == nil || UserDefaults.standard.value(forKey: "EndUserIp") as! String == ""
                {
                    appDel.getIpWebservice()
                    NotificationCenter.default.addObserver(self, selector: #selector(DateViewController.getCallList), name: Notification.Name("ipGenerated"), object: nil)
                    return
                }
                else
                {
                    NotificationCenter.default.removeObserver(self, name: Notification.Name("ipGenerated"), object: nil)
                    params.setValue("\(UserDefaults.standard.value(forKey: "EndUserIp")!)", forKey: "EndUserIp")
                }
                params.setValue("\(UserDefaults.standard.value(forKey: "token")!)", forKey: "TokenId")
                params.setValue("1", forKey: "JourneyType")
                params.setValue(NSNull(), forKey: "PreferredAirlines")
                params.setValue(segmentAray as NSArray, forKey: "Segments")
                
//                supportingfuction.hideProgressHudInView(view: self.view)
//                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BOOK_URL + "GetCalendarFare"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
//                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "1")
                            {
                                self.searchArray.addObjects(from: ((dataFromServer.value(forKey: "Response")  as! NSDictionary).value(forKey: "SearchResults") as! NSArray) as! [Any])
                                self.count = self.count + 1
                                if self.count == 3
                                {
                                    supportingfuction.hideProgressHudInView(view: self.view)
                                    self.calendarView.isHidden = false
                                }
                                else
                                {
                                    self.dateToSend = self.convertDateFormatter(date: self.dateToSend)
                                    self.flightFareWebService(dateToSend1: self.dateToSend)
                                }
                                
                                NotificationCenter.default.post(name: Notification.Name("calendarFare"), object: self.searchArray)
                                NotificationCenter.default.post(name: Notification.Name("defaultSelected"), object: self.dataDic)
                            }
                            else if (("\((dataFromServer.value(forKey: "Response") as! NSDictionary).value(forKey: "ResponseStatus")!)") == "4")
                            {
                                appDel.getIpWebservice()
                                NotificationCenter.default.addObserver(self, selector: #selector(DateViewController.getCallList), name: Notification.Name("ipGenerated"), object: nil)
                                return
                            }
                            else
                            {
                                self.calendarView.isHidden = false
                                supportingfuction.hideProgressHudInView(view: self.view)
                                NotificationCenter.default.post(name: Notification.Name("defaultSelected"), object: self.dataDic)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                  //  print(error)
                     self.calendarView.isHidden = false
                    supportingfuction.hideProgressHudInView(view: self.view)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                 self.calendarView.isHidden = false
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
 }
