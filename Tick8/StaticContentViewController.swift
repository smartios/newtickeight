//
//  StaticContentViewController.swift
//  Tick8
//
//  Created by singsys on 21/8/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit

class StaticContentViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var headerLbl:UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var progressive: UIProgressView!
    var headerString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLbl.text = headerString
        backBtn.setImage(#imageLiteral(resourceName: "sidemenu"), for: .normal)
        
        if headerString == "About Us"
        {
             webView.loadRequest(URLRequest(url: URL(string: "\(BASE_URL)api/aboutus")!))
        }
        else if headerString == "Privacy Policy"
        {
            webView.loadRequest(URLRequest(url: URL(string: "\(BASE_URL)api/privacypolicy")!))
        }
        else if headerString == "Terms & Condition"
        {
            backBtn.setImage(#imageLiteral(resourceName: "whiteLeftArrow"), for: .normal)
            webView.loadRequest(URLRequest(url: URL(string: "\(BASE_URL)api/terms-conditions")!))
        }
       
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
    
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        webView.scrollView.bounces = true
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.showsVerticalScrollIndicator = false
        self.progressive.setProgress(0.1, animated: false)
        
//        if headerString == "About Us"
//        {
//            progressive.frame = CGRect(x: 0, y: 65, width: self.view.frame.width, height: self.view.frame.height-141)
//            webView.frame = CGRect(x: 0, y: 142, width: self.view.frame.width, height: self.view.frame.height-143)
//        }
//        else if headerString == "Privacy Policy" && headerString == "Terms & Condition"
//        {
//            progressive.frame = CGRect(x: 0, y: 65, width: self.view.frame.width, height: self.view.frame.height-65)
//            webView.frame = CGRect(x: 0, y: 67, width: self.view.frame.width, height: self.view.frame.height-67)
//        }

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
     self.progressive.setProgress(1.0, animated: true)
    }
    
    @IBAction func sideMenuBtn(_ sender: UIButton) {
        
        if headerString == "Terms & Condition"
        {
            _ = self.navigationController?.popViewController(animated: true)
        }
        else
        {
            sideMenuViewController?._presentLeftMenuViewController()
        }
    }
}
