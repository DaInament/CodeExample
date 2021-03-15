//
//  TextStyle.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

class TextStyles {
    
    static let text16Grey200: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 16)
        label.textColor = Colors.grey200()
    }
    
    static let text16Grey300: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 16)
        label.textColor = Colors.grey300()
    }
    
    static let text16Red: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 16)
        label.textColor = Colors.red200()
    }
    
    static let caption12: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.black100()
    }
    
    static let caption12Grey200: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.grey200()
    }
    
    static let caption12Grey300: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.grey300()
    }
    
    static let caption12RedE1: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.red_E1()
    }
    
    static let caption12Green: TextStyleConstructor<UILabel> = TextStyleConstructor { label in
        label.font = .systemFont(ofSize: 12)
        label.textColor = Colors.green()
    }
}
