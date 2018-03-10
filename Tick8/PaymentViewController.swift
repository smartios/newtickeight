//
//  PaymentViewController.swift
//  Tick8
//
//  Created by singsys on 18/10/17.
//  Copyright © 2017 singsys. All rights reserved.
//

import UIKit
import WebKit

class PaymentViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var progressBar: UIProgressView!
    var url = ""
    var jump = false
    var dataDic = NSMutableDictionary()
    var from = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.loadRequest(URLRequest(url: URL(string: url)!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        webView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        webView.delegate = nil
        webView.loadRequest(URLRequest(url: URL(string: "Google.com")!))
    }

    func webViewDidStartLoad(_ webView: UIWebView) {
        self.progressBar.setProgress(0.1, animated: false)
    }
    
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.progressBar.setProgress(1.0, animated: true)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        print(request.url?.absoluteString)
        
        if request.url?.absoluteString == "\(BASE_URL)booking-success" || request.url?.absoluteString == "\(BASE_URL)booking-fail" || request.url?.absoluteString == "\(BASE_URL)payment-failed"
        {
            jumpToHome(r: request)
        }
        return true
    }
 
    func jumpToHome(r: URLRequest)
    {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            // Put your code which should be executed with a delay here
             self.url = ""
            if self.jump == true
            {
                return
            }
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "SuccessViewController") as! SuccessViewController
            self.jump = true
            vc.from = self.from
            vc.dataDic = self.dataDic
            if r.url?.absoluteString == "\(BASE_URL)booking-success"
            {
                supportingfuction.showMessageHudWithMessage(message: "Your booking is successful", delay: 2.0)
                vc.success = "success"
            }
            else if r.url?.absoluteString == "\(BASE_URL)booking-fail"
            {
                supportingfuction.showMessageHudWithMessage(message: "Your booking is unsuccessful", delay: 2.0)
                vc.success = "fail"
            }
            else if r.url?.absoluteString == "\(BASE_URL)payment-failed"
            {
                supportingfuction.showMessageHudWithMessage(message: "Your booking is cancelled.", delay: 2.0)
                vc.success = "cancel"
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        })
    }
    
}
