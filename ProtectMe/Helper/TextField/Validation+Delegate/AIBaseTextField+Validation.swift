//
//  AIBaseTextField+Validation.swift
//  AI_TextField
//
//  Created by kavin_macbook-1 on 28/12/18.
//

import UIKit

extension AIBaseTextField {

    struct CharacterSetType {
        
        static var Email = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._"
        static var Password = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*(){}[]_-+*/~`.?<>"
        static var Phone = "0123456789"
        static var number = "0123456789"
        static var numberWithSpace = "0123456789 "
        static var numberWithNoZero = "123456789"
        static var Float = "0123456789."
        static var none = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*(){}[]_-+*/~`.?<> "
        static var noneWithNoSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*(){}[]_-+*/~`.?<>"
        static var characterWithNumber = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
        static var characterNumberWithNoSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        static var characterAndSpcicalSymbol = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*(){}[]_-+*/~`.?<> "
        static var characterSpecialSymbolAndNoSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*(){}[]_-+*/~`.?<>"
        static var Characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ "
        static var charactersWithNoSpace = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        static var charactersForUserName = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_.-$"
        static var charactersForName = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'. "
    }
    
    func checkMaxLength(_ range: NSRange, maxLength: NSInteger, current string: String) -> Bool {
        
        let fullText = (self.text! as NSString).replacingCharacters(in: range, with: string)
        return fullText.count <= self.config.maxLength
    }
    
    func checkTextValidation(_ range: NSRange, replacementString string: String, txtType: AIBaseTextField.TextFieldType = .none) -> Bool {
        
        //BackSpace Always Allow
        if string == "" { return true }
        
        //Dont Allow Initialiy Empty Space
        if range.location == 0, string.hasPrefix(" ") { return false }
        
        switch txtType {
        case .none,
             .noneNOSPACE,
             .charactersNumber,
             .charactersNumberNOSPACE,
             .charactersSplCharacters,
             .charactersSplCharactersNOSPACE,
             .characters,
             .charactersNOSPACE,
             .userName,
             .name:
            return self.checkTextBlock(self, range: range, string: string, txtType: txtType)
            
        case .phoneNumber, .number, .numberNozero, .numberSpace, .float:
            return self.checkNumberBlock(self, range: range, string: string, txtType: txtType)
            
        case .email, .password :
            return self.checkEmailAndPasswordBlock(self, range: range, string: string, txtType: txtType)
            
        default:
            return self.checkTextBlock(self, range: range, string: string, txtType: txtType)
        }
    }
    
    private func checkTextBlock(_ textField: UITextField, range: NSRange, string: String, txtType: AIBaseTextField.TextFieldType = .none) -> Bool {
        
        var charactersToBlock: CharacterSet = CharacterSet()
        if txtType == TextFieldType.none {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.none)
        } else if txtType == TextFieldType.noneNOSPACE {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.noneWithNoSpace)
        } else if txtType == TextFieldType.charactersNumber {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.characterWithNumber)
        } else if txtType == TextFieldType.charactersNumberNOSPACE {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.characterNumberWithNoSpace)
        } else if txtType == TextFieldType.charactersSplCharacters {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.characterAndSpcicalSymbol)
        } else if txtType == TextFieldType.charactersSplCharactersNOSPACE {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.characterSpecialSymbolAndNoSpace)
        } else if txtType == TextFieldType.characters {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.Characters)
        } else if txtType == TextFieldType.charactersNOSPACE {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.charactersWithNoSpace)
        } else if txtType == TextFieldType.userName {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.charactersForUserName)
        } else if txtType == TextFieldType.name {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.charactersForName)
        }
        
        if let txt = textField.text {
            let length: Int = txt.count
            if length > 0 {
                let index: Int = length
                var theCharacter: String = String()
                let tmpIndex = txt.index(txt.startIndex, offsetBy: index-1)
                theCharacter = String.init(txt[tmpIndex])
                if theCharacter.hasPrefix(" ") && string.hasPrefix(" ") {
                    return false
                }
            }
        }
        return (string.rangeOfCharacter(from: charactersToBlock) != nil)
    }
    
    private func checkNumberBlock(_ textField: UITextField, range: NSRange, string: String, txtType: AIBaseTextField.TextFieldType) -> Bool {
        
        var charactersToBlock: CharacterSet = CharacterSet()
        if txtType == TextFieldType.phoneNumber {
            if range.location == 0 &&  string == "0" {
                return false
            }
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.Phone)
        } else if txtType == TextFieldType.number {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.number)
        } else if txtType == TextFieldType.numberSpace {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.numberWithSpace)
        } else if txtType == TextFieldType.float {
            if let txt = textField.text, txt.range(of: ".") != nil && string == "." {
                return false
            } else {
                if let txt = textField.text, txt.range(of: ".") != nil {
                    let newString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
                    let seperate: NSArray = newString.components(separatedBy: ".") as NSArray
                    if seperate.count >= 2, let obj = [seperate.object(at: 1)].first, let objArg = obj as? CVarArg {
                        let strSeperate: NSString =  NSString(format: "%@", objArg) as NSString
                        return !(strSeperate.length > 2)
                    }
                }
            }
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.Float)
        } else if txtType == TextFieldType.numberNozero {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.numberWithNoZero)
        }
        return (string.rangeOfCharacter(from: charactersToBlock) != nil)
    }
    
    private func checkEmailAndPasswordBlock(_ textField: UITextField, range: NSRange, string: String, txtType: AIBaseTextField.TextFieldType) -> Bool {
        var charactersToBlock: CharacterSet = CharacterSet()
        if txtType == TextFieldType.email {
//            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.Email)
            let charactersToBlock = CharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._").inverted
            let compSepByCharInSet =  string.components(separatedBy: charactersToBlock).filter{!$0.isEmpty}
            let numberFiltered = compSepByCharInSet.joined(separator: "")
            let resultingString = (textField.text! as NSString).replacingCharacters(in: range, with: string) as NSString
            
            if resultingString.length>0 {
                let firstChar:unichar = resultingString .character(at: 0)
                let letters = CharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ@._")
                if letters.contains(UnicodeScalar(firstChar)!){
                    // if letters .contains(firstChar){
                    // if letters .characterIsMember(firstChar) {
                    
                }else{
                    return false;
                }
            }
            
            if resultingString.length>1 {
                let lastChar1:unichar = resultingString .character(at: resultingString.length - 1)
                let lastChar2:unichar = resultingString .character(at: resultingString.length - 2)
                
                let letter1 = CharacterSet(charactersIn:"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
                if !letter1.contains(UnicodeScalar(lastChar1)!) && !letter1.contains(UnicodeScalar(lastChar2)!){
                    //if !letter1 .characterIsMember(lastChar1) && !letter1 .characterIsMember(lastChar2) {
                    return false;
                }
            }
            return string == numberFiltered
        } else if  txtType == TextFieldType.password {
            charactersToBlock = CharacterSet(charactersIn: CharacterSetType.Password)
        }
        return (string.rangeOfCharacter(from: charactersToBlock) != nil)
    }
}
