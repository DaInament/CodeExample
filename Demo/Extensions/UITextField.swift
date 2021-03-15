//
//  UITextField.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

extension UITextField {
    
    @IBInspectable var nextPreviousDoneAccessory: Bool {
        get {
            return self.nextPreviousDoneAccessory
        }
        set (hasDone) {
            if hasDone {
                addNextPreviousDoneButtons()
            }
        }
    }
    
    @IBInspectable var doneAccessory: Bool {
        get {
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone {
                addDoneButton()
            }
        }
    }
    
    func addNextPreviousDoneButtons() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [setupPreviousButton(), setupNextButton(), flexSpace, setupDoneButton()]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
    
    func addDoneButton() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        let items = [flexSpace, setupDoneButton()]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
    
    func setupDoneButton() -> UIBarButtonItem {
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        done.tintColor = Colors.darkActiveButtonColor()
        return done
    }
    
    func setupPreviousButton() -> UIBarButtonItem {
        let previous: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.previousButtonAction))
        
        previous.tintColor = Colors.darkActiveButtonColor()
        previous.image = #imageLiteral(resourceName: "collaps")
        previous.width = 30
        
        return previous
        
    }
    
    func setupNextButton() -> UIBarButtonItem {
        let next: UIBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.nextButtonAction))
        
        next.image = #imageLiteral(resourceName: "expand")
        next.tintColor = Colors.darkActiveButtonColor()
        next.width = 30
        
        return next
    }
    
    @objc func doneButtonAction() {
        delegate?.textFieldDidEndEditing?(self)
        resignFirstResponder()
    }
    
    @objc func nextButtonAction() {
        let nextTag = tag + 1
        
        if let nextResponder = superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
    
    @objc func previousButtonAction() {
        let nextTag = tag - 1
        
        if let nextResponder = superview?.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            resignFirstResponder()
        }
    }
    
}
