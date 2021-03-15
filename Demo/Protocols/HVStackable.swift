//
//  HVStackable.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import Foundation
import UIKit

protocol HVStackable {}

extension HVStackable {
    func VStack(_ views: UIView...) -> UIStackView {
        UIStackView().apply { stack in
            views.forEach { stack.addArrangedSubview($0) }
            stack.axis = .vertical
        }
    }

    func HStack(_ views: UIView...) -> UIStackView {
        UIStackView().apply { stack in
            views.forEach { stack.addArrangedSubview($0) }
            stack.axis = .horizontal
            stack.alignment = .top
        }
    }
}

extension NSObject: HVStackable {}



