//
//  Global.swift
//  SpiritVibe
//
//  Created by Mac on 26/12/19.
//  Copyright © 2019 Mac. All rights reserved.
//

//
//  Globel.swift
//  Dailies Task
//
//  Created by Malav's iMac on 9/13/19.
//  Copyright © 2019 agileimac-7. All rights reserved.
//

import Foundation
import UIKit

//import SVProgressHUD
//import Uneri


//import AIReachabilityManager

struct AppUrl {
    static let  customURLSchemeForDynamicLink: String = ""
    static let  applicationDomainUrl: String          = ""
}

struct Device {
    static let bundleIdentifier              = ""
    static let androidBundleIdentifier       = ""
    static let appStoreID                    = "" //Set Appstore Id
}

struct Messages {
    static let inviteShareText = "Accept invitation which I sent you"
}



//MARK:- INTERNET CHECK -
func IS_INTERNET_AVAILABLE() -> Bool{
    return AIReachabilityManager.shared.isInternetAvailableForAllNetworks()
}


func LOADER(isShow:Bool){
    
    if isShow {
        
        DispatchQueue.main.async {
//            SVProgressHUD.setForegroundColor(UIColor.themeColor)
//            SVProgressHUD.setBackgroundColor(UIColor.lightGray.withAlphaComponent(0.3))
//            SVProgressHUD.show()
        }
        
    } else {
        DispatchQueue.main.async {
//            SVProgressHUD.dismiss()
        }
    }
}


struct Constant {
    
    //----------------------------------------------------------------
    //MARK:- KEY CONST -
    static let kStaticRadioOfCornerRadios:CGFloat = 25
    static let ALERT_OK                = "OK"
    static let ALERT_DISMISS           = "Dismiss"
    static let KEY_IS_USER_LOGGED_IN   = "USER_LOGGED_IN"
    
    
    
    static var APP_NAME:String {
        
        if let bundalDicrectory = Bundle.main.infoDictionary{
            return  bundalDicrectory[kCFBundleNameKey as String] as! String
        } else {
            return "ProtectMe"
        }
        
    }
    
}


struct AlertMessage {
  //login/register
    static let  DeleteAddressMessage: String = "Are You sure, you want to delete address?"
    static let  logoutMessage: String =  "Are you sure you want to logout?"
    static let  NameMissing: String =  "Please enter name."
    static let  FileNameMissing: String =  "Please enter file name."

    static let  EmailNameMissing: String = "Please enter email."
    static let  UserNameMissing: String = "Please enter name."
    static let  DOBMissing: String = "Please select DOB."
    static let  ProfilePictureMissing: String = "Please upload profile picture."
    static let  LoginToContinue: String = "Please login to continue."

    
    static let  OLDEmailNameMissing: String = "Please enter currunt email."
    static let  NEWEmailNameMissing: String = "Please enter new email."

    

    static let  ValidEmail: String = "Please enter valid email."
    static let  MobileMissing : String           = "Please enter mobile no."
    static let  DifferentMobileMissing : String           = "Please enter different mobile no."

    static let  CommentMissing : String           = "Please enter comment."
    static let  CreatePasswordMissing: String = "Please enter create password."
    static let  PasswordMissing: String = "Please enter password."
    static let  OldpasswordMissing: String = "Please enter old password."
    static let  NewpasswordMissing: String = "Please enter new password."
    static let  ConfirmPasswordMissing: String = "Please enter confirm password."
    static let  PasswordMin6DigitMissing: String = "Password must be contain 6 digits."
    static let  CreatePasswordMin6DigitMissing: String = "Create Password must be contain 6 digits."
    static let  PasswordNotMatch: String = "Password doesn't match!"
    
    //Add Address
    static let  HouseNoMissing: String =  "Please enter house/ flat/ block no."
    static let  LandmarkMissing: String =  "Please enter landmark."

    
    
    static let  noInternetConnection : String = "Please check your internet connection."
    //card
    static let  CardHolderNameMissing : String = "Please enter cardholder name."
    static let  CardHolderNumberMissing : String = "Please enter card number."
    static let  CardMonthYearMissing : String = "Please enter card month/year."
    static let  CardCVVMissing : String = "Please enter cvv number."





    //form 1
    static let  AvailableDateMissing : String   = "Please select available date."
    static let  ContactMissing : String         = "Please enter contact."
    static let  DueDatesMissing : String        = "Please enter due date."
    static let  AddressMissing : String         = "Please enter address."
    static let  TeamMissing : String            = "Please select team."
    static let  ColorMissing : String           = "Please enter color name."
    static let  DevisionMissing : String        = "Please enter division/level."
    static let  MascotMissing : String          = "Please enter mascot."
    
    //verification
    

    static let  PinMissing: String =  "Please enter pin!"
    static let  IncorrectPin: String =  "Please enter correct pin!"
    



}



//Set animation

//func setAnimationToView(view:UIView , height:CGFloat) -> Void {
//    let oceanHeight = CGFloat(height)
//    let frame = CGRect(x: 0, y: view.frame.size.height - oceanHeight, width: view.frame.size.width, height: oceanHeight)
//
//    // with default colors
//    let uneri0 = Uneri(frame: frame)
//
//    // with custom colors
//    let uneri1 = Uneri(frame: frame, mainColor: .orange, subColor: .purple)
//
//    // width custom gradient colors
//    let uneri2 = Uneri(frame: frame, mainGradientColors: [.orange, .purple], subGradientColors: [.purple, .purple])
//
//    // the uneri automatically starts
//    view.addSubview(uneri0)
//}

