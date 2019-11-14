//
//  Extensions.swift
//  TestApi
//
//  Created by Administrator on 2019/11/13.
//

import UIKit
import MaterialComponents.MaterialSnackbar

extension Data {
    mutating func append(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}

extension String {
    var localizedString: String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(_ comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    var isNumeric: Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
}

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIViewController {
    func serverRequestStart() { LoadingIndicatorView.show("Loading...".localizedString);
    }
    
    func serverRequestEnd() {
        LoadingIndicatorView.hide();
    }
    
    func showSnackbar(message: String) {
        let msg = MDCSnackbarMessage()
        msg.text = message
        MDCSnackbarManager.show(msg)
    }
}

extension UIView {
    var textFieldsInView: [UITextField] {
        return subviews
            .filter ({ !($0 is UITextField) })
            .reduce (( subviews.compactMap { $0 as? UITextField }), { summ, current in
                return summ + current.textFieldsInView
            })
    }
    
    var selectedTextField: UITextField? {
        return textFieldsInView.filter { $0.isFirstResponder }.first
    }
}
