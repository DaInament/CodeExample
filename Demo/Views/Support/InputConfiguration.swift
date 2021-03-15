//
//  InputConfiguration.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class InputConfiguration {
    let style: InputViewStyle
    let text: String?
    let title: String?
    let subtitle: String?
    let hint: String?
    let allowedInputRegexp: String?
    let rules: [(String) -> (passed: Bool, errorMessage: String?)]?
    let showSwitcher: Bool
    let showDropdown: Bool
    let showHideTextButton: Bool
    let infoButtonAction: (() -> Void)?
    let keyboardType: UIKeyboardType
    let updateNext: (() -> Void)?
    let inputMask: String?
    let allowCopy: Bool
    let allowPaste: Bool
    let helperText: String?
    let isDisabled: Bool
    let beforeEditing: (() -> Void)?
    let onEditing: (() -> Void)?
    let afterEditing: (() -> Void)?
    
    init(style: InputViewStyle = .black,
         text: String? = nil,
         title: String? = nil,
         subtitle: String? = nil,
         hint: String? = nil,
         allowedInputRegexp: String? = nil,
         rules: [(String) -> (passed: Bool, errorMessage: String?)]? = nil,
         showSwitcher: Bool = false,
         showDropdown: Bool = false,
         showHideTextButton: Bool = false,
         infoButtonAction: (() -> Void)? = nil,
         keyboardType: UIKeyboardType = .default,
         updateNext: (() -> Void)? = nil,
         inputMask: String? = nil,
         allowCopy: Bool = true,
         allowPaste: Bool = true,
         helperText: String? = nil,
         isDisabled: Bool = false,
         beforeEditing: (() -> Void)? = nil,
         onEditing: (() -> Void)? = nil,
         afterEditing: (() -> Void)? = nil) {
        self.style = style
        self.text = text
        self.title = title
        self.subtitle = subtitle
        self.hint = hint
        self.allowedInputRegexp = allowedInputRegexp
        self.rules = rules
        self.showSwitcher = showSwitcher
        self.showDropdown = showDropdown
        self.showHideTextButton = showHideTextButton
        self.infoButtonAction = infoButtonAction
        self.keyboardType = keyboardType
        self.updateNext = updateNext
        self.inputMask = inputMask
        self.allowCopy = allowCopy
        self.allowPaste = allowPaste
        self.helperText = helperText
        self.isDisabled = isDisabled
        self.beforeEditing = beforeEditing
        self.onEditing = onEditing
        self.afterEditing = afterEditing
    }
}
