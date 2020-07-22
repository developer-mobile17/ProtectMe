//
//  AIBaseTextField.swift
//  AI_TextField
//
//  Created by kavin_macbook-1 on 28/12/18.
//

import UIKit

open class AIBaseTextField: UITextField {

    let borderLayer = CAShapeLayer()

    // MARK: Config Variable
    public var config: AIBaseTextField.Config = AIBaseTextField.Config() {
        didSet {
            self.updateTextField()
        }
    }
    
    var selectedIcon:UIImage?
    var normalIcon:UIImage?
    
    
    // MARK: Input Accessoryview ToolBar
    public var rightbarButtonOfInputView: UIButton?
    public var leftbarButtonOfInputView: UIButton?
    public var inputToolBar: UIToolbar?

    // MARK: Validation Message
    public var strEmptyValidationMessage: String = ""
    public var strValidationMessage: String = ""
    
    // MARK: Operation On Select
    public var shouldPreventAllActions: Bool = false
    public var canCut: Bool = true
    public var canCopy: Bool = true
    public var canPaste: Bool = true
    public var canSelect: Bool = true
    public var canSelectAll: Bool = true
    public var needToLayoutSubviews: Bool = true
    
    // MARK: Delegate Block
    public var textFieldShouldBeginEditingHandler: ((_ textField: UITextField) -> Bool)?
    public var textFieldDidBeginEditingHandler: ((_ textField: UITextField) -> Swift.Void)?
    public var textFieldShouldReturnHandler: ((_ textField: UITextField) -> Bool)?
    public var textFieldShouldClearHandler: ((_ textField: UITextField) -> Bool)?
    public var textFieldShouldEndEditingHandler: ((_ textField: UITextField) -> Bool)?
    public var textFieldDidEndEditingHandler: ((_ textField: UITextField) -> Swift.Void)?
    public var blockBackSpacePressedEventHandler : ((_ textField: UITextField) -> Swift.Void)?
    
    /// User this block user need to chack for Min-Max length ans input
    public var textFieldShouldChangeCharacterHandler: ((_ textField: UITextField, _ range: NSRange, _ str: String) -> Bool)?
    
    /// Use for get text change event
    public var textFieldTextchangeHandler: ((_ textField: UITextField) -> Swift.Void)? = nil {
        didSet {
            // If TextField is floating lable ignore add target its already added Target
            if self.isKind(of: AIFloatingLabelTextField.self) { return }
            
            if self.textFieldTextchangeHandler != nil {
                self.addTarget(self, action: #selector(AIBaseTextField.textFieldtextChangeEvent(_:)), for: .editingChanged)
            } else {
                self.removeTarget(self, action: #selector(AIBaseTextField.textFieldtextChangeEvent(_:)), for: .editingChanged)
            }
        }
    }
    
    /// Set textField state for edditing and normal
    public private(set) var textFieldState: AIBaseTextField.TextFieldState = .normal {
        didSet {
            self.updateTextFieldEdittingState()
        }
    }
    
    // MARK: Padding for leftView RightView
    public var leftViewPadding: CGFloat? = 0 {
        didSet {
            if let lPadding = self.leftViewPadding, lPadding > 0 {
                var paddingView: UIView? = self.leftView
                if self.leftView == nil {
                    paddingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: lPadding, height: self.frame.height))
                }
                paddingView?.frame = CGRect.init(x: 0, y: 0, width: lPadding, height: self.frame.height)
                self.leftView = paddingView
                self.leftViewMode = UITextField.ViewMode.always
            } else {
                self.leftView = nil
                self.leftViewMode = UITextField.ViewMode.never
            }
        }
    }
    
