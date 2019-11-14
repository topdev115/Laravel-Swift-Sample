//
//  PaddingTextField.swift
//  TestApi
//
//  Created by Administrator on 2019/11/13.
//

import UIKit

class PaddingTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.borderColor = UIColor.red.cgColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        layer.borderColor = UIColor.red.cgColor
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    func warning() {
        layer.borderWidth = 1.0
    }
    
    func invalidate() {
        layer.borderWidth = 0.0
    }
    
    func isEmpty() -> Bool? {
        if self.text!.isEmpty {
            layer.borderWidth = 1.0
        }
        
        return self.text?.isEmpty
    }
}
