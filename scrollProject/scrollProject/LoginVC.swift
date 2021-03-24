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
    
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
//        userTextField.resignFirstResponder()
//        passwordTextfield.resignFirstResponder()
        // Si fem el següent, ordenem a la view que acabi la edició de tots els seus components, cosa que fa que s'amagui el teclat:
        self.view.endEditing(true)
    }
    
    func hideKeyboardWhenTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTap()
    }


}

