//
//  OutlinedInputViewWithoutHelper.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit
import InputMask

class OutlinedInputViewWithoutHelper: DemoBaseView {

    private let outlinedLayer = CAShapeLayer()
    
    private let textField = InputTextField()
    
    private let titleLabel = UILabel()
    private var titleLabelTopAnchor = NSLayoutConstraint()
    private var titleLabelBottomAnchor = NSLayoutConstraint()
    
    private let hintLabel = UILabel()
    
    private let subtitleLable = UILabel()
    
    private weak var errorHelper: OutlinedInputViewDelegate?
    
    private var state: InputViewState = .inactive {
        didSet {
            setNeedsDisplay()
            setTitleLabel(for: state)
            setHintLabel(for: state)
            setSuccessIcon(for: state)
            setTextField(for: state)
        }
    }
    
    private var stack = UIStackView()
    
    private let dropdownIcon = UIButton()
    private let clearIcon = UIButton()
    private let infoIcon = UIButton()
    private let hideTextIcon = UIButton()
    private let successIcon = UIButton()
    
    private let switcher = UISwitch()
    
    private var rules: [(String) -> (passed: Bool, errorMessage: String?)]?
    
    private var updateNext: (() -> Void)?
    
    var isCheckPassed: Bool {
        if rules == nil {
            return true
        } else {
            return rules!.allSatisfy {
                $0(textField.text ?? "").passed
            }
        }
    }
    
    private var allowedInput: String?
    
    // swiftlint:disable weak_delegate
    private var maskdelegate = MaskedTextFieldDelegate()
    // swiftlint:enable weak_delegate
    
    func setup(configuration: InputConfiguration,
               errorHelper: OutlinedInputViewDelegate? = nil,
               overlapAction: ((_: OutlinedInputViewWithoutHelper?) -> Void)? = nil) {
        
        height(56)
        self.errorHelper = errorHelper
        
        if configuration.inputMask != nil {
            maskdelegate.primaryMaskFormat = configuration.inputMask!
            textField.delegate = maskdelegate
            maskdelegate.onMaskedTextChangedCallback = {_, _, _ in self.onTextChanged()}
        }
        
        self.rules = configuration.rules
        
        allowedInput = configuration.allowedInputRegexp
        
        self.updateNext = configuration.updateNext
        
        layer.addSublayer(outlinedLayer)
        backgroundColor = .clear
        addSubview(titleLabel)
        addSubview(hintLabel)
        
        setupTextField(allowCopy: configuration.allowCopy,
                       allowPaste: configuration.allowPaste,
                       keyboardType: configuration.keyboardType,
                       beforeEditing: configuration.beforeEditing,
                       onEditing: configuration.onEditing,
                       afterEditing: configuration.afterEditing)
        setupTitleLabel(with: configuration.title)
        setupHint(with: configuration.hint)
        
        setupClearButton()
        setupSuccessIcon()
        
        stack = HStack(textField, clearIcon, successIcon).apply {
            $0.spacing = 8
            $0.alignment = .center
        }
        
        if configuration.showSwitcher {
            setupSwitcher()
            stack.addArrangedSubview(switcher)
        }
        
        if configuration.showDropdown {
            setupDropdownButton()
            stack.addArrangedSubview(dropdownIcon)
        }
        
        if configuration.showHideTextButton {
            setupHideTextButton()
            textField.apply {
                $0.isSecureTextEntry = true
                if #available(iOS 12.0, *) {
                    $0.textContentType = .oneTimeCode
                } else {
                    $0.textContentType = .init(rawValue: "")
                }
            }
            stack.addArrangedSubview(hideTextIcon)
        }
        
        if let action = configuration.infoButtonAction {
            setupInfoButton(with: action)
            stack.addArrangedSubview(infoIcon)
        }
        
        if let text = configuration.text {
            setText(text, inputMask: configuration.inputMask)
        }
        
        if let subtitle = configuration.subtitle {
            setupSubtitle(with: subtitle)
            stack.addArrangedSubview(subtitleLable)
        }
        
        addSubview(stack)
        
