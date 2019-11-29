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
    
    func setInvalidLastTime(_ invalidLastTime: Date?) -> Void {
        UserDefaults.standard.set(invalidLastTime, forKey: invalidLastTimeKey)
    }
    
    var invalidLastTime : Date? {
        return UserDefaults.standard.object(forKey: invalidLastTimeKey) as? Date
    }
    
    func setIsRedBox(_ isRedBox: Bool) -> Void {
        UserDefaults.standard.set(isRedBox, forKey: isRedBoxKey)
    }
    
    var isRedBox : Bool {
        return UserDefaults.standard.bool(forKey: isRedBoxKey)
    }
    
    func clearProfile() {
        UserDefaults.standard.set("", forKey: codeKey)
        UserDefaults.standard.set(false, forKey: isSyncDarkModeKey)
        UserDefaults.standard.set(nil, forKey: invalidLastTimeKey)
        UserDefaults.standard.set(false, forKey: isRedBoxKey)
    }
    
    // UserDefaults
    fileprivate let codeKey = "codeKey"
    fileprivate let isSyncDarkModeKey = "isSyncDarkModeKey"
    fileprivate let invalidLastTimeKey = "invalidLastTimeKey"
    fileprivate let isRedBoxKey = "isRedBoxKey"
}
