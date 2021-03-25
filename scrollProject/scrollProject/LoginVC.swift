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
            KeychainService.removeString(key: .user)
            KeychainService.saveString(key: .user, data: username)
        }
        if let password = passwordTextfield.text {
            KeychainService.removeString(key: .pass)
            KeychainService.saveString(key: .pass, data: password)
        }
    }
    
    func LoadUsernameAndPassword () {
        let password = KeychainService.loadString(key: .pass)
        let username = KeychainService.loadString(key: .user)
        userTextField.text = username
        passwordTextfield.text = password
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTapView()
        LoadUsernameAndPassword()
    }
}

