//
//  MyProfileViewController.swift
//  Tick8
//
//  Created by singsys on 7/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate {

    @IBOutlet weak var bgImage: UIImageView!
    @IBOutlet weak var tblView: UITableView!
    
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(MyProfileViewController.viewWillAppear), for: UIControlEvents.valueChanged)
        refreshControl.layer.zPosition = -1
        tblView.addSubview(refreshControl) // not required when using UITableViewController
        
        tblView.isUserInteractionEnabled = true
        tblView.bounces = true
        tblView.alwaysBounceVertical = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any ources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.view.frame.height >= 736
        {
            bgImage.image = #imageLiteral(resourceName: "BG.png")
        }
        else if self.view.frame.height == 667
        {
            bgImage.image = #imageLiteral(resourceName: "BG750.png")
        }
        else if self.view.frame.height == 568
        {
            bgImage.image = #imageLiteral(resourceName: "BG640x1136.png")
        }
        else if self.view.frame.height == 480
        {
            bgImage.image = #imageLiteral(resourceName: "BG640x960.png")
        }
        
        getprofileWebservice()
        tblView.isHidden = true
//        self.tblView.reloadData()
    }
    
    
    //MARK:- table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = CGFloat()
        
        if indexPath.row == 0
        {
            height = 170
        }
        else  if indexPath.row == 1
        {
            height = 73
        }
        else  if indexPath.row == 2 || indexPath.row == 3
        {
            height = 60
        }
        else  if indexPath.row == 4
        {
            height = 100
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            let img = cell.viewWithTag(1) as! UIImageView
            img.layer.cornerRadius = img.frame.width/2
            img.layer.borderWidth = 3
            img.layer.borderColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
            
            if ((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") as! String != "")
            {
                img.setImageWith(URL(string: "\(BASE_URL)\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo")!)")!, placeholderImage: #imageLiteral(resourceName: "default_profile"))
            }
            else
            {
                img.image = #imageLiteral(resourceName: "default_profile")
            }

            let editBtn = cell.viewWithTag(2) as! UIButton
            editBtn.layer.cornerRadius = 18
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            let fname = cell.viewWithTag(1) as! UILabel
            let lname = cell.viewWithTag(2) as! UILabel
            
            if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name") as! String != ""
            {
                fname.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name") as? String
            }
            
            if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name") as! String != ""
            {
                lname.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name") as? String
            }
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "passwordCell")!
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
            let head = cell.viewWithTag(1) as! UILabel
            let txtLbl = cell.viewWithTag(2) as! UILabel
            let verifyBtn = cell.viewWithTag(3) as! UIButton
            verifyBtn.isHidden = false
            verifyBtn.isHidden = false
            
            if indexPath.row == 2
            {
                head.text = "Mobile Number"
                if((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") as! String != "") && ((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code") as! String != "")
                {
                    txtLbl.text = "+\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code")!) \((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no")!)"
                }
                else if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") as! String != ""
                {
                    txtLbl.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no") as? String
                }
                
                if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "otp_verify") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "otp_verify") is String
                {
                    if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "otp_verify") as! String == "Y"
                    {
                        verifyBtn.setImage(#imageLiteral(resourceName: "verified"), for: .selected)
                        verifyBtn.isSelected = true
                    }
                    else if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "otp_verify") as! String == "N"
                    {
                        verifyBtn.setImage(#imageLiteral(resourceName: "nonverified"), for: .normal)
                        verifyBtn.isSelected = false
                    }
                    
                    verifyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                }
                else
                {
                    verifyBtn.isHidden = true
                    verifyBtn.isHidden = true
                }
                
            }
            else
            {
                head.text = "Email Id"
                if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as! String != ""
                {
                    txtLbl.text = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as? String
                }
                
                if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email_verify") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email_verify") is String
                {
                    if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email_verify") as! String == "Y"
                    {
                        verifyBtn.setImage(#imageLiteral(resourceName: "verified"), for: .selected)
                        verifyBtn.isSelected = true
                    }
                    else if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email_verify") as! String == "N"
                    {
                        verifyBtn.setImage(#imageLiteral(resourceName: "nonverified"), for: .normal)
                        verifyBtn.isSelected = false
                    }
                    
                    verifyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                }
                else
                {
                    verifyBtn.isHidden = true
                    verifyBtn.isHidden = true
                }
            }
        }
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    
    @IBAction func sideMenuBtn(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    @IBAction func verifyBtn(_ sender: UIButton) {
        
        let hit = sender.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        if sender.isSelected == true
        {
        }
        else
        {
            if indexPath!.row == 2
            {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
                vc.from = "otpMyProfile"
                vc.dataDic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no"), forKey: "mobile_no")
                vc.dataDic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code"), forKey: "country_code")
                _ = self.navigationController?.pushViewController(vc, animated: true)
            }
            else
            {
                let action = UIAlertController(title: "", message: "Your account is still not activated. Click resend to get activation mail.", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let ok = UIAlertAction(title: "Resend", style: .default, handler: { (alert) in
                    self.resendEmailVerification()
                })
                action.addAction(ok)
                action.addAction(cancel)
                self.present(action, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func changePassword(_ sender: UIButton) {
        let third = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
        third.from = ""
        self.navigationController?.pushViewController(third, animated: true)

    }
    
    @IBAction func editprofile(_ sender: UIButton) {
        
        let third = self.storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        third.dataDic = (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).mutableCopy() as! NSMutableDictionary
        self.navigationController?.pushViewController(third, animated: true)
    }
    
    
    //MARK:- webservices
    func getprofileWebservice()
    {
        
        
        self.refreshControl.endRefreshing()
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                
                manager.get(("\(BASE_URL)api/user/getprofile"), parameters: nil, progress: nil, success:
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
                                dic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken") as! String, forKey: "accessToken")
                                dic.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "token") as! NSDictionary, forKey: "token")
                                
                                for key in (dataFromServer.value(forKey: "data") as! NSDictionary).allKeys
                                {
                                    if (dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: key as! String)! is NSNull
                                    {
                                        dic.setValue("", forKey: key as! String)
                                    }
                                    else
                                    {
                                        dic.setValue((dataFromServer.value(forKey: "data") as! NSDictionary).value(forKey: key as! String)!, forKey: key as! String)
                                    }
                                }
                                UserDefaults.standard.setValue(dic as NSDictionary, forKey: "userData")
                                self.tblView.isHidden = false
                                self.tblView.reloadData()
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
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
                            let vc = self.storyboard?.instantiateViewController(withIdentifier:  "LoginViewController") as! LoginViewController
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
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
    
    func resendEmailVerification()
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
                params.setValue((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") as! String, forKey: "email")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                
                manager.post((BASE_URL + "api/resendemailactivator"), parameters: params, constructingBodyWith: nil, progress: nil, success:
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
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                  //  print(error)
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
