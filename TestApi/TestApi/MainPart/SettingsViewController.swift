//
//  SettingsViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

import Alamofire
import SwiftyJSON

import SwiftEventBus

class SettingsViewController: BaseViewController {
    @IBOutlet weak var codeTextField: PaddingTextField!
    @IBOutlet weak var getInfoButton: UIButton!
    @IBOutlet weak var syncDarkModeSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        syncDarkModeSwitch.isOn = SettingManager.sharedInstance.isSyncDarkMode
        
        codeTextField.delegate = self
        
        codeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        getInfoButton.layer.cornerRadius = getInfoButton.bounds.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Observe keyboard change
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        
        // Observe keyboard change
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @IBAction func onLogRequest(_ sender: UIButton) {
        view.endEditing(true)
                
        if !isValidCode(code: codeTextField.text!) {
            codeTextField.warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid Code!\nPlease enter 4 digits", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
                
        let ipAddress = getIPAddress(for: .wifi) ?? ""
        let version = UIDevice.current.systemVersion

        logRequest(code: codeTextField.text!, IPAddress: ipAddress, iOSVersion: version)
    }
    
    func isValidCode(code: String) -> Bool {
        if code.count == 4 && code.isAlphaNumeric {
            return true
        } else {
            return false
        }
    }
    
    func logRequest(code: String, IPAddress: String, iOSVersion: String) {
        if Reachability.isConnectedToNetwork() {
            self.serverRequestStart()
            
            let params = ["code": code, "ip_address": IPAddress, "ios_version": iOSVersion]
            
            Alamofire.request(Constants.API.LOG_REQUEST, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                
                switch response.result {
                case .success:
                    if let resData = response.data {
                        if let json = try? JSON(data: resData) {
                            let status = json["status"].boolValue
                            if status {
                                let result = json["result"].stringValue
                                
                                if result == "active" {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: APP_NAME, message: "Successful! your code is active now.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                            DispatchQueue.main.async {
                                                self.getInfo(code)
                                            }
                                        })
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                } else if result == "inactive" {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: APP_NAME, message: "Sorry, your code is inactive now.", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: APP_NAME, message: "Oops! your code doesn't exist!", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                                        self.present(alert, animated: true, completion: nil)
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
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: APP_NAME, message: "Oops! No server", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    
                    break
                }
                
                DispatchQueue.main.async {
                    self.serverRequestEnd()
                }
            }
        } else {
            
            // network disconnected
            DispatchQueue.main.async {
                let alert = UIAlertController(title: APP_NAME, message: "Could not connect to the server.\nPlease check the internet connection!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func getInfo(_ code: String) {
        // Save code
        SettingManager.sharedInstance.setCode(code)
        
        self.serverRequestStart()
        
        Alamofire.request(Constants.API.GET_INFO + "?code=" + code, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success:
                if let resData = response.data {
                    if let json = try? JSON(data: resData) {
                        let status = json["status"].boolValue
                        if status {
                            let mainInfo = json["main"].self
                            let servInfo = json["serv"].arrayValue
                            let linkInfo = json["link"].arrayValue
                            let abInfo = json["ab"].arrayValue
                            
                            DBManager.sharedInstance.saveData(mainInfo, servInfo, linkInfo, abInfo)
                            
                            DispatchQueue.main.async {
                                SwiftEventBus.post("loadData")
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
                
                break
            }
            
            DispatchQueue.main.async {
                self.serverRequestEnd()
            }
        }
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        codeTextField.invalidate()
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func onSyncColor(_ sender: UISwitch) {
        SettingManager.sharedInstance.setIsSyncDarkMode(sender.isOn)
        SwiftEventBus.post("setUIStyle")
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())

        return false
    }
}

// MARK: Keyboard Handling
extension SettingsViewController {
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            
            let activeTextField = self.view.selectedTextField
            
            let distanceToBottom = self.view.frame.height - ((activeTextField?.frame.origin.y)! + (activeTextField?.frame.size.height)!)
            let collapseSpace = keyboardHeight - distanceToBottom
            
            if collapseSpace > 0 {
                self.view.frame.origin.y =  -(collapseSpace + 10)
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
