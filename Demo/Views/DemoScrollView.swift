//
//  DemoScrollView.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class DemoScrollView: UIScrollView {
    func setup(color: UIColor = Colors.newWhiteColor()) {
        apply {
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.backgroundColor = color
            
            // Нужно для того, чтобы быстрое нажание на кнопку позволяло сработать state = .highlighted
            $0.delaysContentTouches = false
            
            $0.alwaysBounceVertical = false
            $0.bounces = true
        }
    }
}
