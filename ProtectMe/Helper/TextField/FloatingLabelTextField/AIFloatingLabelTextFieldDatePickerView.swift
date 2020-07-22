//
//  AIFloatingLabelTextFieldDatePickerView.swift
//  AI_TextField
//
//  Created by kavin_macbook-1 on 02/01/19.
//

import UIKit

open class AIFloatingLabelTextFieldDatePickerView: AIFloatingLabelTextField {

    // MARK: - Variable
    public private(set) var datePickerView: UIDatePicker?
    public var dateformat: String = "dd-MM-yyyy"
    public var selectedDateValue: Date?
    public var pickerViewDoneHandler: ((_ txtField: AIFloatingLabelTextFieldDatePickerView, _ selectedDate: Date, _ selectedDateInString: String) -> Void)?
    
    /// For setting maximum year range allowed from currentDate in date picker
    public var maxYear: Int = -18 {
        didSet {
            self.updateDatePickerRange()
        }
    }
    
    /// For setting minimum year range allowed from currentDate in date picker
    public var minYear: Int = -100 {
        didSet {
            self.updateDatePickerRange()
        }
    }
    
    /// For setting datepicker Date selectionMode
    public var datePickerMode: UIDatePicker.Mode = UIDatePicker.Mode.date {
        didSet {
            self.datePickerView?.datePickerMode = datePickerMode
        }
    }
    
    /// For setting current date of datepicker
    public var currentDate: Date = Date() {
        didSet {
            self.updateDatePickerRange()
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
        self.config.textFieldKeyboardType = AIBaseTextField.TextFieldType.datePicker
        
        // Create Pickerview
        let datePView = UIDatePicker()
        self.datePickerView = datePView
        self.updateDatePickerRange()
        
        //Setting DatePicker Mode
        self.datePickerView?.datePickerMode = self.datePickerMode
        
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
        buttonNext.addTarget(self, action: #selector(AIFloatingLabelTextFieldDatePickerView.buttonDonePressed1(_:)), for: .touchUpInside)
        buttonNext.sizeToFit()
        self.rightbarButtonOfInputView = buttonNext
        
        let buttonCancel: UIButton = UIButton.init(frame: CGRect.zero)
        buttonCancel.setTitle("Cancel", for: .normal)
        buttonCancel.setTitleColor(self.config.cancelToolBarButtonTitleColor, for: .normal)
        buttonCancel.addTarget(self, action: #selector(AIFloatingLabelTextFieldDatePickerView.buttonCancelPressed1(_:)), for: .touchUpInside)
        buttonCancel.sizeToFit()
        self.leftbarButtonOfInputView = buttonCancel
        
        let barButtonCancel = UIBarButtonItem(customView: buttonCancel)
        let barButtonNext = UIBarButtonItem(customView: buttonNext)
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolBar.items = [barButtonCancel, flexibleSpace, barButtonNext]
        self.inputAccessoryView = toolBar
        self.inputView = self.datePickerView
        
        self.textFieldDidBeginEditingHandler = { [unowned self] (_) in
            if let selectedDate  = self.selectedDateValue {
                self.datePickerView?.date = selectedDate
            } else if let txt = self.text, let datefromText = txt.app_DateFromString(dateFormat: self.dateformat) {
                self.datePickerView?.date = datefromText
            }
        }
    }
    
    @objc private func buttonCancelPressed1(_ sender: UIButton) {
        _ = self.resignFirstResponder()
    }
    
    @objc private func buttonDonePressed1(_ snnder: UIButton) {
        
        guard let dPickerView = self.datePickerView else { return }
        self.selectedDateValue = dPickerView.date
        
        if let handler = self.pickerViewDoneHandler {
            handler(self, dPickerView.date, dPickerView.date.app_stringFromDate(dateFormate: self.dateformat))
        }
        _ = self.delegate?.textFieldShouldReturn!(self)
    }
    
    public override func updateTextField() {
        super.updateTextField()
    }
    
    /// update pickerViewChanges
    private func updateDatePickerRange() {
        guard let dPickerView = self.datePickerView else { return }
        let calendar = Calendar.init(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = maxYear
        dPickerView.maximumDate = calendar.date(byAdding: dateComponents, to: currentDate)
        dateComponents.year = minYear
        dPickerView.minimumDate = calendar.date(byAdding: dateComponents, to: currentDate)
    }
    
}

private extension String {
    func app_DateFromString(dateFormat: String) -> Date? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: self)
    }
}

private extension Date {
    func app_stringFromDate(dateFormate: String) -> String {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormate
        return dateFormatter.string(from: self)
    }
}
