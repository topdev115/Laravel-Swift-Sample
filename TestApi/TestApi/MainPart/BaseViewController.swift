//
//  BaseViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/29.
//

import UIKit
import SwiftEventBus

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        SwiftEventBus.onMainThread(self, name: "setUIStyle") { notification in
            self.setUIStyle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUIStyle()
    }
    
    func setUIStyle() {
        if #available(iOS 13.0, *) {
            if SettingManager.sharedInstance.isSyncDarkMode {
                self.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
                self.navigationController?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            } else {
                self.overrideUserInterfaceStyle = .light
                self.navigationController?.overrideUserInterfaceStyle = .light
            }
        }
    }
}

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SwiftEventBus.onMainThread(self, name: "setUIStyle") { notification in
            self.setUIStyle()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setUIStyle()
    }
    
    func setUIStyle() {
        if #available(iOS 13.0, *) {
            if SettingManager.sharedInstance.isSyncDarkMode {
                self.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
                self.navigationController?.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            } else {
                self.overrideUserInterfaceStyle = .light
                self.navigationController?.overrideUserInterfaceStyle = .light
            }
        }
    }
}
