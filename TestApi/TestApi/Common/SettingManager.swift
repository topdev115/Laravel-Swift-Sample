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
    
    func setIsSyncDarkMode(_ isSyncDarkMode: Bool) -> Void {
        UserDefaults.standard.set(isSyncDarkMode, forKey: isSyncDarkModeKey)
    }
    
    var isSyncDarkMode : Bool {
        return UserDefaults.standard.bool(forKey: isSyncDarkModeKey)
    }
    
    func clearProfile() {
        UserDefaults.standard.set("", forKey: codeKey)
        UserDefaults.standard.set(false, forKey: isSyncDarkModeKey)
    }
    
    // UserDefaults
    fileprivate let codeKey = "codeKey"
    
    fileprivate let isSyncDarkModeKey = "isSyncDarkModeKey"
}
