//
//  AIBaseTextField+UITextFieldDelegate.swift
//  AI_TextField
//
//  Created by kavin_macbook-1 on 28/12/18.
//

import Foundation
import UIKit

extension AIBaseTextField: UITextFieldDelegate {
    
    open func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if let handler = self.textFieldShouldBeginEditingHandler {
            return handler(self)
        }
        return true
    }
    
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.updateReturnKeyType()
        
        // Change textField mode
        self.updateTextFieldState(AIBaseTextField.TextFieldState.edittable)
        if let handler = self.textFieldDidBeginEditingHandler {
            handler(self)
        }
    }
    
    open func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if let handler = self.textFieldShouldBeginEditingHandler {
            return handler(self)
        }
        return true
    }
    
    open func textFieldDidEndEditing(_ textField: UITextField) {
        
        // Change textField mode
        self.updateTextFieldState(AIBaseTextField.TextFieldState.normal)
        if let handler = self.textFieldDidEndEditingHandler {
            handler(self)
        }
    }
    open func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let handler = self.textFieldShouldChangeCharacterHandler {
            return handler(self, range, string)
        }
        
        // Backspace always allow
        if string == "" {
            return true
        }
        
        if !self.checkMaxLength(range, maxLength: self.config.maxLength, current: string) {
            return false
        }
        
        return self.checkTextValidation(range, replacementString: string, txtType: self.config.textFieldKeyboardType)
    }
    
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if let handler = self.textFieldShouldClearHandler {
            return handler(self)
        }
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let handler = self.textFieldShouldReturnHandler {
            return handler(self)
        }
        
        /// Find next textField
        if let view = self.findNextInputView(), view.canResignFirstResponder {
            view.becomeFirstResponder()
        }
        self.resignFirstResponder()
        return true
    }
}

extension AIBaseTextField {
    
    // MARK: updateReturnKeyType
    public func updateReturnKeyType() {
        if self.isNextTextFieldAvailable() {
            self.returnKeyType = .next
            self.rightbarButtonOfInputView?.setTitle("Next", for: .normal)
        } else {
            self.returnKeyType = .done
            self.rightbarButtonOfInputView?.setTitle("Done", for: .normal)
        }
    }
    
    private func findNextInputView() -> UIView? {
        let allField: [UIView] = self.prepareListOfAllTextField()
        
        var ownerPoint = CGPoint.zero
        if let sView = self.superview {
            ownerPoint = sView.convert(self.frame.origin, to: nil)
        }
        var viewFetched: UIView?
        var viewFetchedPoint: CGPoint?
        for vView in allField {
            if let sView = vView.superview {
                let point = sView.convert(vView.frame.origin, to: nil)
                
                if self.isPointnearest(curruentPoint: ownerPoint, comparePoint: point, internalPastPoint: viewFetchedPoint) {
                    viewFetched = vView
                    viewFetchedPoint = point
                }
            }
        }
        return viewFetched
    }
    
    private func isPointnearest(curruentPoint: CGPoint, comparePoint: CGPoint, internalPastPoint: CGPoint?) -> Bool {
        if comparePoint.y > curruentPoint.y {
            if let internalPastPoint = internalPastPoint {
                if internalPastPoint.y > comparePoint.y {
                    return true
                } else if internalPastPoint.y == comparePoint.y && internalPastPoint.x > comparePoint.x {
                    return true
                }
            } else {
                return true
            }
        } else if comparePoint.y == curruentPoint.y && comparePoint.x > curruentPoint.x {
            if let internalPastPoint = internalPastPoint {
                if internalPastPoint.y > comparePoint.y {
                    return true
                } else if internalPastPoint.y == comparePoint.y && internalPastPoint.x > comparePoint.x {
                    return true
                }
            } else {
                return true
            }
        }
        return false
    }
    
    private func isNextTextFieldAvailable() -> Bool {
        let allField: [UIView] = self.prepareListOfAllTextField()
        
        var ownerPoint = CGPoint.zero
        if let sView = self.superview {
            ownerPoint = sView.convert(self.frame.origin, to: nil)
        }
        for vView in allField {
            if let sView = vView.superview {
                let point = sView.convert(vView.frame.origin, to: nil)
                if point.y > ownerPoint.y {
                    return true
                } else if point.y == ownerPoint.y && point.x > ownerPoint.x {
                    return true
                }
            }
        }
        return false
    }
    
    private func prepareListOfAllTextField() -> [UIView] {
        
        guard let viewController = self.parentViewController1 else { return [] }
        let allTextField = self.findInSubviews(withView: viewController.view)
        return allTextField
    }
    
    func findInSubviews(withView view: UIView) -> [UIView] {
        var allTextFieldInSubView: [UIView] = []
        
        let subviews = view.subviews
        if subviews.count == 0 { // Return if there are no subviews
            return allTextFieldInSubView
        }
        
        let allInputView = subviews.filter { ($0 is UITextField || $0 is UITextView) && ( !$0.isHidden || !$0.isUserInteractionEnabled) }
        allTextFieldInSubView.append(contentsOf: allInputView)
        for sview in subviews {
            if !allInputView.contains(sview) {
                allTextFieldInSubView.append(contentsOf: self.findInSubviews(withView: sview))
            }
        }
        
        if let index = allTextFieldInSubView.index(of: self) {
            allTextFieldInSubView.remove(at: index)
        }
        return allTextFieldInSubView
    }
}

extension UIView {
    var parentViewController1: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