    var leftIcon: UIImage? = nil {
        didSet {
            guard let img = self.leftIcon else {
                self.leftView = nil
                return
            }
            DispatchQueue.main.async {
                let viewSize = CGSize.init(width: img.size.width + 30.0, height: 50)
                         
                let imgView: UIImageView = UIImageView.init(frame: CGRect(origin: CGPoint.init(x: 0, y: 0), size: viewSize))
                          
                imgView.image = imgView.image?.withRenderingMode(.alwaysTemplate)
                imgView.tintColor = UIColor.PlaceholderGrayColor
                imgView.contentMode = .center
                imgView.image = img

//                self.leftView?.frame = imgView.frame
                var paddingView: UIView? = self.leftView
                        if self.leftView == nil {
                            paddingView = UIView.init(frame: imgView.frame)
                        }
                if (paddingView?.subviews.count)! > 0 {
                    for newimgView in paddingView!.subviews{
                        if newimgView is UIImageView {
                            let new = newimgView as! UIImageView
                            new.image = img
                        }
                    }
                }else{
                    paddingView?.addSubview(imgView)
                }
                paddingView?.frame = imgView.frame
                self.leftView = paddingView
                self.leftViewMode = .always

                
            }
          
        }
    }
    
    var rightIcon: UIImage? = nil {
        didSet {
            guard let img = self.rightIcon else {
                self.rightView = nil
                return
            }
            let viewSize = CGSize.init(width: img.size.width + 20.0, height: img.size.height + 10.0)
            let imgView: UIImageView = UIImageView.init(frame: CGRect(origin: CGPoint.zero, size: viewSize))
            imgView.contentMode = .center
            imgView.image = img
            
            self.rightView = imgView
            self.rightViewMode = .always
        }
    }
    
