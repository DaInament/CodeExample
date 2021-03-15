//
//  LoginScreen.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class LoginScreen: BaseScreen {
    let scrollView = DemoScrollView()
    let loginInputView = OutlinedInputView()
    let passwordInputView = OutlinedInputView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    private func setupViews() {
        view.apply {
            $0.backgroundColor = .white
            $0.addSubview(scrollView)
        }
        
        let inputStack = VStack(loginInputView,
                                passwordInputView)
        
        scrollView.apply {
            $0.setup()
            $0.top(to: view.topAnchor)
            $0.bottom(to: view.bottomAnchor)
            $0.trailing(to: view.trailingAnchor)
            $0.leading(to: view.leadingAnchor)
            $0.addSubview(inputStack)
        }
        
        inputStack.apply {
            $0.widthEqualTo(scrollView)
            $0.centerY(to: scrollView)
            $0.leading(to: scrollView.leadingAnchor)
            $0.trailing(to: scrollView.trailingAnchor)
        }
        
        loginInputView.setup(configuration:
                                InputConfiguration(title: "Логин",
                                                   rules: [{ text -> (passed: Bool, errorMessage: String?) in
                                                    if !(text ~= "^[А-Яа-я]+$") {
                                                        return (false, "Только кириллица")
                                                    }
                                                    return (true, nil)
                                                   }]))
        passwordInputView.setup(configuration:
                                    InputConfiguration(title: "Пароль",
                                                       rules: [{ text -> (passed: Bool, errorMessage: String?) in
                                                        if !(text ~= "^[0-9]+$") {
                                                            return (false, "Только цифры")
                                                        }
                                                        return (true, nil)
                                                       }],
                                                       showHideTextButton: true))
        
        if let bottomConstraint = view.bottomConstraint() {
            pinToKeyboard(bottomConstraint)
        }
    }
}

