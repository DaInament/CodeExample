//
//  InputTextField.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class InputTextField: UITextField {
    
    var canCopy = true
    var canPaste = true
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if !canPaste, action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        if !canCopy, action == #selector(UIResponderStandardEditActions.copy(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
