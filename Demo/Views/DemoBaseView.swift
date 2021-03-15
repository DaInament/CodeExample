//
//  DemoBaseView.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class DemoBaseView: UIView {
    
    var borders: [Side]?
    
    var spacing: CGFloat?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        if let borders = borders, !borders.isEmpty {
            addBorder(to: borders,
                      spacing: spacing)
        }
    }
}
