//
//  MyCustomCellTableViewCell.swift
//  PKSwipeTableViewCell
//
//  Created by Pradeep Kumar Yadav on 16/04/16.
//  Copyright © 2016 iosbucket. All rights reserved.
//

import UIKit

class MyCustomCellTableViewCell: PKSwipeTableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    var price_Toshow = 0{
        didSet{
            
            let myString:NSString = "FULL REFUND   |   Get full refund on cancellation penalties.Buy FR @ only Rs. \(price_Toshow) /- per passenger." as NSString
            var myMutableString = NSMutableAttributedString()
            
            myMutableString = NSMutableAttributedString(string: myString as String, attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 10.0)!])
            myMutableString.addAttribute(NSForegroundColorAttributeName, value:  UIColor(red: 4.0/255, green: 77.0/255, blue: 127.0/255, alpha: 1.0), range: NSRange(location:0,length:11))
            
            
            let NewString = myMutableString
            
            let paragraphStyle = NSMutableParagraphStyle()
            
            paragraphStyle.lineSpacing = 4 // Whatever line spacing you want in points
            
            NewString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, NewString.length))
            
            self.lblCall2.attributedText = NewString;
            
            
            
            // set label Attribute
           // self.lblCall2.attributedText = myMutableString
        }
    }
    
    var lblCall2 = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addRightViewInCell()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(strToSet:String) {
        self.lblTitle.text = strToSet
    }
    
    func addRightViewInCell() {
        
        //Create a view that will display when user swipe the cell in right
        let viewCall = UIView()
        viewCall.backgroundColor = UIColor(red: 239/255, green: 239/255, blue: 239/255, alpha: 1.0)
        viewCall.frame = CGRect(x: 0, y: 0, width: (self.frame.size.width)/2 + 60, height: (self.frame.height) - 20)
        //Add a label to display the call text
        let lblCall = UILabel()
        lblCall.frame = CGRect(x: 10, y: self.frame.height + 20, width: (viewCall.frame.size.width) - 20, height: 20)
         lblCall.textAlignment = NSTextAlignment.left
        lblCall.text  = "Free Meal"
        lblCall.font = UIFont.systemFont(ofSize: 10.0)
        lblCall.backgroundColor = UIColor.clear
        lblCall.textColor = UIColor.red
        lblCall.backgroundColor = UIColor.green
        
        lblCall2 = UILabel()
        lblCall2.frame = CGRect(x: 10, y: 15, width: (viewCall.frame.size.width) - 20, height: (viewCall.frame.size.height) - 25)
        lblCall2.textAlignment = NSTextAlignment.left
        
        lblCall2.backgroundColor = UIColor.clear
        lblCall2.numberOfLines = 4
lblCall2.backgroundColor = UIColor.yellow
        viewCall.addSubview(lblCall)
        viewCall.addSubview(lblCall2)
        //Call the super addRightOptions to set the view that will display while swiping
        super.addRightOptionsView(view: viewCall)
    }
    
    
    func callButtonClicked(){
        //Reset the cell state and close the swipe action
        self.resetCellState()
    }

}
