//
//  DIYViewController.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

class DIYExampleViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    var dateCount = 0
    let dateSelectionLimit = 6
    var dataDic = NSMutableDictionary()
    
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    fileprivate weak var calendar: FSCalendar!
    fileprivate weak var eventLabel: UILabel!
    var startDate:Date = Date()
    var endDate:Date = Date()
    var frame:CGRect!
    
    var multiple = false
    
    // MARK:- Life cycle
    
    override func loadView() {
        let view = UIView(frame: frame)
        view.backgroundColor = UIColor.white //groupTableViewBackground
        self.view = view
        let calendar = FSCalendar(frame: frame)
        calendar.dataSource = self
        calendar.delegate = self
        calendar.allowsMultipleSelection = multiple
        
        view.addSubview(calendar)
        self.calendar = calendar
        calendar.placeholderType = .none
        calendar.appearance.subtitleDefaultColor = UIColor.lightGray
        calendar.appearance.titleFont = UIFont(name: "Arial", size: 12)
        calendar.appearance.subtitleFont = UIFont(name: "Arial", size: 8)
        calendar.appearance.titleOffset = CGPoint(x: 0, y: 4)
        calendar.calendarHeaderView.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        calendar.calendarWeekdayView.backgroundColor = UIColor.blue.withAlphaComponent(0.1)
        calendar.today = nil // Hide the today circle
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.appearance.selectionColor = supportingfuction.hexStringToUIColor(hex: "1F58A9")
        calendar.swipeToChooseGesture.isEnabled = true // Swipe-To-Choose
        let scopeGesture = UIPanGestureRecognizer(target: calendar, action: #selector(calendar.handleScopeGesture(_:)));
        calendar.addGestureRecognizer(scopeGesture)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DIYExampleViewController.fareSubtitle(fare:)), name: Notification.Name("calendarFare"), object: nil)
    }
    
   
    func fareSubtitle(fare:NSNotification) {
        let search = (fare.object as! NSArray)
        dataDic.setValue(search as! NSArray, forKey: "fareArray")
        calendar.reloadData()
    }
    
    func selectdates(date:NSNotification){
        if (date.object as! NSDictionary).value(forKey: "PreferredDepartureTime") != nil && (date.object as! NSDictionary).value(forKey: "PreferredArrivalTime") != nil{
            let df = DateFormatter()
              df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let start = df.date(from: (date.object as! NSDictionary).value(forKey: "PreferredDepartureTime") as! String)
            let end = df.date(from:  (date.object as! NSDictionary).value(forKey: "PreferredArrivalTime") as! String)
            self.startDate = start!
            self.endDate = end!
            calendar.delegate = self
            calendar.appearance.selectionColor = supportingfuction.hexStringToUIColor(hex: "1F58A9")
            self.calendar.select(startDate)
            self.calendar.select(endDate)
            dateCount = 2
            self.configureVisibleCells()
        }else{
            let df = DateFormatter()
             df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let start = df.date(from: (date.object as! NSDictionary).value(forKey: "PreferredDepartureTime") as! String)
            dateCount = 1
            calendar.select(start, scrollToDate: true)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if dataDic.value(forKey: "start_date") != nil
        {
            calendar.select(dataDic.value(forKey: "start_date")!)
        }
        
        if  dataDic.value(forKey: "end_date") != nil
        {
            calendar.select(dataDic.value(forKey: "end_date")!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "FSCalendar"
        // Uncomment this to perform an 'initial-week-scope'
        
        calendar.scrollDirection = .vertical
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        calendar.appearance.subtitleDefaultColor = UIColor.lightGray
        calendar.appearance.subtitleSelectionColor = UIColor.lightGray
        self.configureCalendar()
    }
    
    func configureCalendar(){
        
        NotificationCenter.default.addObserver(self, selector: #selector(DIYExampleViewController.selectdates), name: Notification.Name("defaultSelected"), object: nil)
        calendar.delegate = self
        calendar.firstWeekday = 1
        calendar.dataSource = self
        calendar.register(DIYCalendarCell.self, forCellReuseIdentifier: "cell")
        calendar.scope = .month
        calendar.allowsMultipleSelection = multiple
        calendar.clipsToBounds = true
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        calendar.scrollDirection = .vertical
        calendar.appearance.caseOptions = [.headerUsesUpperCase]
        calendar.appearance.selectionColor = supportingfuction.hexStringToUIColor(hex: "1F58A9")
        calendar.appearance.headerTitleColor = UIColor.black.withAlphaComponent(0.7)
        calendar.appearance.weekdayTextColor = UIColor.black
    }

    
    // MARK:- FSCalendarDataSource
    func minimumDate(for calendar: FSCalendar) -> Date
    {
        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        
        return (dtFormatter.date(from:(dtFormatter.string(from: Date()))))!
    }

    func maximumDate(for calendar: FSCalendar) -> Date {

        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        var components = cal.components([.day, .month, .year, .hour , .minute, .second ], from: Date())
   //     components.month = components.month!+2
        components.year = components.year! + 1
        
//        let arr = [1,3,5,7,8,10,12,13]
//
//        if (components.month! == 2 && components.year! % 4 == 0) || (components.month! == 14 && components.year! % 4 == 0)
//        {
//            components.day = 29
//        }
//        else if components.month! == 2 || components.month! == 14
//        {
//            components.day = 28
//        }
//        else if arr.contains(components.month!)
//        {
//            components.day = 31
//        }
//        else
//        {
//            components.day = 30
//        }

        let d = cal.date(from: components)!
        return d
    }
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor?
    {
        if date < Date().addingTimeInterval(-24*60*60)
        {
            return UIColor.lightGray
        }
        else
        {
            return UIColor.black 
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {

        let dtFormatter = DateFormatter()
        dtFormatter.dateFormat = "yyyy-MM-dd"
        
        if dtFormatter.date(from:(dtFormatter.string(from: date)))! <  (dtFormatter.date(from:(dtFormatter.string(from: Date())))?.addingTimeInterval(-24*60*60))!
        {
           return false
        }
        else
        {
            if multiple == false
            {
                var tempArr = calendar.selectedDates
                
                for i in 0..<tempArr.count
                {
                    calendar.deselect(tempArr[i])
                }
                return true
            }
            return true
        }
    }
    
    func calendar(_ calendar: FSCalendar, cellFor date: Date, at position: FSCalendarMonthPosition) -> FSCalendarCell {
        let cell = calendar.dequeueReusableCell(withIdentifier: "cell", for: date, at: position)
        return cell
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition)
    {
        self.configure(cell: cell, for: date, at: position)
    }

    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        let df = DateFormatter()
        let df1 = DateFormatter()
        let df2 = DateFormatter()
        
        df1.dateFormat = "yyyy-MM-dd"
        df.dateFormat =  "yyyy-MM-dd HH:mm:ss.SSSZ"
        df2.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateOfCalendar = df1.string(from: date)
       
        //|| date > Calendar.current.date(byAdding: .month, value: 2, to: Date())!
        if date < Date().addingTimeInterval(-24*60*60)
        {
            return ""
        }
        else
        {
            if (dataDic.value(forKey: "fareArray") != nil) && (dataDic.value(forKey: "fareArray") as! NSArray).count > 0
            {
                for n in 0..<(dataDic.value(forKey: "fareArray") as! NSArray).count
                {
                    let d = ((dataDic.value(forKey: "fareArray") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "DepartureDate") as! String
                     let dateofData = (df1.string(from: df2.date(from: d)!))//df1.date(from: df2.string(from: df2.date(from: d)!))
                    
                    if dateOfCalendar == dateofData
                    {
                        let fare = ceil(Double("\(((dataDic.value(forKey: "fareArray") as! NSArray).object(at: n) as! NSDictionary).value(forKey: "Fare")!)")!)
                        return "\("\u{20B9}") \(Int(fare))"
                    }
                }
            }
             return ""
        }
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        calendar.appearance.subtitleSelectionColor = UIColor.lightGray
        if multiple == true{
            if self.dateCount == 2{
                var tempArr = calendar.selectedDates
                
                for i in 0..<tempArr.count-1
                {
                    calendar.deselect(tempArr[i])
                    
                }
                dateCount = 1
                dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
                dataDic.setValue(calendar.selectedDates[0], forKey: "end_date")
                NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
            }else{
                dateCount = dateCount + 1
                
                if dateCount == 1
                {
                    dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
                    NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
                }
                else if dateCount == 2
                {
                    
                    dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
                    if calendar.selectedDates.count > 1
                    {
                        dataDic.setValue(calendar.selectedDates[1], forKey: "end_date")
                    }
                    NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
                }
                
            }
        }else{
            var tempArr = calendar.selectedDates
            
            for i in 0..<tempArr.count-1
            {
                calendar.deselect(tempArr[i])
                
            }
            dateCount = 1
            if dateCount == 1
            {
                dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
                dataDic.setValue(calendar.selectedDates[0], forKey: "end_date")
                NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
            }

            
        }
            self.configureVisibleCells()
     }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date) {
       
        if multiple == true{

            var tempArr = calendar.selectedDates
            for i in 0..<calendar.selectedDates.count
            {
                calendar.deselect(tempArr[i])
            }
            calendar.select(date)
        dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
        dataDic.setValue(calendar.selectedDates[0], forKey: "end_date")
        NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
            dateCount = 1
        self.configureVisibleCells()
        }
    }
    
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        if multiple == true{
            if calendar.selectedDates.count == 1{
                dateCount = 1
                dataDic.setValue(calendar.selectedDates[0], forKey: "start_date")
                dataDic.setValue(calendar.selectedDates[0], forKey: "end_date")
                NotificationCenter.default.post(name: Notification.Name("dateSelected"), object: dataDic)
                return false
            }
        }
        
        self.configureVisibleCells()
        return true
    }
    // MARK: - Private functions
    
    private func configureVisibleCells(){
        
        var minimumDate:Date = calendar.minimumDate
        var maximumDate:Date = calendar.maximumDate
        
        if calendar.selectedDates.count == 1{
            
        }else{
            
            if calendar.selectedDates.count > 2{
                
                var tempArr = calendar.selectedDates
                
                for i in 2..<tempArr.count
                {
                    calendar.deselect(tempArr[i])
                }
            }
            
            minimumDate = calendar.selectedDates[0]
            maximumDate = calendar.selectedDates[calendar.selectedDates.count - 1]
            
            
            if calendar.selectedDates.count > 2{
                if minimumDate > calendar.selectedDates[calendar.selectedDates.count - 2]{
                    minimumDate = calendar.selectedDates[calendar.selectedDates.count - 2]
                }
                if maximumDate < calendar.selectedDates[calendar.selectedDates.count - 1]{
                    maximumDate = calendar.selectedDates[calendar.selectedDates.count - 1]
                }
            }
        }
        
        calendar.visibleCells().forEach { (cell) in
            let date = calendar.date(for: cell)
            let position = calendar.monthPosition(for: cell)
            
            let diyCell = (cell as! DIYCalendarCell)
            
                            diyCell.leftCA.isHidden = true
                            diyCell.rightCA.isHidden = true
            
            if position == .current {
                
                var selectionType = SelectionType.none
                
                if calendar.selectedDates.count > 0{
                    
                    if calendar.selectedDates.count == 1{
                        if date == calendar.selectedDates[0]{
                            selectionType = .single
                        }
                    }else{
                        
                        if minimumDate > maximumDate{
                            let temp = minimumDate
                            minimumDate = maximumDate
                            maximumDate = temp
                        }
                        if date == minimumDate{
                            selectionType = .leftBorder
                            diyCell.leftCA.isHidden = false

                            // calendar.select(date)
                            
                        }else if date == maximumDate{
                            selectionType = .rightBorder
                            diyCell.rightCA.isHidden = false

                            // calendar.select(date)
                            
                        }
                        else if date!>minimumDate && date!<maximumDate{
                            selectionType = .middle
                        }
                        
                    }
                }
                if selectionType == .none {
                    diyCell.selectionLayer.isHidden = true
                    diyCell.leftCA.isHidden = true
                    diyCell.rightCA.isHidden = true

                    return
                }
                diyCell.selectionLayer.isHidden = false
                diyCell.selectionType = selectionType
                
            }
            
        }
    }
    
    private func configure(cell: FSCalendarCell, for date: Date, at position: FSCalendarMonthPosition)
    {
        if (position == FSCalendarMonthPosition.previous)
        {
            return
        }
    
        let diyCell = (cell as! DIYCalendarCell)
        // Custom today circle
        diyCell.leftCA.isHidden = true
        diyCell.rightCA.isHidden = true
        
        if position == .current {
            
            var selectionType = SelectionType.none
            
            var minimumDate:Date = calendar.minimumDate
            var maximumDate:Date = calendar.maximumDate
            if calendar.selectedDates.count > 0{
                if calendar.selectedDates.count == 1{
                    if date as Date == calendar.selectedDates[0]{
                        selectionType = .single
                    }
                }else{
                    if calendar.selectedDates.count > 2{
                        if minimumDate > maximumDate{
                            let temp = minimumDate
                            minimumDate = maximumDate
                            maximumDate = temp
                        }
                        if date as Date == minimumDate{
                            selectionType = .leftBorder
                            diyCell.leftCA.isHidden = false
                            // calendar.select(date)
                            
                        }else if date as Date == maximumDate{
                            selectionType = .rightBorder
                            diyCell.rightCA.isHidden = false

                            // calendar.select(date)
                            
                        }else if (date as Date) > minimumDate && (date as Date) < maximumDate{
                            selectionType = .middle
                            self.calendar.select(date)
                        }
                    }else{
                        if date as Date == calendar.selectedDates[0]{
                            selectionType = .leftBorder
                            diyCell.leftCA.isHidden = false
                        }else if date as Date == calendar.selectedDates[1]{
                            selectionType = .rightBorder
                            diyCell.rightCA.isHidden = false
                        }else if (date as Date) > calendar.selectedDates[0] && (date as Date) < calendar.selectedDates[1]{
                            selectionType = .middle
                       }
                    }
                }
            }
            if selectionType == .none {
                diyCell.selectionLayer.isHidden = true
                diyCell.leftCA.isHidden = true
                diyCell.rightCA.isHidden = true
                return
            }
            diyCell.selectionLayer.isHidden = false
            diyCell.selectionType = selectionType
        }else{
           
            diyCell.selectionLayer.isHidden = true
            diyCell.leftCA.isHidden = true
            diyCell.rightCA.isHidden = true
        }
    }
    
}

