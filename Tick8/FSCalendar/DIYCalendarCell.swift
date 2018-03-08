//
//  DIYCalendarCell.swift
//  FSCalendarSwiftExample
//
//  Created by dingwenchao on 06/11/2016.
//  Copyright © 2016 wenchao. All rights reserved.
//

import Foundation

import UIKit

enum SelectionType : Int {
    case none
    case single
    case leftBorder
    case middle
    case rightBorder
}


class DIYCalendarCell: FSCalendarCell {
    
    weak var circleImageView: UIImageView!
    weak var selectionLayer: CAShapeLayer!
    weak var leftCA: CAShapeLayer!
    weak var rightCA: CAShapeLayer!

    var selectionType: SelectionType = .none {
        didSet {
            setNeedsLayout()
        }
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let selectionLayer = CAShapeLayer()
        selectionLayer.fillColor = UIColor.lightGray.cgColor
        selectionLayer.actions = ["hidden": NSNull()]
        self.contentView.layer.insertSublayer(selectionLayer, below: self.titleLabel!.layer)
        
        let backCA = CAShapeLayer()
        backCA.fillColor = UIColor.clear.cgColor
        backCA.actions = ["hidden": NSNull()]
        leftCA = backCA
    
        self.contentView.layer.insertSublayer(leftCA, below: self.selectionLayer)

        let rightbackCA = CAShapeLayer()
        rightbackCA.fillColor = UIColor.clear.cgColor
        rightbackCA.actions = ["hidden": NSNull()]
        rightCA = rightbackCA
        
        self.contentView.layer.insertSublayer(rightCA, below: self.selectionLayer)
        
        self.selectionLayer = selectionLayer

        self.leftCA.isHidden = true
        self.rightCA.isHidden = true
        self.shapeLayer.isHidden = true
        
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.clear
        self.backgroundView = view
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.backgroundView?.frame = self.bounds.insetBy(dx: 1, dy: 1)
        self.selectionLayer.frame = CGRect(x: 0, y: 4, width: self.contentView.frame.width, height: 25)
        
        if selectionType == .middle
        {
            self.selectionLayer.path = UIBezierPath(rect: self.selectionLayer.bounds).cgPath
            self.selectionLayer.backgroundColor = UIColor.init(red: 245 / 256, green: 250 / 256, blue: 254 / 256, alpha: 1.0).cgColor
            self.selectionLayer.fillColor = UIColor.clear.cgColor
            self.selectionLayer.frame = CGRect(x: 0, y:9, width: self.contentView.frame.width, height: 22)
            self.leftCA.isHidden = true
            self.rightCA.isHidden = true
        }
        else if selectionType == .leftBorder
        {
            //max(self.contentView.frame.height, self.contentView.frame.width)
            let diameter: CGFloat = 41
            self.selectionLayer.path = UIBezierPath( ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2 + 9, y: self.contentView.frame.height / 2 - diameter / 2 + 6, width: diameter - 18, height: diameter - 18)).cgPath
            
            self.selectionLayer.frame = CGRect(x: 0, y: 4, width: self.contentView.frame.width, height: 25)
            selectionLayer.fillColor = UIColor.init(red: 31 / 256, green: 88 / 256, blue: 169 / 256, alpha: 1.0).cgColor
            selectionLayer.backgroundColor = UIColor.clear.cgColor
            self.leftCA.frame = CGRect(x: self.contentView.frame.width/2, y: 9, width: self.contentView.frame.width/2, height: 22)
            self.leftCA.backgroundColor = UIColor.init(red: 245 / 256, green: 250 / 256, blue: 254 / 256, alpha: 1.0).cgColor
            rightCA.backgroundColor = UIColor.clear.cgColor
        }
        else if selectionType == .rightBorder
        {
            //max(self.contentView.frame.height, self.contentView.frame.width)
            let diameter: CGFloat = 41
            self.selectionLayer.path = UIBezierPath( ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2 + 9, y: self.contentView.frame.height / 2 - diameter / 2 + 6, width: diameter - 18, height: diameter - 18)).cgPath
        
            self.rightCA.frame = CGRect(x: 0, y: 9, width: self.contentView.frame.width/2, height: 22)
            self.rightCA.backgroundColor = UIColor.init(red: 245 / 256, green: 250 / 256, blue: 254 / 256, alpha: 1.0).cgColor
            leftCA.backgroundColor = UIColor.clear.cgColor
            selectionLayer.fillColor = UIColor.init(red: 31 / 256, green: 88 / 256, blue: 169 / 256, alpha: 1.0).cgColor
            selectionLayer.backgroundColor = UIColor.clear.cgColor
        }
        else if selectionType == .single
        {
            self.leftCA.isHidden = true
            self.rightCA.isHidden = true
//max(self.contentView.frame.height, self.contentView.frame.width)
            let diameter: CGFloat = 41
            self.selectionLayer.path = UIBezierPath( ovalIn: CGRect(x: self.contentView.frame.width / 2 - diameter / 2 + 9, y: self.contentView.frame.height / 2 - diameter / 2 + 6, width: diameter - 18, height: diameter - 18)).cgPath
            selectionLayer.fillColor = UIColor.init(red: 31 / 256, green: 88 / 256, blue: 169 / 256, alpha: 1.0).cgColor
            selectionLayer.backgroundColor = UIColor.white.cgColor

        }
    }
    
    override func configureAppearance() {
        super.configureAppearance()
        // Override the build-in appearance configuration
        if self.isPlaceholder {
            self.eventIndicator.isHidden = true
            self.titleLabel.textColor = UIColor.lightGray
        }
    }
    
}
