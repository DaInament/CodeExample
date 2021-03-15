//
//  BaseScreen.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class BaseScreen: UIViewController {
    var scrollViewForKeyboard: UIScrollView?
    private var movingBottomConstraint: NSLayoutConstraint?
    private var bottomSpacingWithKeyboard: CGFloat = 0
    private var bottomSpacingWithoutKeyboard: CGFloat = 0
    
    func pinToKeyboard(_ constraint: NSLayoutConstraint, spacing: CGFloat = 0) {
        movingBottomConstraint = constraint
        let window = UIApplication.shared.keyWindow
        let bottomPadding = window?.safeAreaInsets.bottom
        if let bottomPaddding = bottomPadding {
            bottomSpacingWithKeyboard = bottomPaddding - spacing
            
        } else {
            bottomSpacingWithKeyboard = -spacing
        }
        bottomSpacingWithoutKeyboard = -spacing
        
        addKeyboardNotificationCenter()
    }
    
    private func addKeyboardNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard movingBottomConstraint != nil else { return }
        if let userInfoDictionary = notification.userInfo {
            let keyboardRect = userInfoDictionary[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
            guard keyboardRect != nil else { return }
            UIView.animate(withDuration: 0.33) {
                self.movingBottomConstraint!.constant = self.bottomSpacingWithKeyboard - keyboardRect!.height
                if let scrollView = self.scrollViewForKeyboard {
                    var contentInset = scrollView.contentInset
                    contentInset.bottom = keyboardRect!.height
                    scrollView.contentInset = contentInset
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard movingBottomConstraint != nil else { return }
        UIView.animate(withDuration: 0.33) {
            self.movingBottomConstraint!.constant = self.bottomSpacingWithoutKeyboard
            if let scrollView = self.scrollViewForKeyboard {
                let contentInset = UIEdgeInsets.zero
                scrollView.contentInset = contentInset
            }
        }
    }
}
