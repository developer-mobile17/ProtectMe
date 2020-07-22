//
//  AITextFieldPickerView.swift
//  AI_TextField
//
//  Created by kavin_macbook-1 on 28/12/18.
//

import UIKit

open class AITextFieldPickerView: AIBaseTextField {

    public private(set) var pickerView: UIPickerView?
    public var pickerViewDoneHandler: ((_ txtField: AITextFieldPickerView, _ selectedIndex: Int) -> Void)?
    public var pickerViewdidSelectRowHandler: ((_ txtField: AITextFieldPickerView, _ selectedIndex: Int) -> Void)?
    public var arrInput: [String] = []
    public override var config: AIBaseTextField.Config {
        didSet {
            self.updateTextField()
        }
    }
    
    // MARK: INIT
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInitialize()
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //commonInitialize()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        commonInitialize()
    }
    
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
    
    /// Common Initialization
    func commonInitialize() {
        
        //update Config to datePicker
        self.config.textFieldKeyboardType = AIBaseTextField.TextFieldType.picker
        
        // Create Pickerview
        let pView = UIPickerView()
        pView.frame =  CGRect(x: 0, y: UIScreen.main.bounds.size.height - 216, width: UIScreen.main.bounds.size.width, height: 216)
        pView.delegate = self
        pView.dataSource = self
        self.pickerView = pView
        
        // TOOLBAR
        let toolBar = UIToolbar()
        toolBar.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 44)
        toolBar.barTintColor = self.config.toolBarBackgroundColor
        toolBar.isTranslucent = true
        self.inputToolBar = toolBar
        
        // TOOLBAR ITEMS
        let buttonNext: UIButton = UIButton.init(frame: CGRect.zero)
        buttonNext.setTitle("Done", for: .normal)
        buttonNext.setTitleColor(self.config.doneToolBarButtonTitleColor, for: .normal)
        buttonNext.addTarget(self, action: #selector(AITextFieldPickerView.buttonDonePressed1(_:)), for: .touchUpInside)
        buttonNext.sizeToFit()
        self.rightbarButtonOfInputView = buttonNext
        
        let buttonCancel: UIButton = UIButton.init(frame: CGRect.zero)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.setTitleColor(self.config.cancelToolBarButtonTitleColor, for: .normal)
        buttonCancel.addTarget(self, action: #selector(AITextFieldPickerView.buttonCancelPressed1(_:)), for: .touchUpInside)
        buttonCancel.sizeToFit()
        self.leftbarButtonOfInputView = buttonCancel
        
        let barButtonCancel = UIBarButtonItem(customView: buttonCancel)
        let barButtonNext = UIBarButtonItem(customView: buttonNext)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [barButtonCancel, flexibleSpace, barButtonNext]
        self.inputAccessoryView = toolBar
        self.inputView = self.pickerView
        
        self.textFieldDidBeginEditingHandler = { [unowned self] (_) in
            if let txt = self.text, let index = self.arrInput.index(of: txt) {
                self.pickerView?.selectRow(index, inComponent: 0, animated: true)
            }
        }
    }
    
    @objc private func buttonCancelPressed1(_ sender: UIButton) {
        _ = self.resignFirstResponder()
    }
    
    @objc private func buttonDonePressed1(_ snnder: UIButton) {
        _ = self.delegate?.textFieldShouldReturn!(self)
        
        if let pickerView = self.pickerView, let handler = self.pickerViewDoneHandler {
            handler(self, pickerView.selectedRow(inComponent: 0))
        }
    }
    
    public override func updateTextField() {
        super.updateTextField()
    }
}

// MARK: UIPickerViewDataSource
extension AITextFieldPickerView: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.arrInput.count
    }
}

// MARK: UIPickerViewDelegate
extension AITextFieldPickerView: UIPickerViewDelegate {
    @objc public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let pickerViewdidSelectRowHandler = self.pickerViewdidSelectRowHandler {
            pickerViewdidSelectRowHandler(self, row)
        }
        return self.arrInput[row]
    }
    
    @objc public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let pickerViewdidSelectRowHandler = self.pickerViewdidSelectRowHandler {
            pickerViewdidSelectRowHandler(self, row)
        }
    }
}
