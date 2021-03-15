//
//  OutlinedInputView.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

protocol OutlinedInputViewDelegate: class {
    func showError(with text: String)
    func hideError()
    func showHelper(with text: String)
    func hideHelper()
}

class OutlinedInputView: UIView {
    private let outlinedInputViewWithoutHelper = OutlinedInputViewWithoutHelper()
    
    private let helper = UITextView()
    
    private var helperText: String?
    
    private var stack = UIStackView()
    
    func setup(configuration: InputConfiguration,
               overlapAction: ((_: OutlinedInputViewWithoutHelper?) -> Void)? = nil) {
        
        setupHelperView()
        outlinedInputViewWithoutHelper.setup(configuration: configuration,
                                             errorHelper: self,
                                             overlapAction: overlapAction)
        
        stack = VStack(outlinedInputViewWithoutHelper,
                       helper).apply {
                        $0.spacing = 8
                       }
        addSubview(stack)
        stack.pin(to: self, withInsets: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        self.helperText = configuration.helperText
        if let text = helperText {
            if configuration.rules != nil {
                if outlinedInputViewWithoutHelper.isCheckPassed {
                    showHelper(with: text)
                } else if let viewText = outlinedInputViewWithoutHelper.getText(), viewText.isEmpty {
                    showHelper(with: text)
                }
            } else {
                showHelper(with: text)
            }
        }
    }
    
    func setText(_ text: String) {
        outlinedInputViewWithoutHelper.setText(text)
    }
    
    func getText() -> String? {
        return outlinedInputViewWithoutHelper.getText()
    }
    
    func isCheckPassed() -> Bool {
        return outlinedInputViewWithoutHelper.isCheckPassed
    }
    
    private func setupHelperView() {
        helper.apply {
            $0.isHidden = true
            $0.font = .systemFont(ofSize: 14)
            $0.textColor = Colors.red_E1()
            $0.backgroundColor = .clear
            $0.textContainerInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
            $0.textContainer.lineFragmentPadding = 0
            $0.showsVerticalScrollIndicator = false
            $0.showsHorizontalScrollIndicator = false
            $0.isScrollEnabled = false
            $0.isEditable = false
            $0.isSelectable = false
        }
    }
}

extension OutlinedInputView: OutlinedInputViewDelegate {
    func showError(with text: String) {
        helper.text = text
        helper.textColor = Colors.red_E1()
        helper.isHidden = false
    }
    
    func showHelper(with text: String) {
        helper.text = text
        helper.textColor = Colors.grey200()
        helper.isHidden = false
    }
    
    func hideError() {
        if let helperText = helperText {
            showHelper(with: helperText)
        } else {
            helper.isHidden = true
        }
    }
    
    func hideHelper() {
        helper.isHidden = true
    }
}
