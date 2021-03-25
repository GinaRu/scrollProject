//
//  KeyboardNotificable.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 25/03/2021.
//

import UIKit
import Foundation

class BaseVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerKeyboardNotifications()
    }
    deinit {
        removeKeyboardNotifications()
    }
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // Functions to implement in child classes
    
    @objc func keyboardWillShow(notification: NSNotification) { }
    
    @objc func keyboardWillHide(notification: NSNotification) { }

}