    public var rightViewPadding: CGFloat? = 0 {
        didSet {
            if let lPadding = self.leftViewPadding, lPadding > 0 {
                var paddingView: UIView? = self.leftView
                if self.leftView == nil {
                    paddingView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: lPadding, height: self.frame.height))
                }
                paddingView?.frame = CGRect.init(x: 0, y: 0, width: lPadding, height: self.frame.height)
                self.rightView = paddingView
                self.rightViewMode = UITextField.ViewMode.always
            } else {
                self.rightView = nil
                self.rightViewMode = UITextField.ViewMode.never
            }
        }
    }
    
    // MARK: For Language support
    @objc open var isLTRLanguage: Bool = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight {
        didSet {
            updateTextAligment()
        }
    }
    
    var validationType:TextFieldValidationType = TextFieldValidationType.none{
        didSet{
            // Notification When Validation Type Change
            switch validationType
            {
            case TextFieldValidationType.none:
                self.keyboardType = UIKeyboardType.default
                self.isSecureTextEntry = false
                break;
            case TextFieldValidationType.name:
                self.keyboardType = UIKeyboardType.alphabet
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.email:
                self.keyboardType = UIKeyboardType.emailAddress
                self.autocorrectionType = UITextAutocorrectionType.no
                self.isSecureTextEntry = false
                break;
            case TextFieldValidationType.password:
                self.keyboardType = UIKeyboardType.default
                self.isSecureTextEntry = true
                break;
                
            case TextFieldValidationType.numbers:
                self.keyboardType = UIKeyboardType.phonePad
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.currency:
                self.keyboardType = UIKeyboardType.decimalPad
                self.isSecureTextEntry = false
                break;
                
            case TextFieldValidationType.minMaxNumber:
                self.keyboardType = UIKeyboardType.decimalPad
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.characters:
                self.keyboardType = UIKeyboardType.alphabet
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.alphaNumeric:
                self.keyboardType = UIKeyboardType.namePhonePad
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.alphaNumeric_WithSpace:
                self.keyboardType = UIKeyboardType.namePhonePad
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.amountValidation:
                
                self.keyboardType = UIKeyboardType.decimalPad
                self.isSecureTextEntry = false
                break
            case TextFieldValidationType.numericOnly:
                self.keyboardType = UIKeyboardType.numberPad
                self.isSecureTextEntry = false
                
                break;
            case TextFieldValidationType.phoneNumber:
                self.keyboardType = UIKeyboardType.phonePad
                self.isSecureTextEntry = false
            case TextFieldValidationType.cvv :
                self.keyboardType = UIKeyboardType.numberPad
                self.isSecureTextEntry = true
            default:
                break;
            }
        }
    }
    
    // MARK: Initializer
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        commonInit()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }
    
    open override func deleteBackward() {
        super.deleteBackward()
        if let handler = self.blockBackSpacePressedEventHandler {
            handler(self)
        }
    }
    
    /// Default property set methord.
    private func commonInit() {
        DispatchQueue.main.async {

        
        //VALIDATIONS
        self.textFieldState = .normal
        self.font = UIFont.systemFont(ofSize:15)
        self.autocorrectionType = .no
        self.delegate = self
        self.setUpReturnKeyForTextField()
        self.borderStyle = .none
        self.layer.cornerRadius = 0.0
            //self.roundCornersWithBorder( radius: 25)
        self.layer.borderColor = UIColor.cellBorderColor.cgColor
        self.layer.borderWidth = 0.0
        self.clipsToBounds = true
            
//            let maskLayer = CAShapeLayer()
//            maskLayer.frame = self.bounds
//            maskLayer.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .topLeft, cornerRadii: CGSize(width: 15, height: 50)).cgPath
//            self.layer.mask = maskLayer
//
//            // Add border
//            self.borderLayer.path = maskLayer.path // Reuse the Bezier path
//            self.borderLayer.fillColor = UIColor.clear.cgColor
//            self.borderLayer.strokeColor = UIColor.HeaderTitleBlackColor.cgColor //
//            self.borderLayer.lineWidth = 1.0
//            self.borderLayer.frame = self.bounds
//            if ((self.layer.sublayers?.contains(self.borderLayer))!) {
//            }else{
//                self.layer.addSublayer(self.borderLayer)
//            }
            
            
        }
      
        
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.HeaderTitleBlackColor])
        
      //  self.leftViewPadding = 10
        
    }
    
    public func updateTextFieldConfig(_ con: AIBaseTextField.Config) {
        self.config = con
    }
    
    public func updateTextField() {
        
        /// update TextField Type
        self.updateTextFieldType()
        self.updateReturnKeyType()
        
        // update Text and placeholder Color
        self.updateTextFieldTextPlaceholderColor()
        
        //Update input Toolbar
        self.inputToolBar?.barTintColor = self.config.toolBarBackgroundColor
        self.leftbarButtonOfInputView?.setTitleColor(self.config.cancelToolBarButtonTitleColor, for: .normal)
        self.rightbarButtonOfInputView?.setTitleColor(self.config.doneToolBarButtonTitleColor, for: .normal)
        
    }
    
    private func updateTextFieldTextPlaceholderColor() {
        
        /// update text Color
        self.textColor = self.config.textColor ?? UIColor.HeaderTitleBlackColor
    
        //update placeholder
        var attributes: [NSAttributedString.Key: Any] = [:]
        attributes[NSAttributedString.Key.font] = self.font ?? UIFont.init(name: (self.font?.fontName)!, size: (self.font?.pointSize)!)
        attributes[NSAttributedString.Key.foregroundColor] = self.config.placeholderColor ?? UIColor.HeaderTitleBlackColor
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
    }
    
    private func updateTextFieldType() {
        switch self.config.textFieldKeyboardType {
        case .email:
            self.autocorrectionType = .no
            self.autocapitalizationType = .none
            self.keyboardType = .emailAddress
        case .password:
            self.isSecureTextEntry = true
            self.canPaste = false
            self.canCopy = false
            self.keyboardType = .default
        case .phoneNumber:
            self.keyboardType = .phonePad
        case .userName:
            self.autocapitalizationType = .none
            self.keyboardType = .default
        case .name, .nameWithSpecialChar:
            self.autocapitalizationType = .words
            self.keyboardType = .default
        case .noneNOSPACE, .characters, .charactersNOSPACE, .charactersNumber, .charactersNumberNOSPACE, .charactersSplCharacters, .charactersSplCharactersNOSPACE:
            self.autocapitalizationType = .words
            self.keyboardType = .default
        case .float, .number, .numberNozero:
            self.autocapitalizationType = .none
            self.keyboardType = .phonePad
        case .numberSpace:
            self.autocapitalizationType = .none
            self.keyboardType = .namePhonePad
        case .datePicker, .picker:
            self.shouldPreventAllActions = false
            
        default:
            break
        }
    }
    
    /// Textfield Action
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if self.shouldPreventAllActions {
            return false
        }
        
        switch action {
        case #selector(UIResponderStandardEditActions.cut(_:)):
            return self.canCut ? super.canPerformAction(action, withSender: sender) : self.canCut
        case #selector(UIResponderStandardEditActions.copy(_:)):
            return self.canCopy ? super.canPerformAction(action, withSender: sender) : self.canCopy
        case #selector(UIResponderStandardEditActions.paste(_:)):
            return self.canPaste ? super.canPerformAction(action, withSender: sender) : self.canPaste
        case #selector(UIResponderStandardEditActions.select(_:)):
            return self.canSelect ? super.canPerformAction(action, withSender: sender) : self.canSelect
        case #selector(UIResponderStandardEditActions.selectAll(_:)):
            return self.canSelectAll ? super.canPerformAction(action, withSender: sender) : self.canSelectAll
        default:
            return super.canPerformAction(action, withSender: sender)
        }
    }
    
    // MARK: TextchangeEvent Target
    @objc private func textFieldtextChangeEvent(_ sender: UITextField) {
        if let handler = self.textFieldTextchangeHandler {
            handler(self)
        }
    }
    
    // MARK: setupReturnKey
    public func setUpReturnKeyForTextField() {
        if self.keyboardType == .numberPad || self.keyboardType == .decimalPad || self.keyboardType == .phonePad {
            // TOOLBAR
            let toolBar = UIToolbar()
            toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
            toolBar.barTintColor = self.config.toolBarBackgroundColor
            toolBar.isTranslucent = true
            self.inputToolBar = toolBar
            
            // TOOLBAR ITEMS
            let buttonCancel: UIButton = UIButton.init(frame: CGRect.zero)
            buttonCancel.setTitle("Cancel", for: .normal)
            buttonCancel.setTitleColor(self.config.cancelToolBarButtonTitleColor, for: .normal)
            buttonCancel.addTarget(self, action: #selector(AIBaseTextField.buttonCancelPressed(_:)), for: .touchUpInside)
            buttonCancel.sizeToFit()
            self.leftbarButtonOfInputView = buttonCancel
            
            let buttonNext: UIButton = UIButton.init(frame: CGRect.zero)
            buttonNext.setTitle("Done", for: .normal)
            buttonNext.setTitleColor(self.config.doneToolBarButtonTitleColor, for: .normal)
            buttonNext.addTarget(self, action: #selector(AIBaseTextField.buttonNextPressed(_:)), for: .touchUpInside)
            buttonNext.sizeToFit()
            self.rightbarButtonOfInputView = buttonNext

            let barButtonCancel = UIBarButtonItem(customView: buttonCancel)
            let barButtonNext = UIBarButtonItem(customView: buttonNext)
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            
            toolBar.items = [barButtonCancel, flexibleSpace, barButtonNext]
            self.inputAccessoryView = toolBar
        }
    }
    
    // MARK: ToolBarButton Event
    @objc private func buttonCancelPressed(_ sender: UIBarButtonItem) {
        self.resignFirstResponder()
    }
    
    @objc private func buttonNextPressed(_ sender: UIBarButtonItem) {
        _ = self.delegate?.textFieldShouldReturn!(self)
    }
    
    // MARK: updateTextField Alignment
    func updateTextAligment() {
        if isLTRLanguage {
            textAlignment = .left
        } else {
            textAlignment = .right
        }
    }
    
    // MARK: Update TextFieldEditting State
    internal func updateTextFieldState(_ state: AIBaseTextField.TextFieldState) {
        self.textFieldState = state
    }
    
    public func updateTextFieldEdittingState() {
        
        switch self.textFieldState {
        case .normal:
           // self.layer.borderColor = UIColor.cellBorderColor.cgColor
            if (normalIcon != nil) {
                
                self.leftIcon = normalIcon

            }

            //update placeholder
            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[NSAttributedString.Key.font] = self.font ?? UIFont.init(name: (self.font?.fontName)!, size: (self.font?.pointSize)!)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.PlaceholderGrayColor
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)
            self.borderLayer.strokeColor = UIColor.HeaderTitleBlackColor.cgColor //

        case .edittable:
//            self.layer.borderColor = UIColor.clear.cgColor

       //    self.layer.borderColor = UIColor.clear.cgColor
            if (selectedIcon != nil) {
                self.leftIcon = selectedIcon
            }

            //update placeholder
            var attributes: [NSAttributedString.Key: Any] = [:]
            attributes[NSAttributedString.Key.font] = self.font ?? UIFont.init(name: (self.font?.fontName)!, size: (self.font?.pointSize)!)
            attributes[NSAttributedString.Key.foregroundColor] = UIColor.PlaceholderGrayColor
            self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: attributes)

          //  self.borderLayer.strokeColor = UIColor.HeaderTitleBlackColor.cgColor //

        }
    }
}

