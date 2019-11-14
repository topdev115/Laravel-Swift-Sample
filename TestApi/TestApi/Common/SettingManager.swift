//
//  Setting.swift
//  TestApi
//
//  Created by Administrator on 2019/11/13.
//

import UIKit

class SettingManager {
    
    static let sharedInstance = SettingManager()
    
    func setCode(_ code: String?) -> Void {
        UserDefaults.standard.set(code, forKey: codeKey)
    }
    
    var code : String? {
        return UserDefaults.standard.string(forKey: codeKey)
    }
    
    func clearProfile() {
        UserDefaults.standard.set("", forKey: codeKey)
    }
    
    // UserDefaults
    fileprivate let codeKey = "codeKey"
}