        _ = stack.pin(to: self, withInsets: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        if let overlapAction = overlapAction {
            let view = UIView()
            weak var weakself = self
            view.onTap {
                overlapAction(weakself)
            }
            addSubview(view)
            _ = view.pin(to: self, withInsets: .init(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        if configuration.isDisabled {
            self.state = .disabled
        }
    }
    
    func getText() -> String? {
        return textField.text
    }
    
    func setText(_ text: String, inputMask: String? = nil) {
        if inputMask != nil {
            textField.text = maskdelegate.primaryMask.apply(toText: CaretString(string: text, caretPosition: text.startIndex, caretGravity: .forward(autocomplete: false))).formattedText.string
        } else {
            textField.text = text
        }
        
        if let text = textField.text {
            state = text.isEmpty ? .inactive : .filled
        }
        
        validate()
        
        if rules != nil {
            state = isCheckPassed ? .successFilled : .errorFilled
        }
        
        if updateNext != nil {
            updateNext!()
        }
    }
    
    private func setupTitleLabel(with text: String?) {
        titleLabel.apply {
            $0.backgroundColor = .clear
            $0.leading(to: leadingAnchor, spacing: 16)
            titleLabelTopAnchor = $0.topAnchor.constraint(equalTo: topAnchor, constant: 16)
            titleLabelTopAnchor.isActive = true
            titleLabelBottomAnchor = $0.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
            titleLabelBottomAnchor.isActive = true
            TextStyles.text16Grey200.apply(to: $0)
            $0.text = text
            $0.numberOfLines = 1
        }
    }
    
    private func setTitleLabel(for state: InputViewState) {
        titleLabel.apply { _ in
            switch state {
            case .inactive:
                self.moveTitleLabelToCenter(for: state)
            case .errorFilled:
                if let text = textField.text, text.isEmpty {
                    self.moveTitleLabelToCenter(for: state)
                } else {
                    hintLabel.isHidden = false
                    self.moveTitleLabelToTop(for: state)
                }
            default:
                hintLabel.isHidden = false
                self.moveTitleLabelToTop(for: state)
            }
        }
    }
    
    private func moveTitleLabelToCenter(for state: InputViewState) {
        UIView.animate(withDuration: 0.1) {
            self.titleLabelTopAnchor.constant = 16
            self.titleLabelBottomAnchor.isActive = true
            switch state {
            case .inactive:
                TextStyles.text16Grey200.apply(to: self.titleLabel)
            case .errorFilled:
                TextStyles.text16Red.apply(to: self.titleLabel)
            default:
                TextStyles.caption12.apply(to: self.titleLabel)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func moveTitleLabelToTop(for state: InputViewState) {
        UIView.animate(withDuration: 0.1) {
            self.titleLabelTopAnchor.constant = -8
            self.titleLabelBottomAnchor.isActive = false
            switch state {
            case .disabled:
                TextStyles.caption12Grey300.apply(to: self.titleLabel)
            case .errorFilled, .errorFilling:
                TextStyles.caption12RedE1.apply(to: self.titleLabel)
            case .successFilled, .successFilling:
                TextStyles.caption12Green.apply(to: self.titleLabel)
            case .filled:
                TextStyles.caption12Grey200.apply(to: self.titleLabel)
            default:
                TextStyles.caption12.apply(to: self.titleLabel)
            }
            self.layoutIfNeeded()
        }
    }
    
    private func setupHint(with text: String?) {
        hintLabel.apply {
            $0.leading(to: leadingAnchor, spacing: 16)
            $0.top(to: topAnchor, spacing: 16)
            $0.bottom(to: bottomAnchor, spacing: -16)
            
            TextStyles.text16Grey300.apply(to: $0)
            $0.backgroundColor = .clear
            $0.text = text
            $0.numberOfLines = 1
            $0.isHidden = true
        }
    }
    
    private func setHintLabel(for state: InputViewState) {
        hintLabel.apply {
            switch state {
            case .focused:
                $0.isHidden = false
            default:
                $0.isHidden = true
            }
        }
    }
    
    private func setupClearButton() {
        clearIcon.width(24).apply {
            $0.isHidden = true
            let tintedImage = UIImage(systemName: "delete.left.fill")?.withRenderingMode(.alwaysTemplate)
            $0.imageView?.tintColor = Colors.grey300()
            $0.setImage(tintedImage, for: .normal)
            
            $0.on(event: .touchUpInside) { _ in
                self.clearIcon.isHidden = true
                self.textField.text = nil

                if self.rules != nil {
                    self.validate()
                    if self.isCheckPassed {
                        self.state = .successFilling
                    } else {
                        self.state = .errorFilling
                    }
                } else {
                    self.state = .focused
                }
                
                if self.updateNext != nil {
                    self.updateNext!()
                }
            }
        }
    }
    
    private func setupSuccessIcon() {
        successIcon.width(24).apply {
            $0.isHidden = true
            $0.setImage(UIImage(systemName: "person.fill.checkmark"), for: .normal)
            $0.tintColor = Colors.green()
        }
    }
    
    private func setSuccessIcon(for state: InputViewState) {
        switch state {
        case .successFilled:
            successIcon.isHidden = false
        default:
            successIcon.isHidden = true
        }
    }
    
    private func setupSwitcher() {
        switcher.apply {
            $0.on(event: .valueChanged, block: { _ in
                if self.switcher.isOn {
                    if let text = self.textField.text, !text.isEmpty, self.rules != nil {
                        if self.isCheckPassed {
                            self.state = .successFilled
                        } else {
                            self.state = .errorFilled
                        }
                    } else {
                        self.state = .inactive
                    }
                } else {
                    self.state = .disabled
                }
            })
            $0.height(31)
            $0.width($0.getWidthtAsIfInside(view: self))
            $0.roundsAllCorners(withRadius: 16)
            $0.isOn = true
            $0.onTintColor = Colors.red_E1()
            $0.tintColor = Colors.grey400()
            $0.backgroundColor = Colors.grey400()
            $0.thumbTintColor = Colors.white100()
        }
    }
    
    private func setupDropdownButton() {
        dropdownIcon.width(10).apply {
            let tintedImage = UIImage(systemName: "arrow.down")?.withRenderingMode(.alwaysTemplate)
            $0.imageView?.tintColor = Colors.grey300()
            $0.setImage(tintedImage, for: .normal)
        }
    }
    
    private func setupInfoButton(with action: @escaping (() -> Void)) {
        infoIcon.width(24).apply {
            $0.setImage(UIImage(systemName: "questionmark"), for: .normal)
            $0.tintColor = Colors.grey300()
            $0.on(event: .touchUpInside) { _ in action()}
        }
    }
    
    private func setupHideTextButton() {
        hideTextIcon.width(24).apply {
            $0.setImage(UIImage(systemName: "eye.slash"), for: .normal)
            $0.setImage(UIImage(systemName: "eye"), for: .selected)
            $0.tintColor = Colors.grey300()
            $0.on(event: .touchUpInside, block: { _ in
                self.hideTextIcon.isSelected = !self.hideTextIcon.isSelected
                self.textField.isSecureTextEntry = !self.hideTextIcon.isSelected
            })
        }
    }
    
    private func setupSubtitle(with text: String) {
        subtitleLable.apply {
            $0.text = text
            TextStyles.text16Grey200.apply(to: $0)
        }
        subtitleLable.width(subtitleLable.getWidthtAsIfInside(view: self))
    }
    
    private func setupTextField(allowCopy: Bool,
                                allowPaste: Bool,
                                keyboardType: UIKeyboardType,
                                beforeEditing: (() -> Void)? = nil,
                                onEditing: (() -> Void)? = nil,
                                afterEditing: (() -> Void)? = nil) {
        textField.height(24).apply {
            $0.canCopy = allowCopy
            $0.canPaste = allowPaste
            $0.keyboardType = keyboardType
            $0.doneAccessory = true
            $0.font = .systemFont(ofSize: 16)
            $0.tintColor = Colors.red_E1()
            
            $0.on(event: .editingDidBegin) { _ in
                if beforeEditing != nil {
                    beforeEditing!()
                }
                if let text = self.textField.text, text.isEmpty {
                    self.state = .focused
                    self.clearIcon.isHidden = true
                } else {
                    self.clearIcon.isHidden = false
                    self.state = .focusedFilling
                }
                self.errorHelper?.hideError()
            }
            
            $0.on(event: .editingDidEnd) { _ in
                if afterEditing != nil {
                    afterEditing!()
                }
                if let text = self.textField.text {
                    self.state = text.isEmpty ? .inactive : .filled
                }
                
                self.clearIcon.isHidden = true
                self.validate()
                if self.rules != nil {
                    self.state = self.isCheckPassed ? .successFilled : .errorFilled
                }
                
                if self.updateNext != nil {
                    self.updateNext!()
                }
            }
            
            $0.on(event: .editingChanged) { _ in
                if onEditing != nil {
                    onEditing!()
                }
                if let text = self.textField.text {
                    self.state = text.isEmpty ? .focused : .focusedFilling
                }
                self.onTextChanged()
            }
        }
    }
    
    private func setTextField(for state: InputViewState) {
        switch state {
        case .disabled:
            textField.isEnabled = false
        case .focused, .focusedFilling:
            textField.isEnabled = true
            clearIcon.isHidden = textField.text?.isEmpty ?? true
        default:
            textField.isEnabled = true
        }
    }
    
    private func onTextChanged() {
        clearIcon.isHidden = textField.text?.isEmpty ?? true
        if let allowedInput = allowedInput, let text = textField.text, !text.isEmpty, !(text ~= allowedInput) {
            textField.text!.removeLast()
        }
        validate()
        if rules != nil {
            state = isCheckPassed ? .successFilling : .errorFilling
        }
        if updateNext != nil {
            updateNext!()
        }
    }
    
    override func draw(_ rect: CGRect) {
        if let text = titleLabel.text, !text.isEmpty, state != .inactive {
            setBorder(for: rect, with: titleLabel.frame)
        } else {
            setBorder(for: rect, with: nil)
        }
    }
    
    func setBorder(for rect: CGRect, with label: CGRect? = nil) {
        
        outlinedLayer.position = CGPoint(x: 0, y: 0)
        outlinedLayer.fillColor = nil
        switch state {
        case .disabled, .inactiveFilled:
            outlinedLayer.strokeColor = Colors.grey400().cgColor
            outlinedLayer.lineWidth = 1.0
            outlinedLayer.fillColor = Colors.grey700().cgColor
        case .errorFilled:
            outlinedLayer.strokeColor = Colors.red_E1().cgColor
            outlinedLayer.lineWidth = 1.0
        case .errorFilling:
            outlinedLayer.strokeColor = Colors.red_E1().cgColor
            outlinedLayer.lineWidth = 1.5
        case .focused, .focusedFilling:
            outlinedLayer.strokeColor = Colors.black100().cgColor
            outlinedLayer.lineWidth = 1.2
        case .inactive, .filled:
            outlinedLayer.strokeColor = Colors.grey300().cgColor
            outlinedLayer.lineWidth = 1.0
        case .successFilled:
            outlinedLayer.strokeColor = Colors.green().cgColor
            outlinedLayer.lineWidth = 1.0
        case .successFilling:
            outlinedLayer.strokeColor = Colors.green().cgColor
            outlinedLayer.lineWidth = 1.5
        }
        
        if state == .inactive || (textField.text != nil && textField.text!.isEmpty && state == .errorFilled) {
            outlinedLayer.path = createBorder(for: rect).cgPath
        } else {
            outlinedLayer.path = createBorder(for: rect, with: label).cgPath
        }
    }
    
    private func createBorder(for rect: CGRect,
                              with label: CGRect? = nil,
                              radius: CGFloat = Dims.generalCornerRadius) -> UIBezierPath {
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: rect.minX + radius, y: rect.minY))
        
        if let labelRect = label {
            let leadingCornerToLabelConstant: CGFloat = 16
            let labelLeadingTrailingConstant: CGFloat = 2
            path.addLine(to: CGPoint(x: leadingCornerToLabelConstant - labelLeadingTrailingConstant, y: rect.minY))
            
            path.move(to: CGPoint(x: leadingCornerToLabelConstant +
                                    labelLeadingTrailingConstant +
                                    labelRect.width,
                                  y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        } else {
            path.addLine(to: CGPoint(x: rect.maxX - radius, y: rect.minY))
        }
        
        path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: CGFloat(3/2 * Double.pi),
                    endAngle: CGFloat(0 * Double.pi),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        
        path.addArc(withCenter: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
                    radius: radius,
                    startAngle: CGFloat(0 * Double.pi),
                    endAngle: CGFloat(1/2 * Double.pi),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        
        path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
                    radius: radius,
                    startAngle: CGFloat(1/2 * Double.pi),
                    endAngle: CGFloat(1 * Double.pi),
                    clockwise: true)
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + radius))
        
        path.addArc(withCenter: CGPoint(x: rect.minX + radius, y: rect.minY + radius),
                    radius: radius,
                    startAngle: CGFloat(1 * Double.pi),
                    endAngle: CGFloat(3/2 * Double.pi),
                    clockwise: true)
        
        return path
    }
    
    private func validate() {
        if let rules = rules, let text = textField.text, !isCheckPassed {
            errorHelper?.showError(with: rules.first { !$0(text).passed }!(text).errorMessage ?? "Error")
        } else {
            errorHelper?.hideError()
        }
    }
}
