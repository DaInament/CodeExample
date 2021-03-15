//
//  UIControl.swift
//  Demo
//
//  Created by Никита Рысин on 15.03.2021.
//

import UIKit

// MARK: UIControl Block based actions
typealias ActionBlock = (UIControl) -> Void

class UIButtonActionDelegate: NSObject {
    let actionBlock: ActionBlock
    init(actionBlock: @escaping ActionBlock) {
        self.actionBlock = actionBlock
    }
    @objc func triggerBlock(control: UIControl) {
        actionBlock(control)
    }
}

private var actionHandlersKey: UInt8 = 0
extension UIControl {
    var actionHandlers: NSMutableArray { // cat is *effectively* a stored property
        get {
            return associatedObject(base: self, key: &actionHandlersKey, initialiser: { () -> NSMutableArray in
                return NSMutableArray()
            })
        }
        set { associateObject(base: self, key: &actionHandlersKey, value: newValue) }
    }
    
    func on(event: UIControl.Event, block: @escaping ActionBlock) {
        let actionDelegate = UIButtonActionDelegate(actionBlock: block)
        actionHandlers.add(actionDelegate) // So it gets retained
        addTarget(actionDelegate, action: #selector(UIButtonActionDelegate.triggerBlock(control:)), for: event)
    }
}

// MARK: Associated Object wrapper

func associatedObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    initialiser: () -> ValueType)
    -> ValueType {
        if let associated = objc_getAssociatedObject(base, key)
            as? ValueType { return associated }
        let associated = initialiser()
        objc_setAssociatedObject(base, key, associated,
                                 .OBJC_ASSOCIATION_RETAIN)
        return associated
}

func associateObject<ValueType: AnyObject>(
    base: AnyObject,
    key: UnsafePointer<UInt8>,
    value: ValueType) {
    objc_setAssociatedObject(base, key, value,
                             .OBJC_ASSOCIATION_RETAIN)
}
