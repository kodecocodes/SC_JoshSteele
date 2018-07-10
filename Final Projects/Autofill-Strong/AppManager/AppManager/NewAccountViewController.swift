//
//  NewAccountViewController.swift
//  AppManager
//
//  Created by Teacher on 6/10/18.
//  Copyright © 2018 Andy Pereira. All rights reserved.
//

import UIKit

class NewAccountViewController: UIViewController {

  @IBOutlet weak var userNameTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var continueButton: UIButton!
  
  override func viewDidLoad() {
        super.viewDidLoad()
    passwordTextField.textContentType = .newPassword
    passwordTextField.isSecureTextEntry = true
      enableLoginButton(false)
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    print("new account disappeared")
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  @IBAction func login(_ sender: Any) {
//    LoginStatus.loggedIn = true
    performSegue(withIdentifier: "Registered", sender: self)
  }
  
  private func validate(username: String?, password: String?) -> Bool {
    guard let username = username,
      let password = password,
      username.count >= 5,
      password.count >= 5 else {
        return false
    }
    return true
  }
  
  private func enableLoginButton(_ enable: Bool) {
    continueButton.isEnabled = enable
    continueButton.alpha = enable ? 1.0 : 0.5
  }
  
  @IBAction func accountCreated(segue: UIStoryboardSegue) {
    print("dismissing, account created")
    dismiss(animated: true, completion: nil)
  }
}


extension NewAccountViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField,
                 shouldChangeCharactersIn range: NSRange,
                 replacementString string: String) -> Bool {
    
    var usernameText = userNameTextField.text
    var passwordText = passwordTextField.text
    if let text = textField.text {
      
      let proposed = (text as NSString)
        .replacingCharacters(in: range, with: string)
      if textField == userNameTextField {
        usernameText = proposed
      } else {
        passwordText = proposed
      }
    }
    // 4
    let isValid = validate(username: usernameText,
                           password: passwordText)
    enableLoginButton(isValid)
    return true
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField == userNameTextField {
      passwordTextField.becomeFirstResponder()
    } else {
      passwordTextField.resignFirstResponder()
      if validate(username: userNameTextField.text,
                  password: passwordTextField.text) {
        login(continueButton)
      }
    }
    return false
  }
}
