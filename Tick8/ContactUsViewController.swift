//
//          ContactUsViewController.swift
//  Tick8
//
//  Created by singsys on 21/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class ContactUsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate,listing {
    
    @IBOutlet weak var tblView: UITableView!
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ContactUsViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(ContactUsViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        if UserDefaults.standard.value(forKey: "userData") != nil
        {
            dataDic.setValue("\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "f_name")!)", forKey: "f_name")
            dataDic.setValue("\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "l_name")!)", forKey: "l_name")
            dataDic.setValue("\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "email")!)", forKey: "email")
            dataDic.setValue("\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "mobile_no")!)", forKey: "contact_no")
            dataDic.setValue("\((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "country_code")!)", forKey: "country_code")
            self.tblView.reloadData()
        }
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if dataDic.value(forKey: "country_code") == nil || dataDic.value(forKey: "country_code") as! String == ""
        {
            dataDic.setValue("91", forKey: "country_code")
            self.tblView.reloadData()
        }
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
    
    //MARK:- tableview functions
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height:CGFloat = 0
        
        if indexPath.row == 0
        {
            height = 80
        }
        else if indexPath.row == 1 || indexPath.row == 2
        {
            height = 60
        }
        else if indexPath.row == 3
        {
            height = 145
        }
        else if indexPath.row == 4
        {
            height = 76
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            let fname = cell.viewWithTag(1) as! UITextField
            let lname = cell.viewWithTag(2) as! UITextField
            
            if (dataDic.value(forKey: "f_name") != nil) && dataDic.value(forKey: "f_name") as! String != ""
            {
                fname.text = dataDic.value(forKey: "f_name") as? String
            }
            
            if (dataDic.value(forKey: "l_name") != nil) && dataDic.value(forKey: "l_name") as! String != ""
            {
                lname.text = dataDic.value(forKey: "l_name") as? String
            }
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "mobCell")!
            let headLbl = cell.viewWithTag(1) as! UILabel
            let txtfld = cell.viewWithTag(2) as! UITextField
            let codeBtn = cell.viewWithTag(3) as! UIButton
            
            let text = "Mobile Number(optional)"
            let range = (text as NSString).range(of: "(optional)")
            let attributedString = NSMutableAttributedString(string: text)
            attributedString.addAttribute(NSForegroundColorAttributeName, value: supportingfuction.hexStringToUIColor(hex: "acacac") , range: range)
            attributedString.addAttributes([NSFontAttributeName : UIFont.init(name: "Arimo-Italic", size: 11)], range: range)
            headLbl.attributedText = attributedString
            
            if dataDic.value(forKey: "contact_no") != nil && dataDic.value(forKey: "contact_no") as! String != ""
            {
                txtfld.text = "\(dataDic.value(forKey: "contact_no")!)"
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
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
            let header = cell.viewWithTag(1) as! UILabel
            header.text = "Email Id"
            let txtfld = cell.viewWithTag(2) as! UITextField
            
            if (dataDic.value(forKey: "email") != nil) && dataDic.value(forKey: "email") as! String != ""
            {
                txtfld.text = dataDic.value(forKey: "email") as? String
            }
        }
        else if indexPath.row == 3
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "messageCell")!
            let txtfld = cell.viewWithTag(1) as! UITextView
            
            if (dataDic.value(forKey: "message") != nil) && dataDic.value(forKey: "message") as! String != ""
            {
                txtfld.text = dataDic.value(forKey: "message") as! String
            }
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "btnCell")!
            let btn = cell.viewWithTag(1) as! UIButton
            btn.layer.cornerRadius = 18
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
        textField.autocapitalizationType = .words
        
        if indexPath?.row == 1
        {
            textField.keyboardType = .numberPad
            doneKeyboard(textField: textField
                , width: self.view.frame.width, height: self.view.frame.height)
        }
        else if indexPath?.row == 2
        {
            textField.autocapitalizationType = .none
            textField.keyboardType = .emailAddress
            textField.returnKeyType = .done
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        tblView.removeGestureRecognizer(tapGesture)
        self.view.endEditing(true)
        let hit = textField.convert(CGPoint.zero, to: self.tblView)
        let indexPath = self.tblView.indexPathForRow(at: hit)
        
        if indexPath?.row == 0 && textField.tag == 1
        {
            dataDic.setValue(textField.text, forKey: "f_name")
        }
        else if indexPath?.row == 0 && textField.tag == 2
        {
            dataDic.setValue(textField.text, forKey: "l_name")
        }
        else if indexPath?.row == 1
        {
            dataDic.setValue(textField.text, forKey: "contact_no")
        }
        else if indexPath?.row == 2
        {
            dataDic.setValue(textField.text, forKey: "email")
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
        
        if indexPath?.row == 0
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
        else if indexPath?.row == 1
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
        
        if textField.text == "" &&  string == " "
        {
            return false
        }
        
        if indexPath?.row == 1
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if !(string == numberFiltered)
            {
                return false
            }
        }
        
        
        if indexPath?.row == 0
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 30
        }
        else if indexPath?.row == 1
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength < 15
        }
        return true
    }
    
    //MARK:- textview functions
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        tblView.addGestureRecognizer(tapGesture)
        textView.keyboardType = .asciiCapable
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        tblView.removeGestureRecognizer(tapGesture)
        dataDic.setValue(textView.text, forKey: "message")
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentCharacterCount = textView.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + text.characters.count - range.length
        return newLength <= 150
    }
    
    
    //MARK:- button handling
    @IBAction func sidemenubtn(_ sender: UIButton) {
        sideMenuViewController?._presentLeftMenuViewController()
    }
    
    
    @IBAction func countryCodeBtn(_ sender: UIButton)
    {
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        thirdView.delegate = self
        thirdView.from = "country"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    @IBAction func submitBtn(_ sender: UIButton) {
        
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
            //            else if dataDic.value(forKey: "mobile_no") == nil || (dataDic.value(forKey: "mobile_no") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
            //            {
            //                supportingfuction.showMessageHudWithMessage(message: enterMobileNum, delay: 2.0)
            //                return
            //            }
        else if dataDic.value(forKey: "contact_no") != nil && (dataDic.value(forKey: "contact_no") as! String).trimmingCharacters(in: .whitespacesAndNewlines) != "" && (CommonValidations.numberLimit(testStr: dataDic.value(forKey: "contact_no") as! String, min: 8, max: 14) == false)
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
        else if dataDic.value(forKey: "message") == nil || dataDic.value(forKey: "message") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: message, delay: 2.0)
            return
        }
        
        webservice()
    }
    
    func list(value1: String, value2: String) {
        
        dataDic.setValue(value1, forKey: "country_code")
        self.tblView.reloadData()
    }
    
    func webservice()
    {
        let reach: Reachability
        do{
            reach = Reachability.forInternetConnection()
            if reach.isReachable()
            {
                let manager = AFHTTPSessionManager()
                let requestSerializer = AFJSONRequestSerializer()
                
                //requestSerializer.setValue("Bearer \((UserDefaults.standard.value(forKey: "userData") as! NSDictionary).value(forKey: "accessToken")!)", forHTTPHeaderField: "Authorization")
                requestSerializer.setValue("application/json", forHTTPHeaderField: "Accept")
                
                manager.requestSerializer = requestSerializer
                manager.requestSerializer.timeoutInterval = 120
                
                let params:NSMutableDictionary = dataDic
                
                if dataDic.value(forKey: "contact_no") == nil || (dataDic.value(forKey: "contact_no") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
                {
                    params.setValue("", forKey: "country_code")
                }
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/contact-us"), parameters: dataDic, progress: nil, success:
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
                                _ = self.navigationController?.popViewController(animated: true)
                            }
                            else
                            {
                                supportingfuction.showMessageHudWithMessage(message: dataFromServer.value(forKey: "message") as! String, delay: 2.0)
                            }
                        }
                }, failure: {
                    requestOperation, error in
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