// MARK: For Provide Configuratiuon
extension AIBaseTextField {
    /// For textField State Option
    public enum TextFieldState: Int {
        case normal
        case edittable
    }
    
    /// For TextField Type
    public enum TextFieldType: Int {
        case email
        case password
        case phoneNumber
        case userName
        case name
        case nameWithSpecialChar
        case noneNOSPACE
        case characters
        case charactersNOSPACE
        case charactersNumber
        case charactersNumberNOSPACE
        case charactersSplCharacters
        case charactersSplCharactersNOSPACE
        case float
        case number
        case numberNozero
        case numberSpace
        case picker
        case datePicker
        case monthYear
        case none
    }
    
    public struct Config {
        
        /// For TextField min length.
        public var minLength: Int = 0

        /// For TextField max length.
        public var maxLength: Int = 256
        
        /// Set TextField keyboard type.
        public var textFieldKeyboardType: AIBaseTextField.TextFieldType   = .none
        
        /// Textfield placeholderColor.
        public var placeholderColor: UIColor? = UIColor.HeaderTitleBlackColor
        
        /// Textfield TextColor
        public var textColor: UIColor? = UIColor.HeaderTitleBlackColor
        
        /// Textfield Bottom line Editing mode color.
        public var floatingLabelEditingColor: UIColor? =  UIColor.darkGray
        
