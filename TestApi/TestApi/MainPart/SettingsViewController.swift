//
//  SettingsViewController.swift
//  TestApi
//
//  Created by Administrator on 2019/11/14.
//

import UIKit

import Alamofire
import SwiftyJSON

class SettingsViewController: UIViewController {
    @IBOutlet weak var codeTextField: PaddingTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        codeTextField.delegate = self
        
        codeTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
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

    @IBAction func onSaveSetting(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        
        if !isValidCode(code: codeTextField.text!) {
            codeTextField.warning()
            
            let alert = UIAlertController(title: APP_NAME, message: "Invalid Code", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        save(code: codeTextField.text!)
    }
    
    func isValidCode(code: String) -> Bool {
        if code.count == 4 && code.isNumeric {
            return true
        } else {
            return false
        }
    }
    
    func save(code: String) {
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
                                let checked = json["checked"].boolValue
                                if checked {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: APP_NAME, message: "Verified your code successfully!", preferredStyle: .alert)
                                        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { action in
                                            
                                            // Save code
                                            SettingManager.sharedInstance.setCode(code)
                                        })
                                        self.present(alert, animated: true, completion: nil)
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: APP_NAME, message: "Your code doesn't exist!", preferredStyle: .alert)
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
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        codeTextField.invalidate()
    }
    
    @IBAction func onTappedBackground(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension SettingsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
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
