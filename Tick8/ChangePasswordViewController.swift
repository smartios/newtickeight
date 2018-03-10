//
//  ChangePasswordViewController.swift
//  Tick8
//
//  Created by singsys on 7/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var tblView: UITableView!
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChangePasswordViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        if from == "forgot"
        {
            return 5
        }
        else
        {
            return 6
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var height:CGFloat = 0
        
        if from != "forgot"
        {
            if indexPath.row == 0
            {
                height = 249
            }
            else if indexPath.row == 4
            {
                height = 80
            }
            else if indexPath.row == 5
            {
                height = 100
            }
            else
            {
                height = 65
            }
        }
        else
        {
            if indexPath.row == 0
            {
                height = 249
            }
            else if indexPath.row == 3
            {
                height = 80
            }
            else if indexPath.row == 4
            {
                height = self.view.frame.height - 480
            }
            else
            {
                height = 65
            }
        }
        return height
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if from == "forgot"
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else if indexPath.row == 3
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
                let save = cell.viewWithTag(1) as! UIButton
                save.layer.cornerRadius = 18
            }
            else if indexPath.row == 4
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "backCell")!
                let back = cell.viewWithTag(1) as! UIButton
                back.setTitle("Login", for: .normal)
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
                let head = cell.viewWithTag(1) as! UILabel
                let txtfld = cell.viewWithTag(2) as! UITextField
                txtfld.isSecureTextEntry = true
                
                 if indexPath.row == 1
                {
                    head.text = "New Password"
                }
                else if indexPath.row == 2
                {
                    head.text = "Re-Type Password"
                }
            }

        }
        else
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else if indexPath.row == 4
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
                let save = cell.viewWithTag(1) as! UIButton
                save.layer.cornerRadius = 18
            }
            else if indexPath.row == 5
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "backCell")!
                let back = cell.viewWithTag(1) as! UIButton
                back.setTitle("My Profile", for: .normal)
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
                let head = cell.viewWithTag(1) as! UILabel
                let txtfld = cell.viewWithTag(2) as! UITextField
                txtfld.isSecureTextEntry = true
                
                if indexPath.row == 1
                {
                    head.text = "Old Password"
                }
                else if indexPath.row == 2
                {
                    head.text = "New Password"
                }
                else if indexPath.row == 3
                {
                    head.text = "Re-Type Password"
                }
            }
        }
        
        
    return cell
    }
    
    //MARK:- textfield functions
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        tblView.addGestureRecognizer(tapGesture)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
        
        if from != "forgot"
        {
            if indexPath?.row == 3
            {
                textField.returnKeyType = .done
            }
        }
        else
        {
            if indexPath?.row == 2
            {
                textField.returnKeyType = .done
            }
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.removeGestureRecognizer(tapGesture)
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if from != "forgot"
        {
            if indexPath?.row == 1
            {
                dataDic.setValue(textField.text, forKey: "old_password")
            }
            else if indexPath?.row == 2
            {
                dataDic.setValue(textField.text, forKey: "password")
            }
            else if indexPath?.row == 3
            {
                dataDic.setValue(textField.text, forKey: "password_confirmation")
            }
        }
        else
        {
             if indexPath?.row == 1
            {
                dataDic.setValue(textField.text, forKey: "password")
            }
            else if indexPath?.row == 2
            {
                dataDic.setValue(textField.text, forKey: "password_confirmation")
            }
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
         else if from != "forgot" && indexPath?.row == 2
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
        
        if cell == nil
        {
            self.view.endEditing(true)
            return false
        }

        
        if textField.text == "" &&  string == " "
        {
            return false
        }
        
        if indexPath?.row == 1 || indexPath?.row == 2  || indexPath?.row == 3
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
    
 
    @IBAction func back(_ sender: UIButton)
    {
        if from != "forgot"
        {
             _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            let third = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.navigationController?.viewControllers = [third]
            //_ = self.navigationController?.popToViewController(third, animated: true)
        }
        //_ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func save(_ sender: UIButton)
    {
        if from != "forgot"
        {
            if dataDic.value(forKey: "old_password") == nil || dataDic.value(forKey: "old_password") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: currentPass , delay: 2.0)
                return
            }
            else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "old_password") as! String, min: 8, max: 20) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validOldPassword , delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "password") == nil || dataDic.value(forKey: "password") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: newPass , delay: 2.0)
                return
            }
            else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "password") as! String, min: 8, max: 20) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validNewPassword , delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "password_confirmation") == nil || dataDic.value(forKey: "password_confirmation") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: conPass , delay: 2.0)
                return
            }
            else if (dataDic.value(forKey: "password") as! String) != dataDic.value(forKey: "password_confirmation") as! String
            {
                supportingfuction.showMessageHudWithMessage(message: Samepass , delay: 2.0)
                return
            }
            changePassword()
        }
        else
        {
            if dataDic.value(forKey: "password") == nil || dataDic.value(forKey: "password") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: newPass , delay: 2.0)
                return
            }
            else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "password") as! String, min: 8, max: 20) == false
            {
                supportingfuction.showMessageHudWithMessage(message: validNewPassword , delay: 2.0)
                return
            }
            else if dataDic.value(forKey: "password_confirmation") == nil || dataDic.value(forKey: "password_confirmation") as! String == ""
            {
                supportingfuction.showMessageHudWithMessage(message: conPass , delay: 2.0)
                return
            }
            else if (dataDic.value(forKey: "password") as! String) != dataDic.value(forKey: "password_confirmation") as! String
            {
                supportingfuction.showMessageHudWithMessage(message: Samepass , delay: 2.0)
                return
            }
            
            forgotpasswordChange()
        }
    }
    
    
    func changePassword()
    {
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
                
                
                let params = NSMutableDictionary()
                params.setValue(dataDic.value(forKey: "old_password"), forKey: "old_password")
                params.setValue(dataDic.value(forKey: "password"), forKey: "password")
                params.setValue(dataDic.value(forKey: "password_confirmation"), forKey:"password_confirmation")
               
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/user/chagepassword"), parameters: params
                , progress: nil, success:
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
                                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: {
                                    // Put your code which should be executed with a delay here
                                   _ = self.navigationController?.popViewController(animated: true)
                                })
                                
                                
                            }
                            else
                            {
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
               //         print(status)
                    }
            //        print(error)
                    supportingfuction.showMessageHudWithMessage(message: "Please try again..", delay: 2.0)
                })
            }
            else
            {
                supportingfuction.showMessageHudWithMessage(message: "No Internet Connection", delay: 2.0)
            }
        }
    }
    
    
    
    func forgotpasswordChange()
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
                params.setValue(dataDic.value(forKey: "password") as! String, forKey: "password")
                params.setValue(dataDic.value(forKey: "password_confirmation") as! String, forKey: "password_confirmation")
                params.setValue(dataDic.value(forKey: "otp") as! String, forKey: "otp")
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/resetpassword"), parameters: params, progress: nil, success:
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
                                
                                let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                                self.navigationController?.pushViewController(thirdView, animated: true)
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
