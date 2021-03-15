//
//  UIView.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

extension UIView: ViewConstraintsSettable {
    
    enum Side {
        case top
        case bottom
        case left
        case right
    }
    
    /// Добавляет к вьюхе цветную границу с определенной шириной к указанным сторонам
    /// - Parameter to: массив сторон Side, к которым нужно добавить границу
    /// - Parameter color: цвет границы
    /// - Parameter borderWidth: ширина границы

    func addBorder(to sides: [Side],
                   spacing: CGFloat? = nil,
                   color: UIColor = Colors.grey500(),
                   borderWidth: CGFloat = 1) {
        if let subs = layer.sublayers {
            subs.filter { $0.borderColor != nil && $0.borderColor == color.cgColor && $0.borderWidth == borderWidth}.forEach {
                $0.removeFromSuperlayer()
            }
        }
        sides.forEach { side in
            let subLayer = CALayer()
            subLayer.borderColor = color.cgColor
            subLayer.borderWidth = borderWidth
            let origin = findOrigin(side: side, borderWidth: borderWidth)
            let size = findSize(side: side, borderWidth: borderWidth)
            if spacing != nil, sides.count == 1, sides.contains(.bottom) {
                subLayer.frame = CGRect(origin: CGPoint(x: origin.x + spacing!, y: origin.y), size: size)
            } else {
                subLayer.frame = CGRect(origin: origin, size: size)
            }
            
            layer.addSublayer(subLayer)
        }
    }
    
    private func findOrigin(side: Side, borderWidth: CGFloat) -> CGPoint {
        switch side {
        case .right:
            return CGPoint(x: frame.width - borderWidth, y: 0)
        case .bottom:
            return CGPoint(x: 0, y: frame.height - borderWidth)
        default:
            return .zero
        }
    }
    
    private func findSize(side: Side, borderWidth: CGFloat) -> CGSize {
        switch side {
        case .left, .right:
            return CGSize(width: borderWidth, height: frame.height)
        case .top, .bottom:
            return CGSize(width: frame.width, height: borderWidth)
        }
    }
    
    /// Получение всех сабвью
    func allSubviews() -> [UIView] {
        var result = subviews
        for subview in subviews {
            result += subview.allSubviews()
        }
        return result
    }
    
    /// Получение всех сабвью указанного типа
    func allSubviews<T: UIView>(of type: T.Type) -> [T] {
        return allSubviews().compactMap({ $0 as? T })
    }
    
    /// Удаляет из обьекта все вложенные обьекты
    func removeAllSubviews() {
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    /// Закругляет указанные углы по заданному значению округления
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    /// Закругляет все углы по заданному значению округления
    func roundsAllCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner,
                               .layerMinXMaxYCorner,
                               .layerMaxXMinYCorner,
                               .layerMaxXMaxYCorner]
    }
    
    /// Закругляет верхние углы по заданному значению округления
    func roundsTopCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    /// Закругляет нижние углы по заданному значению округления
    func roundsBottomCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    /// Закругляет левые углы по заданному значению округления
    func roundsLeftSideCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner]
    }
    
    /// Закругляет левые углы по заданному значению округления
    func roundsRightSideCorners(withRadius radius: CGFloat) {
        layer.cornerRadius = radius
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
    }
    
    /// Предоставляет высоту вью, как будто бы она находится внутри указанного вью. Используется, в основном с UITextView, для корректного AutoLayout
    func getHeightAsIfInside(view: UIView) -> CGFloat {
        view.addSubview(self)
        
        top(to: view.topAnchor).leading(to: view.leadingAnchor).trailing(to: view.trailingAnchor)
        sizeToFit()
        let height = sizeThatFits(CGSize(width: view.frame.width, height: 100000)).height
        removeFromSuperview()
        return height
    }
    
    /// Предоставляет ширину вью, как будто бы она находится внутри указанного вью. Используется, в основном с UITextView, для корректного AutoLayout
    func getWidthtAsIfInside(view: UIView) -> CGFloat {
        view.addSubview(self)
        
        top(to: view.topAnchor).leading(to: view.leadingAnchor).trailing(to: view.trailingAnchor)
        sizeToFit()
        let width = sizeThatFits(CGSize(width: 100000, height: view.frame.height)).width
        removeFromSuperview()
        return width
    }
    
    /// Получение нижнего констрейнта
    func bottomConstraint() -> NSLayoutConstraint? {
        if let constraint = constraints.filter({ $0.identifier == "Bottom Constraint" && $0.secondItem?.identifier == "UIViewSafeAreaLayoutGuide" }).first {
            return constraint
        } else if let constraint = constraintsAffectingLayout(for: .vertical).first(where: { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }) {
            return constraint
        } else if let constraint = safeAreaLayoutGuide.constraintsAffectingLayout(for: .vertical).first(where: { $0.firstAttribute == .bottom && $0.secondAttribute == .bottom }) {
            return constraint
        } else {
            return nil
        }
    }
    
    /// Добавляет событие, которое сработает после тапа на обьект
    @objc func onTap(block: @escaping () -> Void) {
        _ = TapGestureRecognizerHandler(block: block, view: self)
    }
    
    func isHiddenAnimated(_ value: Bool, duration: Double = 0.2) {
            UIView.animate(withDuration: duration) { [weak self] in self?.isHidden = value }
        }
}

private class TapGestureRecognizerHandler: NSObject {
    let block: () -> Void
    
    @discardableResult init (block: @escaping () -> Void, view: UIView) {
        self.block = block
        super.init()
        let gestureRcognizer = UITapGestureRecognizer(target: self, action: #selector(didTap(sender:)))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(gestureRcognizer)
        
        var kSomeKey = "s"
        // Закидываем рекогнайзер внутрь вьюхи, что бы arc не убивал его пока он нужен
        objc_setAssociatedObject(view, &kSomeKey, self, .OBJC_ASSOCIATION_RETAIN)
    }
    
    @objc func didTap(sender: Any) {
        block()
    }
    
}

extension ExpressibleByFloatLiteral where Self: UIView {
    
    public init(floatLiteral value: Double) {
        self = UIView() as! Self
        let height = heightAnchor.constraint(equalToConstant: CGFloat(value))
        let width = widthAnchor.constraint(equalToConstant: CGFloat(value))
        
        DispatchQueue.main.async { [weak self] in
            (self?.superview as? UIStackView).map {
                if $0.axis == .vertical { height.isActive = true }
                if $0.axis == .horizontal { width.isActive = true }
            }
        }
    }
}

extension ExpressibleByIntegerLiteral where Self: UIView {
    
    public init(integerLiteral value: Int) {
        self = UIView(floatLiteral: Double(value)) as! Self
    }
}

extension UIView: ExpressibleByFloatLiteral {
    public typealias FloatLiteralType = Double
}

extension UIView: ExpressibleByIntegerLiteral {
    public typealias IntegerLiteralType = Int
}
