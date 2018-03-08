//
//  LeftMenuViewController.swift
//  SSASideMenuExample
// home view
//  Created by Sebastian Andersen on 20/10/14.
//  Copyright (c) 2015 Sebastian Andersen. All rights reserved.
//

import Foundation
import UIKit

class LeftMenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(LeftMenuViewController.viewWillAppear(_:)), name: NSNotification.Name(rawValue: "profileChaged"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.value(forKey: "userData") == nil
        {
            return 9
        }
        else
        {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 0
        {
            return 150
        }
        else
        {
            if UserDefaults.standard.value(forKey: "userData") != nil && indexPath.row == 9
            {
                return 55
            }
            else
            {
                return 40
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1)
        cell.selectionStyle = .none
        
        if UserDefaults.standard.value(forKey: "userData") == nil
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "loginCell")!
            }
            else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
                let imgView = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                let img = cell.viewWithTag(3) as! UIImageView
                
                imgView.isHidden = true
                label.isHidden = true
                img.isHidden = false
                
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
                let imgView = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                let img = cell.viewWithTag(3) as! UIImageView
                
                if indexPath.row == 8
                {
                    imgView.isHidden = true
                    label.isHidden = true
                    img.isHidden = false
                }
                else
                {
                    imgView.isHidden = false
                    label.isHidden = false
                    img.isHidden = true
                    let arr = ["Search Flights", "My Profile", "My Transaction History", "About Us", "Contact Us", "Privacy Policy"]
                    let image = ["search","profile","history","about","contact","privacy"]
                    label.text = arr[indexPath.row-2]
                    imgView.image = UIImage(named: image[indexPath.row-2])
                }
            }
        }
        else
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
                let imgView = cell.viewWithTag(1) as! UIImageView
                imgView.layer.borderColor = UIColor.white.cgColor
                imgView.layer.borderWidth = 2
                imgView.layer.cornerRadius = imgView.frame.width/2
                imgView.image = #imageLiteral(resourceName: "default_profile")
                
                if ((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") != nil && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") is String && (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo") as! String != "")
                {
                    imgView.setImageWith(URL(string: "\(BASE_URL)\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "profile_photo")!)")!, placeholderImage: #imageLiteral(resourceName: "default_profile"))
                }
                else
                {
                    imgView.image = #imageLiteral(resourceName: "default_profile")
                }
                
                
                let namelbl = cell.viewWithTag(2) as! UILabel
                let emailbl = cell.viewWithTag(3) as! UILabel
                
                if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name") != nil && ((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name") != nil)
                {
                    namelbl.text = "\(((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name"))!) \(((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name"))!)"
                }
                
                if (UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email") != nil
                {
                    emailbl.text = "\(((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email"))!)"
                }
                
            }
            else if indexPath.row == 1
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
                let imgView = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                let img = cell.viewWithTag(3) as! UIImageView
                
                imgView.isHidden = true
                label.isHidden = true
                img.isHidden = false
                
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "labelCell")!
                let imgView = cell.viewWithTag(1) as! UIImageView
                let label = cell.viewWithTag(2) as! UILabel
                let img = cell.viewWithTag(3) as! UIImageView
                imgView.isHidden = false
                label.isHidden = false
                img.isHidden = true
                
                if indexPath.row == 8
                {
                    imgView.isHidden = true
                    label.isHidden = true
                    img.isHidden = false
                }
                
                let arr = ["Search Flights", "My Profile", "My Transaction History", "About Us", "Contact Us", "Privacy Policy","","Logout"]
                let image = ["search","profile","history","about","contact","privacy","","logout"]
                label.text = arr[indexPath.row-2]
                label.adjustsFontSizeToFitWidth = true
                imgView.image = UIImage(named: image[indexPath.row-2])
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuViewController?.hideMenuViewController()
        
        if  UserDefaults.standard.value(forKey: "userData") == nil && (indexPath.row == 3)
        {
            supportingfuction.showMessageHudWithMessage(message: "Please login first to view details.", delay: 2.0)
            let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(thirdView, animated: true)
            return
        }
        else if UserDefaults.standard.value(forKey: "userData") == nil && UserDefaults.standard.value(forKey: "user") == nil && (indexPath.row == 4)
        {
            supportingfuction.showMessageHudWithMessage(message: "Please login first to view details.", delay: 2.0)
            let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.pushViewController(thirdView, animated: true)
            return
        }
        else
            if UserDefaults.standard.value(forKey: "userData") != nil && indexPath.row == 9
            {
                
                let action = UIAlertController(title: "Do you want to Logout?", message: "", preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let ok = UIAlertAction(title: "Log Out", style: .default, handler: { (alert) in
                    self.logoutWebservice()
                })
                action.addAction(ok)
                action.addAction(cancel)
                self.present(action, animated: true, completion: nil)
            }
            else if indexPath.row == 3
            {
                let second = self.storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
                let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                let container = SSASideMenu(contentViewController: second, leftMenuViewController: thirdView)
                container.restorationIdentifier = "MyProfileViewController"
                self.navigationController?.pushViewController(container, animated: true)
            }
            else if indexPath.row == 2
            {
                
                for vc in (self.navigationController?.viewControllers)!
                {
                    if vc.restorationIdentifier == "HomeViewController"
                    {
                        _ = self.navigationController?.popToViewController(vc, animated: true)
                        return
                    }
                }
                
                if (sideMenuViewController?.restorationIdentifier != "HomeViewController")
                {
                    sideMenuViewController?.contentViewController = UINavigationController(rootViewController: storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController)
                    sideMenuViewController?.contentViewController?.restorationIdentifier = "HomeViewController"
                    sideMenuViewController?.hideMenuViewController()
                }
            }
            else if indexPath.row == 4
            {
                let story = UIStoryboard(name: "Main2", bundle: nil)
                let second = story.instantiateViewController(withIdentifier: "TransactionViewController") as! TransactionViewController
                let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                let container = SSASideMenu(contentViewController: second, leftMenuViewController: thirdView)
                container.restorationIdentifier = "TransactionViewController"
                self.navigationController?.pushViewController(container, animated: true)
            }
            else if indexPath.row == 5 || indexPath.row == 7
            {
                
                let second = self.storyboard?.instantiateViewController(withIdentifier: "StaticContentViewController") as! StaticContentViewController
                
                if indexPath.row == 5
                {
                    second.headerString = "About Us"
                }
                else
                {
                    second.headerString = "Privacy Policy"
                }
                let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                let container = SSASideMenu(contentViewController: second, leftMenuViewController: thirdView)
                self.navigationController?.pushViewController(container, animated: true)
            }
            else if indexPath.row == 6
            {
                let second = self.storyboard?.instantiateViewController(withIdentifier: "ContactUsViewController") as! ContactUsViewController
                let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                let container = SSASideMenu(contentViewController: second, leftMenuViewController: thirdView)
                self.navigationController?.pushViewController(container, animated: true)
            }
    }
    
    
    func logoutWebservice()
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
                params.setValue(((UserDefaults.standard.value(forKey: "userData") as! NSMutableDictionary).value(forKey: "token") as! NSDictionary).value(forKey: "id") as! String, forKey: "token_id")
                
                //dataDic.setValue("+91", forKey: "country_code")
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/logout"), parameters: params, constructingBodyWith: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                               
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
                                    // Put your code which should be executed with a delay here
                                     supportingfuction.showMessageHudWithMessage(message: "You have been logout successfuly.", delay: 2.0)
                                })

                                UserDefaults.standard.removeObject(forKey: "userData")
                                
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                let v = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                                let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
                                con.restorationIdentifier = "HomeViewController"
                                self.navigationController?.viewControllers = [con]
                                
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
    
    
    //MARK:- button handling
    
    @IBAction func registerBtn(_ sender: UIButton) {
        sideMenuViewController?.hideMenuViewController()
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        sideMenuViewController?.hideMenuViewController()
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
}
