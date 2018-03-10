//
//  LoginViewController.swift
//  Tick8
//
//  Created by singsys on 31/7/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, listing, UIAlertViewDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgimgV: UIImageView!
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    var from:String = ""
    var countryBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        if self.view.frame.height >= 736
        {
            bgimgV.image = #imageLiteral(resourceName: "BG.png")
            
        }
        else if self.view.frame.height == 667
        {
            bgimgV.image = #imageLiteral(resourceName: "BG750.png")
            
        }
        else if self.view.frame.height == 568
        {
            bgimgV.image = #imageLiteral(resourceName: "BG640x1136.png")
            
        }
        else if self.view.frame.height == 480
        {
            bgimgV.image = #imageLiteral(resourceName: "BG640x960.png")
        }
        
        if dataDic.value(forKey: "country_code") == nil || dataDic.value(forKey: "country_code") as! String == ""
        {
            dataDic.setValue("91", forKey: "country_code")
        }
        self.tblView.reloadData()
    }
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        
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
    
    //MARK:- table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        
        if indexPath.row == 0
        {
            height = 180
        }
        else if indexPath.row == 1 || indexPath.row == 2
        {
            height = 75
        }
        else if indexPath.row == 3
        {
            height = 100
        }
        else
        {
            height = self.view.frame.height - 440
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "logoCell")!
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell")!
            
            let headlbl = cell.viewWithTag(1) as! UILabel
            let countryBtn = cell.viewWithTag(3) as! UIButton
            countryBtn.isHidden = false
            countryBtn.titleLabel?.adjustsFontSizeToFitWidth = true
            countryBtn.setTitle("+\(dataDic.value(forKey: "country_code")!)", for: .normal)
            //countryBtn.titleLabel?.text =
            for cons in countryBtn.constraints
            {
                if cons.identifier == "width"
                {
                    if countryBool == false
                    {
                        cons.constant = 0
                    }
                    else
                    {
                        cons.constant = countryBtn.intrinsicContentSize.width
                    }
                }
            }
            headlbl.text = "Email Id / Mobile Number"
            
           // let txtfld = cell.viewWithTag(2) as! UITextField
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell")!
            
            let headlbl = cell.viewWithTag(1) as! UILabel
            let countryBtn = cell.viewWithTag(3) as! UIButton
            countryBtn.isHidden = true
            for cons in countryBtn.constraints
            {
                if cons.identifier == "width"
                {
                    cons.constant = 0
                }
            }
            
            headlbl.text = "Password"
          //  let txtfld = cell.viewWithTag(2) as! UITextField
        }
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
            let lgn = cell.viewWithTag(1) as! UIButton
            lgn.layer.cornerRadius = 19
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "signUpCell")!
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        return cell
    }
    
    //MARK:- Textfield functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblView.addGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)

        if indexPath?.row == 1
        {
            textField.returnKeyType = .next
            textField.keyboardType = .emailAddress
            textField.isSecureTextEntry = false
        }
        else
        {
            textField.returnKeyType = .done
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.view.endEditing(true)
        tblView.removeGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.row == 1
        {
            dataDic.setValue(textField.text, forKey: "user_name")
        }
        else
        {
            dataDic.setValue(textField.text, forKey: "password")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let hit = textField.convert(CGPoint.zero, to: tblView)
        let indexPath = tblView.indexPathForRow(at: hit)
        let cell = tblView.cellForRow(at: indexPath!)
        
        if cell == nil
        {
            self.view.endEditing(true)
            return false
        }

        if indexPath?.row == 1
        {
            let ind = IndexPath(row: (indexPath?.row)!+1, section: (indexPath?.section)!)
            let cell1 = tblView.cellForRow(at: ind)
            let txt = cell1?.viewWithTag(2) as! UITextField
            txt.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
        let hit = textField.convert(CGPoint.zero, to: tblView)
        let indexPath = tblView.indexPathForRow(at: hit)
        let cell = tblView.cellForRow(at: indexPath!)
        let resultString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        
        if cell == nil
        {
            self.view.endEditing(true)
            return false
        }
        else if indexPath?.row == 1
        {
            let countryBtn = cell?.viewWithTag(3) as! UIButton
            
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            
            if (resultString == "")
            {
                for cons in countryBtn.constraints
                {
                    if cons.identifier == "width"
                    {
                        countryBool = false
                        cons.constant = 0
                    }
                }
            }
            else if Set(resultString.characters).isSubset(of: nums) == true
            {
                for cons in countryBtn.constraints
                {
                    if cons.identifier == "width"
                    {
                        countryBool = true
                        cons.constant = countryBtn.intrinsicContentSize.width
                    }
                }
            }
            else
            {
                for cons in countryBtn.constraints
                {
                    if cons.identifier == "width"
                    {
                        countryBool = false
                        cons.constant = 0
                    }
                }
            }
        }
        else if indexPath?.row == 2
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 20
        }

        return true
    }
    //MARK:- button handling
    
    func list(value1: String, value2: String) {
        
        dataDic.setValue(value1, forKey: "country_code")
        self.tblView.reloadData()
    }
    
    @IBAction func countryCodeBtn(_ sender: UIButton)
    {
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        thirdView.delegate = self
        thirdView.from = "country"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    @IBAction func forgotBtn(_ sender: UIButton) {
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
        thirdView.from = "forgot"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    @IBAction func loginBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
       // Set((dataDic.value(forKey: "user_name") as! String).characters).isSubset(of: nums) == false
        if (dataDic.value(forKey: "user_name") == nil || (dataDic.value(forKey: "user_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "" )
        {
            supportingfuction.showMessageHudWithMessage(message: enterEmailMob, delay: 2.0)
            return
        }
        else
        {
            if Set((dataDic.value(forKey: "user_name") as! String).characters).isSubset(of: nums) == false
            {
                if CommonValidations.isValidEmail(testStr: dataDic.value(forKey: "user_name") as! String) == false
                {
                    supportingfuction.showMessageHudWithMessage(message: validEmail, delay: 2.0)
                    return
                }
            }
            else
            {
                if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "user_name") as! String, min: 8, max: 14) == false
                {
                    supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
                    return
                }
            }
        }
        if (dataDic.value(forKey: "password") == nil || (dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == "" )
        {
            supportingfuction.showMessageHudWithMessage(message: enterPassword, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "password") as! String, min: 8, max: 20) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validLoginPassword, delay: 2.0)
            return
        }
        
        loginWebservice()
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
        if from == "register"
        {
            from = ""
           _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            thirdView.from = "login"
            self.navigationController?.pushViewController(thirdView, animated: true)
        }
    }
    
    @IBAction func closeBtn(_ sender: UIButton)
    {
        for i in (self.navigationController?.viewControllers)!
        {
            if i.restorationIdentifier == "HomeViewController"
            {
                self.navigationController?.popToViewController(i, animated: true)
                return
            }
        }
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        let v = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
        let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
        con.restorationIdentifier = "HomeViewController"
        self.navigationController?.viewControllers = [con]

    }
    
    
    func loginWebservice()
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
                
                dataDic.setValue("ios", forKey: "device_type")
                if UserDefaults.standard.value(forKey: "device_token") != nil
                {
                     dataDic.setValue(UserDefaults.standard.value(forKey: "device_token") as! String, forKey: "device_token")
                }
                else
                {
                     dataDic.setValue("", forKey: "device_token")
                }
                dataDic.setValue(UIDevice.current.identifierForVendor!.uuidString, forKey: "device_id")
               
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/dologin"), parameters: dataDic, constructingBodyWith: nil, progress: nil, success:
                    {
                        requestOperation, response  in
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                var dic = NSMutableDictionary()
                                
                                if UserDefaults.standard.value(forKey: "user") != nil
                                {
                                    UserDefaults.standard.removeObject(forKey: "user")
                                }
                                
                                dic = (dataFromServer.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                
                                for key in dic.allKeys
                                {
                                    if dic.object(forKey: key) is NSNull
                                    {
                                        dic.setValue("", forKey: key as! String)
                                    }
                                }
                                
                                UserDefaults.standard.setValue(dic , forKey: "userData")
                                supportingfuction.hideProgressHudInView(view: self.view)
                                for i in (self.navigationController?.viewControllers)!
                                {
                                    if i.restorationIdentifier == "HomeViewController"
                                    {
                                        self.navigationController?.popToViewController(i, animated: true)
                                        return
                                    }
                                }
                                
                                //if controller is not in navigation array
                                let viewController = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                                let v = self.storyboard?.instantiateViewController(withIdentifier: "LeftMenuViewController") as! LeftMenuViewController
                                let con = SSASideMenu(contentViewController: viewController, leftMenuViewController: v)
                                con.restorationIdentifier = "HomeViewController"
                                self.navigationController?.viewControllers = [con]
                            }
                                else if ((dataFromServer.value(forKey: "action") != nil) && !(dataFromServer.value(forKey: "action") is NSNull) && dataFromServer.value(forKey: "action") as! String == "resend_otp")
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
                                vc.from = "otpVerify"
                                vc.dataDic.setValue(self.dataDic.value(forKey: "user_name"), forKey: "mobile_no")
                                vc.dataDic.setValue(self.dataDic.value(forKey: "country_code"), forKey: "country_code")
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                                else if ((dataFromServer.value(forKey: "action") != nil) && !(dataFromServer.value(forKey: "action") is NSNull) && (dataFromServer.value(forKey: "action") as! String == "verify"))
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                let action = UIAlertController(title: "Tick8", message: "Your account is still not activated. Click resend to get activation mail.", preferredStyle: .alert)
                                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                                let ok = UIAlertAction(title: "Resend", style: .default, handler: { (alert) in
                                    self.resendEmailVerification()
                                })
                                action.addAction(ok)
                                action.addAction(cancel)
                                self.present(action, animated: true, completion: nil)

                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
               //     print(error)
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
               params.setValue(dataDic.value(forKey: "user_name"), forKey: "email")
                
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
                                supportingfuction.hideProgressHudInView(view: self.view)
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                            else
                            {
                                supportingfuction.hideProgressHudInView(view: self.view)
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
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
}