        /// Textfield Bottom line normal color.
        public var  bottomLineNormalColor: UIColor? = UIColor.darkGray
        
        /// Textfield Bottom line Editing mode color.
        public var bottomLineEditingColor: UIColor? =  UIColor.HeaderTitleBlackColor
        
        // InputAccessoiryView
        public var toolBarBackgroundColor: UIColor =  UIColor.white.withAlphaComponent(0.9)
        public var cancelToolBarButtonTitleColor: UIColor =  UIColor.systemBlue
        public var doneToolBarButtonTitleColor: UIColor =  UIColor.systemBlue
        
        public init(textMinLength minLength: Int = 0,
                    textMaxLength maxLength: Int = 256,
                    textFieldKeyboardType keyboardType: AIBaseTextField.TextFieldType = .none,
                    appPlaceholderColor placeholderColor: UIColor = UIColor.darkGray,
//                    appTextColor textColor: UIColor = UIColor.black,
                    appFloatingLabelEditingColor labelEditingColor: UIColor = UIColor.darkGray,
                    appBottomLineNormalColor lineNormalColor: UIColor = UIColor.darkGray,
                    appBottomLineEditingColor lineEditingColor: UIColor = UIColor.darkGray,
                    appToolbarBackgroundgColor: UIColor = UIColor.lightGray,
                    toolBarCancelTitleColor: UIColor = UIColor.black.withAlphaComponent(0.2),
                    toolBarDoneTitleColor: UIColor = UIColor.black) {
            
            self.minLength = minLength
            self.maxLength = maxLength
            self.textFieldKeyboardType = keyboardType
            self.placeholderColor = placeholderColor
//            self.textColor =  textColor
            self.floatingLabelEditingColor = labelEditingColor
            self.bottomLineNormalColor = lineNormalColor
            self.bottomLineEditingColor = lineEditingColor
            self.toolBarBackgroundColor = appToolbarBackgroundgColor
            self.cancelToolBarButtonTitleColor = toolBarCancelTitleColor
            self.doneToolBarButtonTitleColor = toolBarDoneTitleColor
        }
    }
}

enum TextFieldValidationType : Int
{
    case none
    case name
    case email
    case password
    case numbers
    case characters
    case characters_WithSpace
    case alphaNumeric
    case alphaNumeric_WithSpace
    case alphaNumeric_WithSpace_SpecialCharacter
    case amountValidation
    case currency
    case minMaxNumber
    case numericOnly
    case phoneNumber
    case cvv
    case card
    case expiryDate


}


