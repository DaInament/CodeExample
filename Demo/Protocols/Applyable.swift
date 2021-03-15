//
//  Applyable.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import Foundation

protocol Applyable {}

extension Applyable {
    @discardableResult func apply(_ block: (Self) -> Void ) -> Self {
        block(self)
        return self
    }
}

extension NSObject: Applyable {}
