//
//  ForgotPassViewController.swift
//  Tick8
//
//  Created by singsys on 1/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class ForgotPassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,listing {
    
    // var email:String = ""
    var tapGesture = UITapGestureRecognizer()
    var from = ""
    var num:String = ""
    var dataDic = NSMutableDictionary()
    var countryBool = false
    // var mob:String = ""
    @IBOutlet weak var backArrow: UIButton!
    
    @IBOutlet weak var tblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ForgotPassViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ForgotPassViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        if from != "forgot"
        {
            backArrow.isHidden = false
        }
        else
        {
            backArrow.isHidden = true
        }
        
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
        if from == "otpVerify" || from == "otpMyProfile" || from == "otpProfile"
        {
            resendCode()
        }
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK:- table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        
        if indexPath.row == 0
        {
            height = 190
        }
        else if indexPath.row == 1
        {
            if from == "forgot"
            {
                height = 205
            }
            else
            {
                height = 225
            }
        }
        else
        {
            if from == "forgot"
            {
                height = self.view.frame.height - 455
            }
            else
            {
                height = self.view.frame.height - 450
            }
            
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            let img = cell.viewWithTag(1) as! UIImageView
            
            if from == "forgot"
            {
                img.image = #imageLiteral(resourceName: "forgot")
            }
            else if from == "otp" || from == "otpPass" || from == "otpVerify" || from == "otpProfile" || from == "otpMyProfile"
            {
                img.image = #imageLiteral(resourceName: "otp")
            }
        }
        else if indexPath.row == 1
        {
            if from == "forgot"
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "fieldCell")!
                let fld = cell.viewWithTag(2) as! UITextField
                let countryBtn = cell.viewWithTag(5) as! UIButton
                countryBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                countryBtn.setTitle("+\(dataDic.value(forKey: "country_code")!)", for: .normal)
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
                
                if dataDic.value(forKey: "user_name") != nil
                {
                    fld.text = dataDic.value(forKey: "user_name") as? String
                }
                else
                {
                    fld.text = ""
                }
                let btn = cell.viewWithTag(3) as! UIButton
                btn.layer.cornerRadius = 19
                btn.setTitle("SUBMIT", for: .normal)
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "fieldOTPCell")!
                let mob = cell.viewWithTag(1) as! UITextField
                let code = cell.viewWithTag(11) as! UIButton
                let editbtn = cell.viewWithTag(12) as! UIButton
                let lbl = cell.viewWithTag(13) as! UILabel
                lbl.adjustsFontSizeToFitWidth = true
                mob.isEnabled = false
                
                if dataDic.value(forKey: "country_code") != nil && dataDic.value(forKey: "country_code") is String && dataDic.value(forKey: "country_code") as! String != ""
                {
                    code.setTitle("+\(dataDic.value(forKey: "country_code")!)", for: .normal)
                    code.titleLabel?.adjustsFontSizeToFitWidth = true
                }
                else
                {
                    code.setTitle("+00", for: .normal)
                }
                
                if dataDic.value(forKey: "mobile_no") != nil && dataDic.value(forKey: "mobile_no") is String && dataDic.value(forKey: "mobile_no") as! String != ""
                {
                    mob.text = dataDic.value(forKey: "mobile_no") as? String
                }
                
                
                if from == "otpPass" || from == "otpVerify" || from == "otpProfile" || from == "otpMyProfile"
                {
                    for cons in code.constraints
                    {
                        if cons.identifier == "width"
                        {
                            cons.constant = 0
                        }
                    }
                    code.isHidden = true
                    editbtn.isHidden = true
                }
                else
                {
                    for cons in code.constraints
                    {
                        if cons.identifier == "width"
                        {
                            cons.constant = code.intrinsicContentSize.width
                        }
                    }
                    
                    code.isHidden = false
                    editbtn.isHidden = false
                }
                
                let txt1 = cell.viewWithTag(2) as! UITextField
                let txt2 = cell.viewWithTag(3) as! UITextField
                let txt3 = cell.viewWithTag(4) as! UITextField
                let txt4 = cell.viewWithTag(5) as! UITextField
                
                txt1.isUserInteractionEnabled = true
                txt2.isUserInteractionEnabled = false
                txt3.isUserInteractionEnabled = false
                txt4.isUserInteractionEnabled  = false
                
                let sbmit = cell.viewWithTag(6) as! UIButton
                sbmit.layer.cornerRadius = 19
                sbmit.setTitle("SUBMIT", for: .normal)
            }
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "bottomCell")!
            let label = cell.viewWithTag(1) as! UILabel
            let btn = cell.viewWithTag(2) as! UIButton
            
            if from == "forgot"
            {
                label.text = "Back to"
                btn.setTitle("Login", for: .normal)
            }
            else
            {
                label.text = "Didn't receive the OTP?"
                btn.setTitle("Resend Code", for: .normal)
            }
        }
        
        return cell
    }
    
    //MARK:- textfield functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if from == "forgot"
        {
            self.view.endEditing(true)
        }
        else
        {
            if textField.tag == 1
            {
                self.view.endEditing(true)
            }
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblView.addGestureRecognizer(tapGesture)
        
        if from == "forgot"
        {
            textField.returnKeyType = .done
            textField.keyboardType = .emailAddress
        }
        else
        {
            textField.keyboardType = .numberPad
            doneKeyboard(textField: textField, width: self.view.frame.width, height: self.view.frame.height)
            if textField.tag == 1
            {
                textField.isSecureTextEntry = false
                textField.returnKeyType = .done
            }
            else
            {
                textField.isSecureTextEntry = true
                textField.returnKeyType = .next
            }
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.removeGestureRecognizer(tapGesture)
        if from == "forgot"
        {
            dataDic.setValue(textField.text!, forKey: "user_name")
        }
        else
        {
            if textField.tag == 1
            {
                
                if CommonValidations.numberLimit(testStr: textField.text!, min: 8, max: 14) == false
                {
                    supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
                }
                
                if dataDic.value(forKey: "mobile_no") != nil && (dataDic.value(forKey: "mobile_no") as! String) == textField.text
                {
                    dataDic.setValue(textField.text, forKey: "mobile_no")
                }
                else
                {
                    dataDic.setValue(dataDic.value(forKey: "mobile_no") as! String, forKey: "old_mobile_no")
                    dataDic.setValue(textField.text!, forKey: "mobile_no")
                }
                
                
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if from != "forgot"
        {
            
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if !(string == numberFiltered)
            {
                return false
            }
            
            if textField.tag == 1
            {
                let currentCharacterCount = textField.text?.characters.count ?? 0
                if (range.length + range.location > currentCharacterCount){
                    return false
                }
                let newLength = currentCharacterCount + string.characters.count - range.length
                return newLength <= 14
            }
            
            
            let index = IndexPath(row: 1, section: 0)
            let cell = tblView.cellForRow(at: index)
            
            let txtField1 = cell?.viewWithTag(2) as! UITextField
            let txtField2 = cell?.viewWithTag(3) as! UITextField
            let txtField3 = cell?.viewWithTag(4) as! UITextField
            let txtField4 = cell?.viewWithTag(5) as! UITextField
            
            
            if string.characters.count == 1 {
                if textField == txtField1 {
                    txtField2.isUserInteractionEnabled = true
                    txtField3.isUserInteractionEnabled = false
                    txtField4.isUserInteractionEnabled = false
                    txtField2.text = "\u{200B}"
                    txtField1.text = string
                    //   txtField1.resignFirstResponder()
                    txtField2.becomeFirstResponder()
                    return false;
                }
                else if (textField == txtField2) {
                    txtField3.isUserInteractionEnabled = true
                    txtField1.isUserInteractionEnabled = false
                    txtField4.isUserInteractionEnabled = false
                    txtField3.text = "\u{200B}"
                    txtField3.becomeFirstResponder()
                    txtField2.text = string
                    return false;
                }
                else if (textField == txtField3) {
                    txtField4.isUserInteractionEnabled = true
                    txtField1.isUserInteractionEnabled = false
                    txtField2.isUserInteractionEnabled = false
                    txtField4.text = "\u{200B}"
                    txtField4.becomeFirstResponder()
                    txtField3.text = string
                    return false;
                }
                else if (textField == txtField4) {
                    textField.text = string;
                    return false;
                }
            }
            else if string.characters.count == 0 && textField.text!.characters.count > 0
            {
                if (textField == txtField1)
                {
                    txtField2.isUserInteractionEnabled = false
                    txtField3.isUserInteractionEnabled = false
                    txtField4.isUserInteractionEnabled = false
                    txtField1.text = ""
                    txtField1.becomeFirstResponder()
                    return false;
                }
                else if textField == txtField2 {
                    txtField1.isUserInteractionEnabled = true
                    txtField3.isUserInteractionEnabled = false
                    txtField4.isUserInteractionEnabled = false
                    txtField2.text = ""
                    txtField1.becomeFirstResponder()
                    return false;
                }
                else if textField == txtField3 {
                    txtField1.isUserInteractionEnabled = false
                    txtField2.isUserInteractionEnabled = true
                    txtField4.isUserInteractionEnabled = false
                    txtField3.text = ""
                    txtField2.becomeFirstResponder()
                    return false;
                }
                else if (textField == txtField4) {
                    txtField1.isUserInteractionEnabled = false
                    txtField2.isUserInteractionEnabled = false
                    txtField3.isUserInteractionEnabled = true
                    txtField4.text = ""
                    txtField3.becomeFirstResponder()
                    return false;
                }
                
            }
            return true
        }
        else
        {
            let index = IndexPath(row: 1, section: 0)
            let cell = tblView.cellForRow(at: index)
            let countryBtn = cell?.viewWithTag(5) as! UIButton
            let resultString: String = (textField.text! as NSString).replacingCharacters(in: range, with: string)
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
        
        return true
    }
    
    
    //MARK:- button
    
    @IBAction func loginBack(_ sender: UIButton) {
        self.view.endEditing(true)
        if from == "forgot"
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let index = IndexPath(row: 1, section: 0)
            let cell = tblView.cellForRow(at: index)
            
            let txtField1 = cell?.viewWithTag(2) as! UITextField
            let txtField2 = cell?.viewWithTag(3) as! UITextField
            let txtField3 = cell?.viewWithTag(4) as! UITextField
            let txtField4 = cell?.viewWithTag(5) as! UITextField
            
            txtField1.text = ""
            txtField2.text = ""
            txtField3.text = ""
            txtField4.text = ""
            
            
            if (dataDic.value(forKey: "old_mobile_no") != nil && dataDic.value(forKey: "old_mobile_no") as! String != dataDic.value(forKey: "mobile_no") as! String) || dataDic.value(forKey: "old_country_code") != nil
            {
                mobileChange()
            }
            else
            {
                resendCode()
            }
        }
    }
    
    @IBAction func editBtn(_ sender: UIButton) {
        
        let index = IndexPath(row: 1, section: 0)
        let cell = tblView.cellForRow(at: index)!
        let txt = cell.viewWithTag(1) as! UITextField
        
        if txt.isEnabled == true
        {
            txt.isEnabled = false
            txt.resignFirstResponder()
        }
        else
        {
            txt.isEnabled = true
            txt.becomeFirstResponder()
        }
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if from == "forgot"
        {
            let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
            
            if dataDic.value(forKey: "user_name") == nil || !(dataDic.value(forKey: "user_name") is String) ||
                dataDic.value(forKey: "user_name") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: enterEmail, delay: 2.0)
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
            forgotPassword()
        }
        else
        {
            let index = IndexPath(row: 1, section: 0)
            let cell = tblView.cellForRow(at: index)
            
            let txtField1 = cell?.viewWithTag(2) as! UITextField
            let txtField2 = cell?.viewWithTag(3) as! UITextField
            let txtField3 = cell?.viewWithTag(4) as! UITextField
            let txtField4 = cell?.viewWithTag(5) as! UITextField
            
            if (txtField1.text == "" || txtField2.text == "" || txtField3.text == "" || txtField4.text == "")
            {
                supportingfuction.showMessageHudWithMessage(message: enterOtp, delay: 2.0)
                return
            }
            else
            {
                let s = "\((txtField1.text)!)\((txtField2.text)!)\((txtField3.text)!)\((txtField4.text)!)"
                otpWebservice(otp: s)
            }
        }
    }
    
    
    @IBAction func countryCode(_ sender: UIButton) {
        
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        thirdView.delegate = self
        thirdView.from = "country"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- protocol
    func list(value1: String, value2: String) {
        
        if dataDic.value(forKey: "country_code") as! String != value1
        {
            dataDic.setValue(dataDic.value(forKey: "country_code") as! String, forKey: "old_country_code")
            dataDic.setValue(value1, forKey: "country_code")
        }
        self.tblView.reloadData()
    }
    
    func otpWebservice(otp: String)
    {
        self.view.endEditing(true)
        
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
                
                var web = String()
                if from == "otpPass"
                {
                    web = "api/otpverifypreset"
                }
                else
                {
                    web = "api/verifyotp"
                }
                let params = NSMutableDictionary()
                params.setValue(otp, forKey: "otp")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + web), parameters: params, progress: nil, success:
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
                                
                                if self.from == "otp" || self.from == "otpVerify"
                                {
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                    self.navigationController?.viewControllers = [viewController]
                                }
                                else if self.from == "otpPass"
                                {
                                    let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ChangePasswordViewController") as! ChangePasswordViewController
                                    viewController.from = "forgot"
                                    viewController.dataDic.setValue(otp, forKey: "otp")
                                    self.navigationController?.pushViewController(viewController, animated: true)
                                }
                                else if self.from == "otpProfile" || self.from == "otpMyProfile"
                                {
                                    for vc in (self.navigationController?.viewControllers)!
                                    {
                                        if vc.restorationIdentifier == "MyProfileViewController"
                                        {
                                            _ = self.navigationController?.popToViewController(vc, animated: true)
                                            return
                                        }
                                    }
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
    
    func mobileChange()
    {
        self.view.endEditing(true)
        if !(dataDic.value(forKey: "mobile_no") is String) || CommonValidations.numberLimit(testStr: dataDic.value(forKey: "mobile_no") as! String, min: 8, max: 14) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
            return
        }
        
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
                
                params.setValue(dataDic.value(forKey: "country_code") as! String, forKey: "country_code")
                params.setValue(dataDic.value(forKey: "mobile_no") as! String, forKey: "mobile_no")
                params.setValue("\(dataDic.value(forKey: "id")!)", forKey: "user_id")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/editmobresendotp"), parameters: params, constructingBodyWith: nil, progress: nil, success:
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
                                self.dataDic.removeObject(forKey: "old_mobile_no")
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
                //    print(error)
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
    
    
    
    func resendCode()
    {
        self.view.endEditing(true)
        if !(dataDic.value(forKey: "mobile_no") is String) || CommonValidations.numberLimit(testStr: dataDic.value(forKey: "mobile_no") as! String, min: 8, max: 14) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
            return
        }
        
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
                var web = ""
                
                if from == "otpPass" && from != "otp"
                {
                    params.setValue(dataDic.value(forKey: "mobile_no") as! String, forKey: "user_name")
                    params.setValue(dataDic.value(forKey: "country_code") as! String, forKey: "country_code")
                    web = "api/forgetpassword"
                }
                else if from == "otpVerify" || from == "otp" ||  from == "otpProfile" || from == "otpMyProfile"
                {
                    params.setValue(dataDic.value(forKey: "mobile_no") as! String, forKey: "mobile_no")
                    params.setValue(dataDic.value(forKey: "country_code") as! String, forKey: "country_code")
                    web = "api/resendotp"
                }
                
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + web), parameters: params, constructingBodyWith: nil, progress: nil, success:
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
                 //   print(error)
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
    
    
    func forgotPassword()
    {
        self.view.endEditing(true)
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
                params.setValue(dataDic.value(forKey: "user_name"), forKey: "user_name")
                params.setValue(dataDic.value(forKey: "country_code"), forKey: "country_code")
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/forgetpassword"), parameters: params, progress: nil, success:
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
                                
                                if (self.dataDic.value(forKey: "user_name") as! String).rangeOfCharacter(from: CharacterSet.decimalDigits) == nil
                                {
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
                                else
                                {
                                    let third = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
                                    third.from = "otpPass"
                                    third.dataDic.setValue(self.dataDic.value(forKey: "user_name") as! String, forKey: "mobile_no")
                                    third.dataDic.setValue(self.dataDic.value(forKey: "country_code") as! String, forKey: "country_code")
                                    self.dataDic.removeObject(forKey: "user_name")
                                    self.navigationController?.pushViewController(third, animated: true)
                                }
                                
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
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
}
