//
//  FareRulesViewController.swift
//  Tick8
//
//  Created by singsys on 27/9/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class FareRulesViewController: UIViewController, UIWebViewDelegate {
    
    @IBOutlet weak var ruleView:UITextView!
    @IBOutlet weak var depart:UIButton!
    @IBOutlet weak var returnbtn:UIButton!
    var dataDic = NSMutableDictionary()
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setvalues()
    }
    
    override func viewDidAppear(_ animated: Bool) {
      // ruleView.scrollRangeToVisible(NSMakeRange(0, 0))
       
        
       //ruleView.contentInset.top = 0
    }

    func setvalues()
    {
        supportingfuction.showProgressHudForViewMy(view: self.view, withDetailsLabel: "", labelText: "Please Wait...")
        ruleView.isHidden = true
        if from == "single"
        {
            depart.isHidden = false
            depart.isSelected = true
            returnbtn.isHidden = true
            ruleView.attributedText = dataDic.value(forKey: "fareRule") as! NSAttributedString
        }
        else
        {
            depart.isHidden = false
            depart.isSelected = true
            returnbtn.isHidden = false
            ruleView.attributedText = dataDic.value(forKey: "fareRule") as! NSAttributedString
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
            self.ruleView.setContentOffset(.zero, animated: false)
            supportingfuction.hideProgressHudInView(view: self.view)
            self.ruleView.isHidden = false
        })
        
    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtn(_ sender: UIButton) {
        _ = self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deaprtBtn(_ sender: UIButton)
    {
        sender.isSelected = true
        returnbtn.isSelected = false
        ruleView.attributedText = dataDic.value(forKey: "fareRule") as! NSAttributedString
        self.ruleView.setContentOffset(.zero, animated: false)
    }
    
    @IBAction func returnBtn(_ sender: UIButton)
    {
        depart.isSelected = false
        sender.isSelected = true
        ruleView.attributedText = dataDic.value(forKey: "fareRule1") as! NSAttributedString
        self.ruleView.setContentOffset(.zero, animated: false)
    }
}
