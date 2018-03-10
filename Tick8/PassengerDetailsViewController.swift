//
//  PassengerDetailsViewController.swift
//  Tick8
//
//  Created by singsys on 9/27/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

protocol passengerDetail {
    func passenger(value1:NSMutableDictionary)
}

class PassengerDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var info: UILabel!
    var dataDic = NSMutableDictionary()
    var delegate:passengerDetail!
    var tapGesture = UITapGestureRecognizer()
    var isAdult = ""
    var isInternational = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.isHidden = true
        
        info.text = "The information needs to be same as on your Passport."
        NotificationCenter.default.addObserver(self, selector: #selector(PassengerDetailsViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(PassengerDetailsViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(PassengerDetailsViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        
        if dataDic.value(forKey: "title") == nil
        {
            dataDic.setValue("", forKey: "title")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    
    // MARK: - keyboard handling
    
    func keyboardWillShow(notification: NSNotification)
    {
        var userInfo = notification.userInfo!
        let keyboardFrame:CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardFrame.height, 0.0)
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        let contentInsets = UIEdgeInsets.zero as UIEdgeInsets
        tableView!.contentInset = contentInsets
        tableView!.scrollIndicatorInsets = contentInsets;
    }
    
    func hideKeyboard()
    {
        self.view.endEditing(true)
    }
    
    //MARK:- tableview delegates
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isAdult == "adult"
        {
            if isInternational == true
            {
                return 7
            }
            else
            {
                return 4
            }
        }
        else
        {
            if isInternational == true
            {
                return 7
            }
            else
            {
                return 5
            }
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        if (indexPath.row == 0)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "checkCell")!
            
            let mrBtn = cell.viewWithTag(1) as! UIButton
            let mrsBtn = cell.viewWithTag(2) as! UIButton
            let msBtn = cell.viewWithTag(3) as! UIButton
            
            mrsBtn.isHidden = (isAdult == "adult") ? false : true
            mrBtn.setTitle(((isAdult == "adult") ? " Mr." : " Master"), for: .normal)
            msBtn.setTitle(((isAdult == "adult") ? " Ms." : " Miss"), for: .normal)
            
            if dataDic.value(forKey: "title") as! String == ""
            {
                mrBtn.setImage(UIImage (named: "unselectR"), for: .normal)
                mrsBtn.setImage(UIImage (named: "unselectR"), for: .normal)
                msBtn.setImage(UIImage (named: "unselectR"), for: .normal)
            }
            else if dataDic.value(forKey: "title") as! String == "Mr"
            {
                mrBtn.setImage(UIImage (named: "selectR"), for: .normal)
                mrsBtn.setImage(UIImage (named: "unselectR"), for: .normal)
                msBtn.setImage(UIImage (named: "unselectR"), for: .normal)
            }
            else if dataDic.value(forKey: "title") as! String == "Mrs"
            {
                mrsBtn.setImage(UIImage (named: "selectR"), for: .normal)
                mrBtn.setImage(UIImage (named: "unselectR"), for: .normal)
                msBtn.setImage(UIImage (named: "unselectR"), for: .normal)
            }
            else if dataDic.value(forKey: "title") as! String == "Ms"
            {
                msBtn.setImage(UIImage (named: "selectR"), for: .normal)
                mrsBtn.setImage(UIImage (named: "unselectR"), for: .normal)
                mrBtn.setImage(UIImage (named: "unselectR"), for: .normal)
            }
        }
        else if (indexPath.row == 1) || (indexPath.row == 2)
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            
            let name = cell.viewWithTag(1) as! UILabel
            let lbl = cell.viewWithTag(2) as! UITextField
            lbl.isEnabled = true
            if indexPath.row == 1
            {
                name.text = "First Name"
                
                if dataDic.value(forKey: "first_name") != nil && dataDic.value(forKey: "first_name") as! String != ""
                {
                    lbl.text = dataDic.value(forKey: "first_name") as? String
                }
                else
                {
                    lbl.text = ""
                }
            }
            else if indexPath.row == 2
            {
                name.text = "Last Name"
                
                if dataDic.value(forKey: "last_name") != nil && dataDic.value(forKey: "last_name") as! String != ""
                {
                    lbl.text = dataDic.value(forKey: "last_name") as? String
                }
                else
                {
                    lbl.text = ""
                }
            }
        }
        else if indexPath.row == 3 && (isAdult == "child" || isAdult == "infant" || isInternational == true)
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            
            let name = cell.viewWithTag(1) as! UILabel
            name.text = "Date of Birth"
            let lbl = cell.viewWithTag(2) as! UITextField
            lbl.isEnabled = false
            
            if dataDic.value(forKey: "DateOfBirth") != nil && dataDic.value(forKey: "DateOfBirth") as! String != ""
            {
                
                lbl.text = dateFormatter1.string(from: dateFormatter.date(from: (dataDic.value(forKey: "DateOfBirth") as? String)!)!)
            }
            else
            {
                lbl.text = ""
            }
        }
        else if indexPath.row == 4 && isInternational == true
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            
            let name = cell.viewWithTag(1) as! UILabel
            name.text = "Passport Number"
            let lbl = cell.viewWithTag(2) as! UITextField
            lbl.isEnabled = true
            
            if dataDic.value(forKey: "PassportNo") != nil && dataDic.value(forKey: "PassportNo") as! String != ""
            {
                lbl.text = dataDic.value(forKey: "PassportNo") as? String
            }
            else
            {
                lbl.text = ""
            }
        }
        else if indexPath.row == 5 && isInternational == true
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateFormatter1 = DateFormatter()
            dateFormatter1.dateFormat = "dd-MM-yyyy"
            
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            let name = cell.viewWithTag(1) as! UILabel
            name.text = "Passport Expiry Date"
            let lbl = cell.viewWithTag(2) as! UITextField
            lbl.isEnabled = false
            
            if dataDic.value(forKey: "PassportExpiry") != nil && dataDic.value(forKey: "PassportExpiry") as! String != ""
            {
                lbl.text = dateFormatter1.string(from: dateFormatter.date(from: (dataDic.value(forKey: "PassportExpiry") as? String)!)!)
            }
            else
            {
                lbl.text = ""
            }
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "submitCell")!
            let submitBtn = cell.viewWithTag(1) as! UIButton
            submitBtn.layer.cornerRadius = 18
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (isAdult == "child" || isAdult == "infant" || isInternational == true) && indexPath.row == 3
        {
            //.addingTimeInterval(60*60*24)
            if isAdult == "child"
            {
                datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())
                 datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -12, to: Date())
            }
            else if isAdult == "infant"
            {
                datePicker.maximumDate = Date()
                datePicker.minimumDate = Calendar.current.date(byAdding: .year, value: -2, to: Date())?.addingTimeInterval(60*60*24)
            }
            else
            {
                datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -12, to: Date())
            }
            
            if dataDic.value(forKey: "DateOfBirth") != nil
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let d = dateFormatter.date(from: "\(dataDic.value(forKey: "DateOfBirth")!)")
                datePicker.date = d!
            }
         
            
            datePicker.tag = 1
            datePicker.datePickerMode = .date
            tableView.isUserInteractionEnabled = false
            datePickerView.isHidden = false
        }
        else if isInternational == true && indexPath.row == 5
        {
//            let dateFormatter1 = DateFormatter()
//            dateFormatter1.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss"
            datePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 90, to: Date())
            datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: 100, to: Date())
            
            datePicker.datePickerMode = .date
            
            if  dataDic.value(forKey: "PassportExpiry") != nil
            {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let d = dateFormatter.date(from: "\(dataDic.value(forKey: "PassportExpiry")!)")
                datePicker.date = d!
            }
            
            datePicker.tag = 2
            tableView.isUserInteractionEnabled = false
            datePickerView.isHidden = false
        }
    }
    
    //MARK:- textfield delegates
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        self.tableView.addGestureRecognizer(tapGesture)
        let hitPoint = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: hitPoint)!
        textField.returnKeyType = .done
        textField.keyboardType = .asciiCapable
        textField.autocapitalizationType = .words
        
        if indexPath.row == 1
        {
            textField.returnKeyType = .next
        }
        else if indexPath.row == 4
        {
            textField.autocapitalizationType = .allCharacters
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.tableView.removeGestureRecognizer(tapGesture)
        let hitPoint = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: hitPoint)!
        
        if indexPath.row == 1
        {
            dataDic.setValue(textField.text!, forKey: "first_name")
        }
        else if indexPath.row == 2
        {
            dataDic.setValue(textField.text!, forKey: "last_name")
        }
        else if indexPath.row == 4
        {
            dataDic.setValue(textField.text!, forKey: "PassportNo")
        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        let hitPoint = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: hitPoint)!
        
        if indexPath.row == 1 ||  indexPath.row == 2
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 32
        }
        
        if indexPath.row == 4
        {
//            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
//            let compSepByCharInSet = string.components(separatedBy: aSet)
//            let numberFiltered = compSepByCharInSet.joined(separator: "")
//            if !(string == numberFiltered)
//            {
//                return false
//            }
//
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 9
        
        }
   
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let hitPoint = textField.convert(CGPoint.zero, to: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: hitPoint)!
        
        if indexPath.row == 1
        {
            let indexPath1 = IndexPath(row: indexPath.row + 1, section: 0)
            let cell = tableView.cellForRow(at: indexPath1)
            let nextTextfield = cell?.viewWithTag(2) as! UITextField
            nextTextfield.becomeFirstResponder()
        }
        else
        {
            self.view.endEditing(true)
        }
        return true
    }
    
    //MARK:- action button
    
    @IBAction func select(_sender: UIButton)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if datePicker.tag == 1
        {
            dataDic.setValue(dateFormatter.string(from: datePicker.date), forKey: "DateOfBirth")
        }
        else
        {
            dataDic.setValue(dateFormatter.string(from: datePicker.date), forKey: "PassportExpiry")
        }
        
        self.datePickerView.isHidden = true
        self.tableView.reloadData()
        tableView.isUserInteractionEnabled = true
    }
    
    @IBAction func cancel(_sender: UIButton)
    {
        self.datePickerView.isHidden = true
        tableView.isUserInteractionEnabled = true
    }
    
    @IBAction func backBtn(_sender: UIButton)
    {
        _ = self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func radioBTn(_sender: UIButton)
    {
        if _sender.tag == 1
        {
            dataDic.setValue("Mr", forKey: "title")
        }
        else if _sender.tag == 2
        {
            dataDic.setValue("Mrs", forKey: "title")
        }
        else if _sender.tag == 3
        {
            dataDic.setValue("Ms", forKey: "title")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func submitBtn(_sender: UIButton)
    {
        if dataDic.value(forKey: "title") == nil || "\(dataDic.value(forKey: "title")!)" == ""
        {
            supportingfuction.showMessageHudWithMessage(message:passenger_title, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "first_name") == nil || dataDic.value(forKey: "first_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: first_name, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "first_name") as! String, min: 2, max: 32) == false
        {
            supportingfuction.showMessageHudWithMessage(message: limit_first_name, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "last_name") == nil || dataDic.value(forKey: "last_name") as! String == ""
        {
            supportingfuction.showMessageHudWithMessage(message: last_name, delay: 2.0)
            return
        }
        else if CommonValidations.numberLimit(testStr: dataDic.value(forKey: "last_name") as! String, min: 2, max: 32) == false
        {
            supportingfuction.showMessageHudWithMessage(message: limit_last_name, delay: 2.0)
            return
        }
        else if(dataDic.value(forKey: "first_name") as! String == dataDic.value(forKey: "last_name") as! String)
        {
            supportingfuction.showMessageHudWithMessage(message: not_match_name, delay: 2.0)
            return
        }
        else if ((isAdult == "child" || isAdult == "infant" || isInternational == true) && (dataDic.value(forKey: "DateOfBirth") == nil || dataDic.value(forKey: "DateOfBirth") as! String == ""))
        {
            supportingfuction.showMessageHudWithMessage(message: dob, delay: 2.0)
            return
        }
        else if isInternational == true && (dataDic.value(forKey: "PassportNo") == nil || dataDic.value(forKey: "PassportNo") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: passport_number, delay: 2.0)
            return
        }
        else if isInternational == true && (dataDic.value(forKey: "PassportExpiry") == nil || dataDic.value(forKey: "PassportExpiry") as! String == "")
        {
            supportingfuction.showMessageHudWithMessage(message: passport_expiry, delay: 2.0)
            return
        }
        
        sendProtocol()
    }
    
    func sendProtocol()
    {
        if (isAdult == "adult")
        {
            dataDic.setValue("1", forKey: "PaxType")
        }
        else if (isAdult == "child")
        {
            dataDic.setValue("2", forKey: "PaxType")
        }
        else
        {
            dataDic.setValue("3", forKey: "PaxType")
        }
        
        dataDic.setValue(((dataDic.value(forKey: "title") != nil && "\(dataDic.value(forKey: "title")!)" == "Mr") ? "male" : "female"), forKey: "gender")
        delegate.passenger(value1: dataDic)
        self.dismiss(animated: true, completion: nil)
    }
}
