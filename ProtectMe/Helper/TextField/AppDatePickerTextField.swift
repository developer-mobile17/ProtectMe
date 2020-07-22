//
//  AppDatePickerTextField.swift
//  AppLocum Task
//
//  Created by Kavin Soni on 16/10/19.
//  Copyright © 2019 Kavin Soni. All rights reserved.
//

import UIKit

class AppDatePickerTextField: AIBaseTextField {
    
    
    //----------------------------------------------------------------
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }
    
    //----------------------------------------------------------------
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }
    
    
    
    func commonInit(){
        
        // Value Change Method
        self.addTarget(self, action: #selector(AppTextField.textFieldValueChangeMethod(_:)) , for: UIControl.Event.editingChanged)
        
        
        
        DispatchQueue.main.async {
            
            
            //            self.applyShadowWithColor(color: UIColor.black, opacity: 0.3, radius: 3.0, edge: .Bottom, shadowSpace: 3)
            self.shouldPreventAllActions    = true
            
            self.delegate                   = self
            self.layer.cornerRadius         = Constant.kStaticRadioOfCornerRadios
            self.layer.masksToBounds        = false
            //            self.backgroundColor            = UIColor.white
            
            self.font = UIFont (name: "HelveticaNeue", size: CGFloat(13) )!
//            self.selectedTitleColor = UIColor.themeColor
//            self.placeholderColor = UIColor.lightGray
            self.contentVerticalAlignment   = .center
            self.textColor                  = UIColor.themeBlueColor
            self.borderStyle                = .none
        }
        
    }
    
}
