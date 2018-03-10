//
//  RegisterViewController.swift
//  Tick8
//
//  Created by singsys on 31/7/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate,listing {
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bgimgV: UIImageView!
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    var from:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(RegisterViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(RegisterViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        if #available(iOS 11.0, *) {
            tblView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        // Do any additional setup after loading the view.
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
    
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- table view functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        
        if indexPath.row == 0
        {
            height = 140
        }
        else if indexPath.row == 5
        {
            height = 70
        }
        else if indexPath.row == 1
        {
            height = 73
        }
        else if indexPath.row == 6
        {
            height = self.view.frame.height - 470
        }
        else
        {
            height = 59
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "logoCell")!
        }
        else if indexPath.row == 5
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
            
            let regBtn = cell.viewWithTag(1) as! UIButton
            regBtn.layer.cornerRadius = 19
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            
            let txtfld1 = cell.viewWithTag(1) as! UITextField
            let txtfld2 = cell.viewWithTag(2) as! UITextField
            
            
            if dataDic.value(forKey: "f_name") != nil && dataDic.value(forKey: "f_name") as! String != ""
            {
                txtfld1.text = dataDic.value(forKey: "f_name") as? String
            }
            else
            {
                txtfld1.text = ""
            }
            
            if dataDic.value(forKey: "l_name") != nil && dataDic.value(forKey: "l_name") as! String != ""
            {
                txtfld2.text = dataDic.value(forKey: "l_name") as? String
            }
            else
            {
                txtfld2.text = ""
            }
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "mobCell")!
            let headLbl = cell.viewWithTag(1) as! UILabel
            let txtfld = cell.viewWithTag(2) as! UITextField
            let codeBtn = cell.viewWithTag(3) as! UIButton
            headLbl.text = "Mobile Number"
            
            if dataDic.value(forKey: "mobile_no") != nil && dataDic.value(forKey: "mobile_no") as! String != ""
            {
                txtfld.text = "\(dataDic.value(forKey: "mobile_no")!)"
            }
            else
            {
                txtfld.text = ""
            }
            
            
            if dataDic.value(forKey: "country_code") != nil && dataDic.value(forKey: "country_code") as! String != ""
            {
                codeBtn.setTitle("+\(dataDic.value(forKey: "country_code")!)", for: .normal)
                //codeBtn.titleLabel?.text = dataDic.value(forKey: "country_code") as? String
                codeBtn.titleLabel?.adjustsFontSizeToFitWidth = true
                for cons in codeBtn.constraints
                {
                    if cons.identifier == "width"
                    {
                        cons.constant = codeBtn.intrinsicContentSize.width
                    }
                }
            }
            else
            {
                codeBtn.setTitle("+91", for: .normal)
            }
        }
        else if indexPath.row == 6
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "loginCell")!
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
            
            let headLbl = cell.viewWithTag(1) as! UILabel
            let txtfld = cell.viewWithTag(2) as! UITextField
            let showBtn = cell.viewWithTag(3) as! UIButton
            showBtn.isHidden = true
            
            if indexPath.row == 3
            {
                headLbl.text = "Email Id"
                if dataDic.value(forKey: "email") != nil && dataDic.value(forKey: "email") as! String != ""
                {
                    txtfld.text = dataDic.value(forKey: "email") as? String
                }
                else
                {
                    txtfld.text = ""
                }
            }
            else if indexPath.row == 4
            {
                headLbl.text = "Password"
                txtfld.isSecureTextEntry = true
                
                if dataDic.value(forKey: "password") != nil && dataDic.value(forKey: "password") as! String != ""
                {
                    txtfld.text = dataDic.value(forKey: "password") as? String
                    showBtn.isHidden = false
                }
                else
                {
                    txtfld.text = ""
                }
            }
        }
        
        tableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.clear
        cell.contentView.backgroundColor = UIColor.clear
        
        return cell
    }
    
    //MARK:- textfield functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblView.addGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
        //textField.isSecureTextEntry = false
        
        if indexPath?.row == 1
        {
            textField.autocapitalizationType = .words
        }
        else
            if indexPath?.row == 2
            {
                doneKeyboard(textField: textField
                    , width: self.view.frame.width, height: self.view.frame.height)
                textField.keyboardType = .numberPad
                
            }
            else if indexPath?.row == 3
            {
                textField.keyboardType = .emailAddress
            }
            else if indexPath?.row == 4
            {
                //textField.isSecureTextEntry = true
                textField.returnKeyType = .done
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.removeGestureRecognizer(tapGesture)
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.row == 1 && textField.tag == 1
        {
            dataDic.setValue(textField.text, forKey: "f_name")
        }
        else if indexPath?.row == 1 && textField.tag == 2
        {
            dataDic.setValue(textField.text, forKey: "l_name")
        }
        else if indexPath?.row == 2
        {
            dataDic.setValue(textField.text, forKey: "mobile_no")
        }
        else if indexPath?.row == 3
        {
            dataDic.setValue(textField.text, forKey: "email")
        }
        else if indexPath?.row == 4
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
            if textField.tag == 1
            {
                let txtf = cell?.viewWithTag(2)
                txtf?.becomeFirstResponder()
            }
            else if textField.tag == 2
            {
                let ind = IndexPath(row: (indexPath?.row)!+1, section: (indexPath?.section)!)
                let cell1 = tblView.cellForRow(at: ind)
                let txt = cell1?.viewWithTag(2) as! UITextField
                txt.becomeFirstResponder()
            }
        }
        else if indexPath?.row == 2 || indexPath?.row == 3
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
        
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.row == 2
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if !(string == numberFiltered)
            {
                return false
            }
            
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 14
        }
        else if indexPath?.row == 1
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 30
        }
        else if indexPath?.row == 4
        {
            let cell = tblView.cellForRow(at: indexPath!)!
            let btn = cell.viewWithTag(3) as! UIButton
            
            if (textField.text?.characters.count == 1 && string.isEmpty)
            {
                btn.isHidden = true
            } else
            {
                btn.isHidden = false
            }
            
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 20
        }
        
        return true
    }
    
    @IBAction func showBtn(_ sender: UIButton) {
        
        let indexPath = IndexPath(row: 4, section: 0)
        let cell = self.tblView.cellForRow(at: indexPath)
        let txtfld = cell?.viewWithTag(2) as! UITextField
        if indexPath.row == 4
        {
            if sender.isSelected == false
            {
                sender.isSelected = true
                txtfld.isSecureTextEntry = false
                txtfld.keyboardType = .asciiCapable
            }
            else
            {
                sender.isSelected = false
                txtfld.isSecureTextEntry = true
                txtfld.keyboardType = .asciiCapable
                
            }
        }
    }
    
    @IBAction func register(_ sender: UIButton) {
        self.view.endEditing(true)
        
        if dataDic.value(forKey: "f_name") == nil || (dataDic.value(forKey: "f_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterFirstName, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "l_name") == nil || (dataDic.value(forKey: "l_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterLastName, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "mobile_no") == nil || (dataDic.value(forKey: "mobile_no") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterMobileNum, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "mobile_no") as! String, min: 8, max: 14) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validMobileNum, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "email") == nil || (dataDic.value(forKey: "email") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterEmail, delay: 2.0)
            return
        }
        else if CommonValidations.isValidEmail(testStr: dataDic.value(forKey: "email") as! String) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validEmail, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "password") == nil || (dataDic.value(forKey: "password") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
        {
            supportingfuction.showMessageHudWithMessage(message: enterPassword, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "password") as! String, min: 8, max: 20) == false
        {
            supportingfuction.showMessageHudWithMessage(message: validPassword, delay: 2.0)
            return
        }
        
        signUpwebService()
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
    
    @IBAction func loginBtn(_ sender: UIButton) {
        
        if from == "login"
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            thirdView.from = "register"
            self.navigationController?.pushViewController(thirdView, animated: true)
        }
    }
    
    @IBAction func countryCodeBtn(_ sender: UIButton)
    {
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        thirdView.delegate = self
        thirdView.from = "country"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    func list(value1: String, value2: String) {
        
        dataDic.setValue(value1, forKey: "country_code")
        self.tblView.reloadData()
    }
    
    func signUpwebService()
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
                
                //dataDic.setValue("+91", forKey: "country_code")
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/doregister"), parameters: dataDic, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
                                vc.from = "otp"
                                vc.dataDic = (dataFromServer.value(forKey: "data") as! NSDictionary).mutableCopy() as! NSMutableDictionary
                                self.dataDic.removeAllObjects()
                                self.navigationController?.pushViewController(vc, animated: true)
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

