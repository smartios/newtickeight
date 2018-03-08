//
//  SortViewController.swift
//  Tick8
//
//  Created by singsys on 19/9/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

protocol Sort {
    func sorting(value1:NSDictionary)
}

class SortViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var departbtn: UIButton!
    @IBOutlet weak var returnBtn: UIButton!
    var delegate: Sort!
    var from = ""
    let dataDic:NSMutableDictionary = NSMutableDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if from == "single"
        {
            returnBtn.isHidden = true
            departbtn.isSelected = true
        }
        else
        {
            returnBtn.isHidden = false
            departbtn.isHidden = false
            departbtn.isSelected = true
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }

    //MARK:- tableview functions
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var num:Int = 0
        
        if section == 0 || section == 3
        {
            num = 3
        }
        else if section == 1 || section == 2
        {
            num = 4
        }
        
        return num
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
      
//        if indexPath.row == 0
//        {
//            return 35
//        }
//        else

        if ((indexPath.section == 0 || indexPath.section == 3) && indexPath.row == 2) || (indexPath.section == 1 || indexPath.section == 2) && indexPath.row == 3
        {
            return 10
        }
        else
        {
            return 35
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        
        if indexPath.section == 0
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingView")!
                let label = cell.viewWithTag(1) as! UILabel
                label.text = "Price"
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "valueView")!
                let label = cell.viewWithTag(1) as! UILabel
                let btn = cell.viewWithTag(2) as! UIButton
                btn.isUserInteractionEnabled = false
                label.text = "Lowest First"
                
                if from == "single"
                {
                    if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "1"
                    {
                        label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                        btn.isSelected = true
                    }
                    else
                    {
                        label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                        btn.isSelected = false
                    }
                }
                else
                {
                    if departbtn.isSelected == true
                    {
                        if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "1"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else if returnBtn.isSelected == true
                    {
                        if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "1"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                }
            }
        }
        else if indexPath.section == 1
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingView")!
                let label = cell.viewWithTag(1) as! UILabel
                label.text = "Departure Time"
            }
            else if indexPath.row == 3
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "valueView")!
                let label = cell.viewWithTag(1) as! UILabel
                let btn = cell.viewWithTag(2) as! UIButton
                btn.isUserInteractionEnabled = false
                
                if indexPath.row == 1
                {
                    label.text = "Earliest First"
                    
                    if from == "single"
                    {
                        if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "2"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else
                    {
                        if departbtn.isSelected == true
                        {
                            if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "2"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                        else if returnBtn.isSelected == true
                        {
                            if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "2"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                    }

                }
                else if indexPath.row == 2
                {
                    label.text = "Later First"
                    
                    if from == "single"
                    {
                        if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "3"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else
                    {
                        if departbtn.isSelected == true
                        {
                            if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "3"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                        else if returnBtn.isSelected == true
                        {
                            if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "3"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                    }
                }
            }
        }
        else if indexPath.section == 2
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingView")!
                let label = cell.viewWithTag(1) as! UILabel
                label.text = "Arrival Time"
            }
            else if indexPath.row == 3
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "valueView")!
                let label = cell.viewWithTag(1) as! UILabel
                let btn = cell.viewWithTag(2) as! UIButton
                btn.isUserInteractionEnabled = false
                
                if indexPath.row == 1
                {
                    label.text = "Earliest First"
                    if from == "single"
                    {
                        if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "4"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else
                    {
                        if departbtn.isSelected == true
                        {
                            if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "4"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                        else if returnBtn.isSelected == true
                        {
                            if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "4"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                    }
                }
                else if indexPath.row == 2
                {
                    label.text = "Later First"
                    if from == "single"
                    {
                        if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "5"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else
                    {
                        if departbtn.isSelected == true
                        {
                            if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "5"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                        else if returnBtn.isSelected == true
                        {
                            if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "5"
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                                btn.isSelected = true
                            }
                            else
                            {
                                label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                                btn.isSelected = false
                            }
                        }
                    }
                }
            }
        }
        if indexPath.section == 3
        {
            if indexPath.row == 0
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "headingView")!
                let label = cell.viewWithTag(1) as! UILabel
                label.text = "Duration"
            }
            else if indexPath.row == 2
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "imageCell")!
            }
            else
            {
                cell = tableView.dequeueReusableCell(withIdentifier: "valueView")!
                let label = cell.viewWithTag(1) as! UILabel
                let btn = cell.viewWithTag(2) as! UIButton
                btn.isUserInteractionEnabled = false
                label.text = "Shortest First"
                
                if from == "single"
                {
                    if dataDic.value(forKey: "select") != nil && dataDic.value(forKey: "select") as! String == "6"
                    {
                        label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                        btn.isSelected = true
                    }
                    else
                    {
                        label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                        btn.isSelected = false
                    }
                }
                else
                {
                    if departbtn.isSelected == true
                    {
                        if dataDic.value(forKey: "dSelect") != nil && dataDic.value(forKey: "dSelect") as! String == "6"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                    else if returnBtn.isSelected == true
                    {
                        if dataDic.value(forKey: "aSelect") != nil && dataDic.value(forKey: "aSelect") as! String == "6"
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "266eb8")
                            btn.isSelected = true
                        }
                        else
                        {
                            label.textColor = supportingfuction.hexStringToUIColor(hex: "acacac")
                            btn.isSelected = false
                        }
                    }
                }
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        if from == "single"
        {
            if indexPath.section == 0 && indexPath.row == 1
            {
                dataDic.setValue("1", forKey: "select")
            }
            else if indexPath.section == 1 && indexPath.row == 1
            {
                dataDic.setValue("2", forKey: "select")
            }
            else if indexPath.section == 1 && indexPath.row == 2
            {
                dataDic.setValue("3", forKey: "select")
            }
            else if indexPath.section == 2 && indexPath.row == 1
            {
                dataDic.setValue("4", forKey: "select")
            }
            else if indexPath.section == 2 && indexPath.row == 2
            {
                dataDic.setValue("5", forKey: "select")
            }
            else if indexPath.section == 3 && indexPath.row == 1
            {
                dataDic.setValue("6", forKey: "select")
            }
        }
        else
        {
            if departbtn.isSelected == true
            {
                if indexPath.section == 0 && indexPath.row == 1
                {
                    dataDic.setValue("1", forKey: "dSelect")
                }
                else if indexPath.section == 1 && indexPath.row == 1
                {
                    dataDic.setValue("2", forKey: "dSelect")
                }
                else if indexPath.section == 1 && indexPath.row == 2
                {
                    dataDic.setValue("3", forKey: "dSelect")
                }
                else if indexPath.section == 2 && indexPath.row == 1
                {
                    dataDic.setValue("4", forKey: "dSelect")
                }
                else if indexPath.section == 2 && indexPath.row == 2
                {
                    dataDic.setValue("5", forKey: "dSelect")
                }
                else if indexPath.section == 3 && indexPath.row == 1
                {
                    dataDic.setValue("6", forKey: "dSelect")
                }
            }
            else
            {
                if indexPath.section == 0 && indexPath.row == 1
                {
                    dataDic.setValue("1", forKey: "aSelect")
                }
                else if indexPath.section == 1 && indexPath.row == 1
                {
                    dataDic.setValue("2", forKey: "aSelect")
                }
                else if indexPath.section == 1 && indexPath.row == 2
                {
                    dataDic.setValue("3", forKey: "aSelect")
                }
                else if indexPath.section == 2 && indexPath.row == 1
                {
                    dataDic.setValue("4", forKey: "aSelect")
                }
                else if indexPath.section == 2 && indexPath.row == 2
                {
                    dataDic.setValue("5", forKey: "aSelect")
                }
                else if indexPath.section == 3 && indexPath.row == 1
                {
                    dataDic.setValue("6", forKey: "aSelect")
                }
            }
        }
        self.tblView.reloadData()
    }
     //MARK:- button functions
   
