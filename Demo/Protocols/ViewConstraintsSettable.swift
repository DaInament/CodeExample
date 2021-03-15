//
//  ViewConstraintsSettable.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

protocol ViewConstraintsSettable {
    
}

extension ViewConstraintsSettable where Self: UIView {
    
    /// Центрирует объект относительно указанного по оси X
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func centerX(to view: UIView) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        return self
    }
    
    /// Центрирует объект относительно указанного по оси Y
    /// - Parameter height: константа высоты
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func centerY(to view: UIView, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: spacing).isActive = true
        return self
    }
    
    /// Задает высоту обьекту, при этом отключая все ранее заданные высоты
    /// - Parameter _: константа высоты
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func height(_ height: CGFloat) -> Self {
        constraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.height && $0.isActive == true }.forEach { $0.isActive = false }
        
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        return self
    }
    
    ///Растягивает обьект относительно высоты superview с указанными параметрами:
    /// - Parameter percents: на сколько % от высоты superview должен растянуться обьект, по умолчанию = 100%
    /// - Parameter plus: константа, которая добавляется к высоте после расчета на основе percents, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func heightToMax(percents: CGFloat = 100, plus: CGFloat = 0) -> Self {
        DispatchQueue.main.async {
            if let superHeight = self.superview?.heightAnchor {
                self.heightAnchor.constraint(equalTo: superHeight, multiplier: percents/100, constant: plus).isActive = true
            }
        }
        return self
    }
    
    /// Задает ширину обьекту, при этом отключая все ранее заданные констрейнты ширины
    /// - Parameter _: константа ширины
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func width(_ width: CGFloat) -> Self {
        constraints.filter { $0.firstAttribute == NSLayoutConstraint.Attribute.width && $0.isActive == true }.forEach { $0.isActive = false }
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        return self
    }
    
    /// Задает ширину обьекту равную заданному вью с указанием множителя
    /// - Parameter _: заданный вью
    /// - Parameter multiplier: множитель
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func widthEqualTo(_ view: UIView, multiplier: CGFloat = 1) -> Self {
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: multiplier).isActive = true
        return self
    }
    
    ///Растягивает обьект относительно ширины superview с указанными параметрами:
    /// - Parameter percents: на сколько % от ширины superview должен растянуться обьект, по умолчанию = 100%
    /// - Parameter plus: константа, которая добавляется к ширине после расчета на основе percents, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func widthToMax(percents: CGFloat = 100, plus: CGFloat = 0) -> Self {
        DispatchQueue.main.async {
            if let superWidth = self.superview?.widthAnchor {
                self.widthAnchor.constraint(equalTo: superWidth, multiplier: percents/100, constant: plus).isActive = true
            }
        }
        return self
    }
    
    /// Создает связь между верхним якорем и указанным верхним якорем с отступом
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter spacing: какой должен быть отступ, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func top(to anchor: NSLayoutYAxisAnchor, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
        return self
    }
    
    /// Создает связь между нижним якорем и указанным нижним якорем с отступом
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter spacing: какой должен быть отступ, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func bottom(to anchor: NSLayoutYAxisAnchor, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        let bottomConstraint = bottomAnchor.constraint(equalTo: anchor, constant: spacing)
        bottomConstraint.isActive = true
        bottomConstraint.identifier = "Bottom Constraint"
        return self
    }
    
    /// Создает связь между нижним якорем и указанным нижним якорем с отступом
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter spacing: какой должен быть отступ, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func bottomSafeArea(to anchor: NSLayoutYAxisAnchor, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        safeAreaLayoutGuide.bottomAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
        return self
    }
    
    /// Создает связь между левым якорем и указанным левым якорем с отступом
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter spacing: какой должен быть отступ, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func leading(to anchor: NSLayoutXAxisAnchor, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        leadingAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
        return self
    }
    
    /// Создает связь между правым якорем и указанным правым якорем с отступом
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter spacing: какой должен быть отступ, по умолчанию 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func trailing(to anchor: NSLayoutXAxisAnchor, spacing: CGFloat = 0) -> Self {
        translatesAutoresizingMaskIntoConstraints = false
        trailingAnchor.constraint(equalTo: anchor, constant: spacing).isActive = true
        return self
    }
    
    /// Создает связь между между обьектом и указанным обьектом с отступами
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter withInsets: какие должны быть отступы, по умолчанию - со всех сторон 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func pin(to view: UIView, withInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> Self {
        _ = top(to: view.topAnchor, spacing: withInsets.top)
            .bottom(to: view.bottomAnchor, spacing: -withInsets.bottom)
            .leading(to: view.leadingAnchor, spacing: withInsets.left)
            .trailing(to: view.trailingAnchor, spacing: -withInsets.right)
        return self
    }
    
    /// Создает связь между между обьектом и указанным обьектом с отступами
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter withInsets: какие должны быть отступы, по умолчанию - со всех сторон 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func pinWithSafeArea(to view: UIView, withInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> Self {
        _ = top(to: view.safeAreaLayoutGuide.topAnchor, spacing: withInsets.top)
            .bottom(to: view.safeAreaLayoutGuide.bottomAnchor, spacing: -withInsets.bottom)
            .leading(to: view.leadingAnchor, spacing: withInsets.left)
            .trailing(to: view.trailingAnchor, spacing: -withInsets.right)
        return self
    }
    
    /// Создает связь между между обьектом и указанным обьектом без указания нижнего констрейнта с отступами
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter withInsets: какие должны быть отступы, по умолчанию - со всех сторон 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func pinWithoutBottom(to view: UIView, withInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> Self {
        _ = top(to: view.topAnchor, spacing: withInsets.top)
            .leading(to: view.leadingAnchor, spacing: withInsets.left)
            .trailing(to: view.trailingAnchor, spacing: -withInsets.right)
        return self
    }
    
    /// Создает связь между между обьектом и указанным объектом без указания верхнего констрейнта с отступами
    /// - Parameter to: к чему должен быть прикреплен обьект
    /// - Parameter withInsets: какие должны быть отступы, по умолчанию - со всех сторон 0
    /// - Returns: Возращает самого себя для цепочной обработки обьекта
    @discardableResult func pinWithoutTop(to view: UIView, withInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)) -> Self {
        bottom(to: view.safeAreaLayoutGuide.bottomAnchor, spacing: -withInsets.bottom)
        leading(to: view.leadingAnchor, spacing: withInsets.left)
        trailing(to: view.trailingAnchor, spacing: -withInsets.right)
        return self
    }
}