class LblRound: UILabel {
    override func awakeFromNib() {
        SetCornerRadious(self)
        self.clipsToBounds = true
    }
    func SetCornerRadious(_ view : UILabel)
    {
        view.layer.cornerRadius = (view.layer.frame.size.height)/2
        view.layer.masksToBounds = true
    }

}
class playerUISlider: UISlider {
    override func awakeFromNib() {
        self.backgroundColor = UIColor(red: 0.82, green: 0.202, blue: 0.237, alpha: 0.5)
        self.tintColor = UIColor.ThemeRedColor
        self.thumbTintColor = UIColor.Themegradiant2
     //   self.thumbRect(forBounds: , trackRect: <#T##CGRect#>, value: <#T##Float#>)
//        self.layer.ima
    }
    let coinEnd = UIImage().resizableImage(withCapInsets:
        UIEdgeInsets(top: 0,left: 7,bottom: 0,right: 7), resizingMode: .stretch)

    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        var result = super.trackRect(forBounds: bounds)
        result.origin.x = 0
        result.size.width = bounds.size.width
        result.size.height = bounds.size.height-15 //added height for desired effect
        return result
    }

    override func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        return super.thumbRect(forBounds:
            bounds, trackRect: rect, value: value)
            .offsetBy(dx: 0/*Set_0_value_to_center_thumb*/, dy: 0)
    }
//    override func trackRect(forBounds bounds: CGRect) -> CGRect {
//        let point = CGPoint(x: bounds.minX, y: bounds.midY)
//        return CGRect(origin: point, size: CGSize(width: bounds.width, height: 12))
//    }
    
}
class ViewCellBorder: UIView {
    override func awakeFromNib() {
        self.layer.borderWidth = 1
            self.layer.borderColor = UIColor.init(displayP3Red: 18, green: 146, blue: 183, alpha: 0.16).cgColor
        
        SetCornerRadious(self)
        self.clipsToBounds = true
        }
    func SetCornerRadious(_ view : UIView)
    {
            view.layer.cornerRadius = 11
            view.layer.masksToBounds = true
    }

}

class BtnSubmitREDRounded: UIButton {
    private var shadowLayer: CAShapeLayer!
  
    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
             //self.layer.cornerRadius = 6.0
            self.layer.shadowColor = UIColor.ThemeRedColor.cgColor
             self.layer.shadowRadius = 7
             self.layer.shadowOffset = CGSize(width: 2, height: 3)
             self.layer.shadowOpacity = 0.7
            self.layer.backgroundColor = UIColor.ThemeRedColor.cgColor
            self.layer.cornerRadius = self.layer.frame.size.height/2
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
   
}

class BtnSubmitBlue: UIButton {
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
         

             self.layer.cornerRadius = 6.0
            //button.layer.masksToBounds = true
            self.layer.shadowColor = UIColor.ThemeRedColor.cgColor
             self.layer.shadowRadius = 7
             self.layer.shadowOffset = CGSize(width: 2, height: 3)
             self.layer.shadowOpacity = 0.7
            //button.backgroundColor = UIColor.greenColor()
            self.layer.backgroundColor = UIColor.ThemeRedColor.cgColor
            self.layer.cornerRadius = self.layer.frame.size.height/2
            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}
class cricleImage:UIImageView{
    override func layoutSubviews() {
    super.layoutSubviews()
        self.layer.cornerRadius = self.layer.frame.size.height/2
        
        
}

class BtnSubmit: UIButton {
    private var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer == nil {
            //shadowLayer = CAShapeLayer()
            //shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 6).cgPath
           // shadowLayer.fillColor = UIColor.themeBlueColor.cgColor
           // shadowLayer.shadowColor = UIColor.themeBlueColor.cgColor
           // shadowLayer.shadowPath = shadowLayer.path
         //   shadowLayer.shadowOffset = CGSize(width: 0, height: 3.0)
         //   shadowLayer.shadowOpacity = 0.7
          //  shadowLayer.shadowRadius = 7

           // layer.insertSublayer(shadowLayer, at: 0)

             self.layer.cornerRadius = 6.0
            //button.layer.masksToBounds = true
            self.layer.shadowColor = UIColor.ThemeRedColor.cgColor
             self.layer.shadowRadius = 7
             self.layer.shadowOffset = CGSize(width: 2, height: 3)
             self.layer.shadowOpacity = 0.7
            //button.backgroundColor = UIColor.greenColor()
            self.layer.backgroundColor = UIColor.ThemeRedColor.cgColor

            //layer.insertSublayer(shadowLayer, below: nil) // also works
        }
    }
}

class DashedButton: UIButton {

    var dashedLine: CAShapeLayer!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        dashedLine             = CAShapeLayer()
        dashedLine.strokeColor = UIColor.white.cgColor
        dashedLine.lineWidth   = 4
        layer.addSublayer(dashedLine)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        dashedLine.lineDashPattern = [12, 7]
        dashedLine.path = path.cgPath
    }
    
    }

}
