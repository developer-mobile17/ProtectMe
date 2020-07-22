//
//  AppTextField.swift
//  AppLocum Task
//
//  Created by Kavin Soni on 15/10/19.
//  Copyright © 2019 Kavin Soni. All rights reserved.
//

import UIKit




enum Direction {
    case Left
    case Right
    case Both
    case None
}


enum PickerType : Int {
    case monthYear, genricPicker, defaultPicker
}

//MARK:- TEXTFIELD TYPE -- For Picker Only
enum AITextFieldType: Int{
    case
    MonthYear,
    none
}

struct PickerDataModel {
    var key:Any
    var value:String
    var isSelected:Bool
}

class AppTextField: AIFloatingLabelTextField {


    //MARK:- Public Vars
    var selectedImage:UIImage?
    var unselectedImage:UIImage?
    var imageView:UIImageView?
    var direction:Direction = .Left
    var paddingForRect:UIEdgeInsets = UIEdgeInsets(top:10, left: GET_PROPORTIONAL_HEIGHT_ACCORDING_WIDTH(height: 0), bottom: 0, right: 0);

    var blockShouldChangeCharactersIn:((_ textField: UITextField,_ range: NSRange,_ string: String) -> Bool)?

    var textFieldValueChangeNotification:((_ newValue:Any?)->())?
    var maxCharacterLimit:NSInteger = 50

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



    //-----------------------------------------------------------
    //MARK:- TextFeild Delegets -
    override func textFieldDidEndEditing(_ textField: UITextField) {

    }

    //----------------------------------------------------------------

    override func textFieldDidBeginEditing(_ textField: UITextField) {

    }

    //----------------------------------------------------------------




    //----------------------------------------------------------------



}
extension AppTextField{

    // Send Notification From Anywhere Using this Method
    fileprivate func sendValueChangeNotification(_ value:String?) -> ()
    {
        if let valueChangeNotificationValue = textFieldValueChangeNotification
        {
            valueChangeNotificationValue(value)
        }
    }

    @objc func textFieldValueChangeMethod(_ sender:UITextField) -> Void {
        self.sendValueChangeNotification(sender.text)
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
            self.selectedTitleColor = UIColor.themeBlueColor
            self.placeholderColor = UIColor.lightGray
            self.contentVerticalAlignment   = .center
            self.textColor                  = UIColor.themeBlueColor
            self.borderStyle                = .none
        }

    }
    func updateFont(){
        DispatchQueue.main.async {
            self.font = UIFont (name: "HelveticaNeue", size: CGFloat(13) )!
        }
    }
    //----------------------------------------------------------------

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingForRect)
    }

    //----------------------------------------------------------------

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: paddingForRect)

    }
    //----------------------------------------------------------------
    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        return bounds.inset(by: paddingForRect)

    }

    //----------------------------------------------------------------
    /*
     func textFieldDidBeginEditing(_ textField: UITextField) {
     if let tempImage = self.selectedImage {
     if self.imageView != nil {
     self.imageView?.image = tempImage

     }
     }
     }
     //----------------------------------------------------------------

     func textFieldDidEndEditing(_ textField: UITextField) {
     if let tempImage = self.unselectedImage {
     if self.imageView != nil {
     self.imageView?.image = tempImage

     }
     }
     }

     //----------------------------------------------------------------

     func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
     if self.blockShouldChangeCharactersIn != nil {
     return  self.blockShouldChangeCharactersIn!(textField,range,string)
     } else {
     return true
     }

     }
     */
    //----------------------------------------------------------------

    func setPlaceholderColor() {


        if(self.placeholder != nil ){
            DispatchQueue.main.async {

                    let arrtibutes = [
                NSAttributedString.Key.foregroundColor:UIColor.lightGray,
                        NSAttributedString.Key.font:UIFont (name: "HelveticaNeue", size:CGFloat(13))
                    ]
                    self.attributedPlaceholder = NSAttributedString(
                        string:self.placeholder!,
                        attributes:arrtibutes)

            }
        }

    }
}



