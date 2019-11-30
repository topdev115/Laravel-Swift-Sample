//
//  TabController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/29.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftEventBus

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SwiftEventBus.onMainThread(self, name: "setUIStyle") { notification in
            self.setUIStyle()
        }
        
        SwiftEventBus.onMainThread(self, name: "checkCode") { notification in
            self.checkCode()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUIStyle()
    }
    
    func setUIStyle() {
        if #available(iOS 13.0, *) {
            if SettingManager.sharedInstance.isSyncDarkMode {
                self.overrideUserInterfaceStyle = UITraitCollection.current.userInterfaceStyle
            } else {
                self.overrideUserInterfaceStyle = .light
            }
        }
    }
    
    func checkCode() {
        if let code = SettingManager.sharedInstance.code {
            if Reachability.isConnectedToNetwork() {
                self.serverRequestStart()
                
                let params = ["code": code]
                
                Alamofire.request(Constants.API.CHECK_CODE, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                    
                    switch response.result {
                    case .success:
                        if let resData = response.data {
                            if let json = try? JSON(data: resData) {
                                let status = json["status"].boolValue
                                if status {
                                    let result = json["result"].stringValue
                                    
                                    if result == "active" {
                                        if SettingManager.sharedInstance.invalidLastTime != nil {
                                            SettingManager.sharedInstance.setInvalidLastTime(nil)
                                            
                                            if !Constants.SUPPRESSABLE {                                            DispatchQueue.main.async {
                                                    let alert = UIAlertController(title: APP_NAME, message: Constants.SUP_ACTIVE_MESSAGE, preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                                        SettingManager.sharedInstance.setIsRedBox(false)
                                                        
                                                        DispatchQueue.main.async {
                                                            SwiftEventBus.post("redBox")
                                                        }
                                                    })
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            } else {
                                                SettingManager.sharedInstance.setIsRedBox(false)
                                                DispatchQueue.main.async {
                                                    SwiftEventBus.post("redBox")
                                                }
                                            }
                                        }
                                    } else if result == "inactive" {
                                        if SettingManager.sharedInstance.invalidLastTime != nil {
                                            let dT = Int(Date().timeIntervalSince1970 - SettingManager.sharedInstance.invalidLastTime!.timeIntervalSince1970) / 60
                                            
                                            if dT >= Constants.W * Constants.X {
                                                if !Constants.SUPPRESSABLE {
                                                    DispatchQueue.main.async {
                                                        let alert = UIAlertController(title: APP_NAME, message: String(format: Constants.SUP_INACTIVE_MESSAGE2, Constants.W * Constants.X), preferredStyle: .alert)
                                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                                            SettingManager.sharedInstance.setIsRedBox(true)
                                                            
                                                            DispatchQueue.main.async {
                                                                SwiftEventBus.post("redBox")
                                                            }
                                                        })
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                } else {
                                                    SettingManager.sharedInstance.setIsRedBox(true)
                                                    
                                                    DispatchQueue.main.async {
                                                        SwiftEventBus.post("redBox")
                                                    }
                                                }
                                            } else {
                                                if !Constants.SUPPRESSABLE {
                                                    DispatchQueue.main.async {
                                                        let alert = UIAlertController(title: APP_NAME, message: Constants.SUP_INACTIVE_MESSAGE1, preferredStyle: .alert)
                                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                                        self.present(alert, animated: true, completion: nil)
                                                    }
                                                }
                                            }
                                        } else {
                                            SettingManager.sharedInstance.setInvalidLastTime(Date())
                                            if !Constants.SUPPRESSABLE {
                                                DispatchQueue.main.async {
                                                    let alert = UIAlertController(title: APP_NAME, message: Constants.SUP_INACTIVE_MESSAGE1, preferredStyle: .alert)
                                                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                                                    self.present(alert, animated: true, completion: nil)
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    if let msg = json["message"].string {
                                        self.showSnackbar(message: msg)
                                    }
                                }
                            }
                        }
                        break
                    case .failure(let error):
                        print(error)
                    }
                    
                    DispatchQueue.main.async {
                        self.serverRequestEnd()
                    }
                }
            }
        }
    }
}
