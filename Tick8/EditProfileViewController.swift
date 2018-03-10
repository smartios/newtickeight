//
//  EditProfileViewController.swift
//  Tick8
//
//  Created by singsys on 7/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate,listing, PECropViewControllerDelegate {

    @IBOutlet weak var bgImg: UIImageView!
    var dataDic = NSMutableDictionary()
    var tapGesture = UITapGestureRecognizer()
    @IBOutlet weak var tblView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(EditProfileViewController.hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        

        // Do any additional setup after loading the view.
    }

    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.view.frame.height >= 736
        {
            bgImg.image = #imageLiteral(resourceName: "BG.png")
        }
        else if self.view.frame.height == 667
        {
            bgImg.image = #imageLiteral(resourceName: "BG750.png")
        }
        else if self.view.frame.height == 568
        {
            bgImg.image = #imageLiteral(resourceName: "BG640x1136.png")
        }
        else if self.view.frame.height == 480
        {
            bgImg.image = #imageLiteral(resourceName: "BG640x960.png")
        }
        
        if(dataDic.value(forKey: "country_code") == nil)
        {
            dataDic.setValue("91", forKey: "country_code")
        }
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
        
        var height = CGFloat()
        if indexPath.row == 0
        {
            height = 170
        }
        else  if indexPath.row == 1
        {
            height = 73
        }
         else if indexPath.row == 2 || indexPath.row == 3
        {
            height = 60
        }
         else if indexPath.row == 4
        {
            height = 80
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if indexPath.row == 0
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            let profile = cell.viewWithTag(1) as! UIImageView
            profile.layer.cornerRadius = profile.frame.width/2
            profile.layer.borderWidth = 3
            profile.layer.borderColor = UIColor(red: 31/255, green: 88/255, blue: 169/255, alpha: 1.0).cgColor
            
            if dataDic.value(forKey: "profile_photo") != nil && dataDic.value(forKey: "profile_photo") is Data
            {
                profile.image = UIImage(data: dataDic.value(forKey: "profile_photo") as! Data)
            }
            else if (dataDic.value(forKey: "profile_photo") != nil && dataDic.value(forKey: "profile_photo") is String && dataDic.value(forKey: "profile_photo") as! String != "")
            {
                profile.setImageWith(URL(string: "\(BASE_URL)\(dataDic.value(forKey: "profile_photo")!)")!, placeholderImage: #imageLiteral(resourceName: "default_profile"))
            }
            else
            {
                profile.image = #imageLiteral(resourceName: "default_profile")
            }
            
            let changePic = cell.viewWithTag(2) as! UIButton
            changePic.layer.cornerRadius = changePic.frame.width/2
        }
        else if indexPath.row == 1
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "nameCell")!
            let fname = cell.viewWithTag(1) as! UITextField
            fname.text = dataDic.value(forKey: "f_name") as? String
            let lname = cell.viewWithTag(2) as! UITextField
            lname.text = dataDic.value(forKey: "l_name") as? String
        }
        else if indexPath.row == 4
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell")!
            let submit = cell.viewWithTag(1) as! UIButton
            submit.layer.cornerRadius = 19
        }
        else if indexPath.row == 2
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "mobCell")!
            let head = cell.viewWithTag(1) as! UILabel
            let txtfld = cell.viewWithTag(2) as! UITextField
            let countryBtn = cell.viewWithTag(3) as! UIButton
            head.text = "Mobile Number"
            
            if dataDic.value(forKey: "country_code") != nil && dataDic.value(forKey: "country_code") as! String != ""
            {
                countryBtn.setTitle("+\(dataDic.value(forKey: "country_code")!)", for: .normal)
                for cons in countryBtn.constraints
                {
                    if cons.identifier == "width"
                    {
                        cons.constant = countryBtn.intrinsicContentSize.width
                    }
                }
            }
            else
            {
                 countryBtn.setTitle("+91", for: .normal)
            }
           
            if dataDic.value(forKey: "mobile_no") != nil && dataDic.value(forKey: "mobile_no") as! String != ""
            {
                txtfld.text = dataDic.value(forKey: "mobile_no") as? String
            }
            else
            {
                txtfld.text = ""
            }

            
            txtfld.isEnabled = true
            
        }
        else
        {
            cell = tableView.dequeueReusableCell(withIdentifier: "otherCell")!
            let head = cell.viewWithTag(1) as! UILabel
            let txtfld = cell.viewWithTag(2) as! UITextField
            head.text = "Email Id"
            txtfld.text = dataDic.value(forKey: "email") as? String
            txtfld.isEnabled = false
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
        let cell = tblView.cellForRow(at: indexPath!)
        
        if cell == nil
        {
            self.view.endEditing(true)
            return
        }
        
        textField.returnKeyType = .next
        textField.keyboardType = .asciiCapable
        if indexPath?.row == 1
        {
            textField.autocapitalizationType = .words
        }
        if indexPath?.row == 2
        {
            textField.keyboardType = .numberPad
            doneKeyboard(textField: textField
                , width: self.view.frame.width, height: self.view.frame.height)
        }
        else if indexPath?.row == 3
        {
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
        else if indexPath?.row == 2
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
        
        if indexPath?.row == 2
        {
            let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
            let compSepByCharInSet = string.components(separatedBy: aSet)
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            if !(string == numberFiltered)
            {
                return false
            }
        }
        
        if indexPath?.row == 1
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 30
        }
        
        if indexPath?.row == 2
        {
            let currentCharacterCount = textField.text?.characters.count ?? 0
            if (range.length + range.location > currentCharacterCount){
                return false
            }
            let newLength = currentCharacterCount + string.characters.count - range.length
            return newLength <= 14
        }
        
        return true
    }

    func cropViewController(_ controller: PECropViewController!, didFinishCroppingImage croppedImage: UIImage!) {
        let data = UIImageJPEGRepresentation(croppedImage!, 0.6)
        dataDic.setValue(data, forKey: "profile_photo")
        self.dismiss(animated: true, completion: nil)
        self.tblView.reloadData()
    }
    
    func cropViewControllerDidCancel(_ controller: PECropViewController!) {
        dataDic.setValue("", forKey: "org_profile_photo")
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = UIImage.scaleAndRotateImage(info[UIImagePickerControllerOriginalImage] as! UIImage)
        let data = UIImageJPEGRepresentation(image!, 0.6)
        dataDic.setValue(data, forKey: "org_profile_photo")
        self.dismiss(animated: true, completion: nil)
        openEditor(image: image!)
    }
    

    func openEditor(image:UIImage)
    {
        let controller = PECropViewController()
        controller.delegate = self
        controller.image = image
        controller.keepingCropAspectRatio = true
        let image: UIImage? = image
        let width: CGFloat? = image?.size.width
        let height: CGFloat? = image?.size.height
        let length: CGFloat = min(width!, height!)
        controller.imageCropRect = CGRect(x: (width! - length) / 2, y: (height! - length) / 2, width: length, height: length)
        let navigationController = UINavigationController(rootViewController: (controller as UIViewController))
        self.present(navigationController, animated: true, completion: nil)
    }
    
    
    //MARK:- button handling
    @IBAction func imageChangeBtn(_ sender: UIButton)
    {
        let action = UIAlertController(title: "Choose Option", message: "", preferredStyle: .actionSheet)
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default, handler: alertHandling)
        let gallery = UIAlertAction(title: "Gallery", style: UIAlertActionStyle.destructive, handler: alertHandling)
        
        let dismiss = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
        
        // relate actions to controllers
        action.addAction(camera)
        action.addAction(gallery)
        action.addAction(dismiss)
        
        present(action, animated: true, completion: nil)
        
    }

    func alertHandling(alert: UIAlertAction)
    {
        if alert.title == "Camera"
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.camera;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        else if alert.title == "Gallery"
        {
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func countryCodeBtn(_ sender: UIButton) {
        
        let thirdView = self.storyboard?.instantiateViewController(withIdentifier: "ListingViewController") as! ListingViewController
        thirdView.delegate = self
        thirdView.from = "country"
        self.navigationController?.pushViewController(thirdView, animated: true)
    }
    
    func list(value1: String, value2: String) {
        
        dataDic.setValue(value1, forKey: "country_code")
        self.tblView.reloadData()
    }
    
    @IBAction func submitBtn(_ sender: UIButton)
    {
         self.view.endEditing(true)
        if dataDic.value(forKey: "profile_photo") == nil
        {
            supportingfuction.showMessageHudWithMessage(message: emptyProfile, delay: 2.0)
            return
        }
        else if dataDic.value(forKey: "f_name") == nil || (dataDic.value(forKey: "f_name") as! String).trimmingCharacters(in: .whitespacesAndNewlines) == ""
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
        
        editProfile()
    }
    
    func editProfile()
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
                
                supportingfuction.hideProgressHudInView(view: self.view)
                
                supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
                
                manager.post((BASE_URL + "api/user/editprofile"), parameters: dataDic, constructingBodyWith: { (formData) in
                    
                    if self.dataDic.object(forKey: "profile_photo") is Data
                    {
                        formData.appendPart(withFileData: self.dataDic.object(forKey: "profile_photo") as! Data, name: "profile_photo", fileName: "profile_photo.jpeg", mimeType: "image/jpeg")
                    }
                    
                    if self.dataDic.object(forKey: "org_profile_photo") is Data
                    {
                        formData.appendPart(withFileData: self.dataDic.object(forKey: "org_profile_photo") as! Data, name: "org_profile_photo",    fileName: "org_profile_photo.jpeg", mimeType: "image/jpeg")
                    }
                }, progress: nil, success:
                    {
                        requestOperation, response  in
                        supportingfuction.hideProgressHudInView(view: self.view)
                        
                        var dataFromServer :NSMutableDictionary = NSMutableDictionary()
                        
                        if response is NSDictionary
                        {
                            dataFromServer = (response as! NSDictionary).mutableCopy() as! NSMutableDictionary
                            
                            if (dataFromServer.value(forKey: "status") as! String == "success")
                            {
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "profileChaged"), object: nil)
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
                                if dataFromServer.value(forKey: "action") as! String == "send_otp"
                                {
                                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "ForgotPassViewController") as! ForgotPassViewController
                                    vc.from = "otpProfile"
                                    vc.dataDic = self.dataDic
                                    _ = self.navigationController?.pushViewController(vc, animated: true)
                                }
                                else
                                {
                                    _ = self.navigationController?.popViewController(animated: true)
                                }
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
                        //print(status)
                    }
                   // print(error)
                    
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
