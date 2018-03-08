//
//  ListingViewController.swift
//  Tick8
//
//  Created by singsys on 2/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit
protocol listing {
    func list(value1:String, value2:String)
}

protocol cityListing {
    func cityList(value1: NSDictionary, value2: String)
}
class ListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var noRecordLbl: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var headerView: UILabel!
    @IBOutlet weak var tblview: UITableView!
    
    var searchActive = false
    var delegate:listing!
    var cityDelegate:cityListing!
    var from = ""
    var dataDic = NSMutableDictionary()
    var searchCode = NSMutableArray()
    var paging:Int = 1
    var departOrArrive = ""
     var refreshControl: UIRefreshControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(ListingViewController.setDefault), for: UIControlEvents.valueChanged)
        refreshControl.layer.zPosition = -1
        tblview.addSubview(refreshControl)
        
        
        
        //to remove the clear button
        let textField: UITextField? = (searchBar.value(forKey: "_searchField") as? UITextField)
        textField?.clearButtonMode = .never
        noRecordLbl.isHidden = true
        searchBar.delegate = self
        searchBar.showsCancelButton = false
       setDefault()
        
        // Do any additional setup after loading the view.
    }
    
    func setDefault()
    {
        self.paging = 1
        if from == "country"
        {
            headerView.text = "Country Codes"
            listingWebservice()
        }
        else if from.range(of: "cityListing") != nil
        {
            headerView.text = "Select City"
            cityListWebservice(key: "")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- table view functions
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if from.range(of: "cityListing") != nil
        {
            if  (tblview.contentOffset.y >= (tblview.contentSize.height - tblview.frame.size.height)) && (dataDic.value(forKey: "next_page_url") != nil && "\(dataDic.value(forKey: "next_page_url")!)" != "<null>")
            {
                //user has scrolled to the bottom
                paging += 1
                cityListWebservice(key: searchBar.text!)
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var num:Int = 0
        
        if dataDic.value(forKey: "array") != nil && dataDic.value(forKey: "array") is NSArray && (dataDic.value(forKey: "array") as! NSArray).count > 0
        {
            if searchActive == false
            {
                num = (dataDic.value(forKey: "array") as! NSArray).count
                self.noRecordLbl.isHidden = true
            }
            else
            {
                if searchCode.count == 0
                {
                    self.noRecordLbl.isHidden = false
                }
                else
                {
                    self.noRecordLbl.isHidden = true
                    num = searchCode.count
                }
            }
        }
        
        return num
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        
        if from == "country"
        {
            height = 50
        }
        else if from.range(of: "cityListing") != nil
        {
            height = 70
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        var lbl = UILabel()
        var lbl1 = UILabel()
        
        if from == "country"
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
            lbl = cell.viewWithTag(1) as! UILabel
        }
        else if from.range(of: "cityListing") != nil
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "cityCell")!
            lbl = cell.viewWithTag(1) as! UILabel
            lbl1 = cell.viewWithTag(2) as! UILabel
        }
        
        
        
        if searchActive == false
        {
            let dic = (dataDic.value(forKey: "array") as! NSArray).object(at: indexPath.row) as! NSDictionary
            if from == "country"
            {
                lbl.text = "\(dic.value(forKey: "calling_code")!)  \(dic.value(forKey: "country_name")!)"
            }
            else if from.range(of: "cityListing") != nil
            {
                lbl.text = "\(dic.value(forKey: "city_name")!), \(dic.value(forKey: "country_name")!)"
                lbl1.text = "\(dic.value(forKey: "city_code")!), \(dic.value(forKey: "airport_name")!)"
            }
        }
        else
        {
            let dic = searchCode.object(at: indexPath.row) as! NSDictionary
            
            if from == "country"
            {
                lbl.text = "\(dic.value(forKey: "calling_code")!)  \(dic.value(forKey: "country_name")!)"
            }
            else if from.range(of: "cityListing") != nil
            {
                lbl.text = "\(dic.value(forKey: "city_name")!), \(dic.value(forKey: "country_name")!)"
                lbl1.text = "\(dic.value(forKey: "city_code")!), \(dic.value(forKey: "airport_name")!)"
            }
            
        }
        
        lbl.adjustsFontSizeToFitWidth = true
        lbl1.adjustsFontSizeToFitWidth = true
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if from == "country" && searchActive == false
        {
            _ = self.navigationController?.popViewController(animated: true)
            
            delegate.list(value1: (((dataDic.value(forKey: "array") as! NSArray).object(at: indexPath.row) as! NSDictionary).value(forKey: "calling_code")) as! String, value2: "country")
        }
        else if from == "country" && searchActive == true
        {
            _ = self.navigationController?.popViewController(animated: true)
            
            delegate.list(value1: ((searchCode.object(at: indexPath.row) as! NSDictionary).value(forKey: "calling_code")) as! String, value2: "country")
        }
        else if from.range(of: "cityListing") != nil
        {
            if self.from == "cityListing1"
            {
                self.cityDelegate.cityList(value1: ((self.dataDic.value(forKey: "array") as! NSArray).object(at: indexPath.row) as! NSDictionary), value2: "origin")
            }
            else if self.from == "cityListing2"
            {
                self.cityDelegate.cityList(value1: ((self.dataDic.value(forKey: "array") as! NSArray).object(at: indexPath.row) as! NSDictionary), value2: "destination")
            }
            _ = self.dismiss(animated: true, completion: nil)//{
           // void in
            
       // }
            
            return
        }
        
    }
    
    
    //MARK:- search bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCode.removeAllObjects()
        searchBar.showsCancelButton = true
        
        if from == "country"
        {
            let searchPredicate = NSPredicate(format: " %K contains[cd] %@ ","country_name",searchText)
            let tempSearchCategory : NSArray = (dataDic.value(forKey: "array") as! NSArray).filtered(using: searchPredicate) as NSArray
            
            searchCode.addObjects(from: tempSearchCategory as [AnyObject])
            
            if(searchCode.count == 0)
            {
                if(searchText.isEmpty)
                {
                    
                    searchActive = false;
                }
                else
                {
                    searchActive = true;
                }
            } else
            {
                searchActive = true;
            }
            
            self.tblview.reloadData()
        }
        else if from.range(of: "cityListing") != nil
        {
            paging = 1
            cityListWebservice(key: searchText)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchActive = false;
        searchCode.removeAllObjects()
        
        if from.range(of: "cityListing") != nil
        {
            paging = 1
            cityListWebservice(key: "")
        }
        else
        {
            self.tblview.reloadData()
        }
        
    }
    
    
    //MARK:- button handling
    @IBAction func backBtn(_ sender: UIButton) {
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController
        {
            _ = self.dismiss(animated: true, completion: nil)
        }
        else
        {
            _ = navigationController?.popViewController(animated: true)
        }
    }
    
    func cityListWebservice(key:String)
    {
         self.refreshControl.endRefreshing()
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
                params.setValue("\(paging)", forKey: "page")
                params.setValue(key, forKey: "search_key")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/getairports"), parameters: params, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                if dataFromServer.value(forKey: "data") != nil && dataFromServer.value(forKey: "data") is NSDictionary && (dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "data") != nil && (dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "data") is NSArray && ((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "data") as! NSArray).count > 0
                                {
                                    if self.paging == 1
                                    {
                                        self.dataDic.setValue(((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "data") as! NSArray), forKey: "array")
                                        self.dataDic.setValue("\((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "next_page_url")!)", forKey: "next_page_url")
                                    }
                                    else if self.paging > 1
                                    {
                                        let array:NSMutableArray = (self.dataDic.value(forKey: "array") as! NSArray).mutableCopy() as! NSMutableArray
                                        
                                        array.addObjects(from: ((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "data") as! NSArray) as! [Any])
                                        self.dataDic.setValue("\((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: "next_page_url")!)", forKey: "next_page_url")
                                        self.dataDic.setValue(array, forKey: "array")
                                    }
                                    self.noRecordLbl.isHidden = true
                                    self.tblview.isHidden = false
                                    self.tblview.reloadData()
                                }
                                else
                                {
                                    self.noRecordLbl.isHidden = false
                                }
                            }
                            else
                            {
                                if dataFromServer.value(forKey: "data") == nil
                                {
                                    self.noRecordLbl.isHidden = false
                                    self.tblview.isHidden = true
                                }
                            }
                        }
                }, failure: {
                    requestOperation, error in
            //        print(error)
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
    
    func listingWebservice()
    {
        self.refreshControl.endRefreshing()
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
                var web = ""
                
                if from == "country"
                {
                    web = "api/getcountries"
                }
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.get((BASE_URL + web), parameters: nil, progress: nil, success:
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
                                    self.dataDic.setValue(dataFromServer.value(forKey: "data") as! NSArray, forKey: "array")
                                    self.noRecordLbl.isHidden = true
                                    self.tblview.reloadData()
                                }
                                else
                                {
                                    self.noRecordLbl.isHidden = false
                                }
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
             //       print(error)
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
    
}
