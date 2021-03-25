//
//  ViewController.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 19/03/2021.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet var userTextField: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var constraintLogin: NSLayoutConstraint!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        saveUsernameAndPassword()
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        userTextField.resignFirstResponder()
//        passwordTextfield.resignFirstResponder()
        // Si fem el següent, ordenem a la view que acabi la edició de tots els seus components, cosa que fa que s'amagui el teclat:
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenTapView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func saveUsernameAndPassword() {
        if let username = userTextField.text {
            KeychainService.removeString(key: .username)
            KeychainService.saveString(key: .username, data: username)
        }
        if let password = passwordTextfield.text {
            KeychainService.removeString(key: .password)
            KeychainService.saveString(key: .password, data: password)
        }
    }
    
    func LoadUsernameAndPassword () {
        let password = KeychainService.loadString(key: .password)
        let username = KeychainService.loadString(key: .username)
        userTextField.text = username
        passwordTextfield.text = password
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapView()
        LoadUsernameAndPassword()
        registerKeyboardNotifications()
        
    }
    deinit {
        removeKeyboardNotifications()
    }
}

extension LoginVC {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

                var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
            
            let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
                    let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
                    let animationCurve = UInt(exactly: curve) ?? 0
                    let durationInterval = TimeInterval(exactly: duration) ?? 0.5
        
                    UIView.animate(withDuration: durationInterval,
                                   delay: 0,
                                   options: [UIView.AnimationOptions(rawValue: animationCurve)],
                                   animations: {
                                    self.constraintLogin.constant = keyboardFrame.size.height + 8
                                    self.view.layoutIfNeeded()
                    }, completion: nil)
        

        print("EL TECLADO APARECE: \(keyboardFrame.size.height)")

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }
        let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! NSNumber
                let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber
                let animationCurve = UInt(exactly: curve) ?? 0
                let durationInterval = TimeInterval(exactly: duration) ?? 0.5
    
                UIView.animate(withDuration: durationInterval,
                               delay: 0,
                               options: [UIView.AnimationOptions(rawValue: animationCurve)],
                               animations: {
                                self.constraintLogin.constant = 40
                                self.view.layoutIfNeeded()
                }, completion: nil)
        

        print("EL TECLADO DESAPARECE")
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