//     @IBAction func selectBtn(_ sender: UIButton) {
//        let hit = sender.convert(CGPoint.zero, to: self.tblView)
//        let indexPath = self.tblView.indexPathForRow(at: hit)
//       // let cell = tblView.cellForRow(at: indexPath!)
//        
//        if from == "single"
//        {
//            if indexPath!.section == 0 && indexPath!.row == 1
//            {
//                dataDic.setValue("1", forKey: "select")
//            }
//            else if indexPath!.section == 1 && indexPath!.row == 1
//            {
//                dataDic.setValue("2", forKey: "select")
//            }
//            else if indexPath!.section == 1 && indexPath!.row == 2
//            {
//                dataDic.setValue("3", forKey: "select")
//            }
//            else if indexPath!.section == 2 && indexPath!.row == 1
//            {
//                dataDic.setValue("4", forKey: "select")
//            }
//            else if indexPath!.section == 2 && indexPath!.row == 2
//            {
//                dataDic.setValue("5", forKey: "select")
//            }
//            else if indexPath!.section == 3 && indexPath!.row == 1
//            {
//                dataDic.setValue("6", forKey: "select")
//            }
//        }
//        else
//        {
//            if departbtn.isSelected == true
//            {
//                if indexPath!.section == 0 && indexPath!.row == 1
//                {
//                    dataDic.setValue("1", forKey: "dSelect")
//                }
//                else if indexPath!.section == 1 && indexPath!.row == 1
//                {
//                    dataDic.setValue("2", forKey: "dSelect")
//                }
//                else if indexPath!.section == 1 && indexPath!.row == 2
//                {
//                    dataDic.setValue("3", forKey: "dSelect")
//                }
//                else if indexPath!.section == 2 && indexPath!.row == 1
//                {
//                    dataDic.setValue("4", forKey: "dSelect")
//                }
//                else if indexPath!.section == 2 && indexPath!.row == 2
//                {
//                    dataDic.setValue("5", forKey: "dSelect")
//                }
//                else if indexPath!.section == 3 && indexPath!.row == 1
//                {
//                    dataDic.setValue("6", forKey: "dSelect")
//                }
//            }
//            else
//            {
//                if indexPath!.section == 0 && indexPath!.row == 1
//                {
//                    dataDic.setValue("1", forKey: "aSelect")
//                }
//                else if indexPath!.section == 1 && indexPath!.row == 1
//                {
//                    dataDic.setValue("2", forKey: "aSelect")
//                }
//                else if indexPath!.section == 1 && indexPath!.row == 2
//                {
//                    dataDic.setValue("3", forKey: "aSelect")
//                }
//                else if indexPath!.section == 2 && indexPath!.row == 1
//                {
//                    dataDic.setValue("4", forKey: "aSelect")
//                }
//                else if indexPath!.section == 2 && indexPath!.row == 2
//                {
//                    dataDic.setValue("5", forKey: "aSelect")
//                }
//                else if indexPath!.section == 3 && indexPath!.row == 1
//                {
//                    dataDic.setValue("6", forKey: "aSelect")
//                }
//            }
//        }
//        self.tblView.reloadData()
//    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        delegate.sorting(value1: dataDic)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func depOrReturnBtn(_ sender: UIButton) {
       
        if sender.tag == 1
        {
            sender.isSelected = true
            returnBtn.isSelected = false
        }
        else
        {
            sender.isSelected = true
            departbtn.isSelected = false
        }
        self.tblView.reloadData()
    }
    
}
