//
//  FormVC.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 19/03/2021.
//

import Foundation
import UIKit

class FormVC: UIViewController {

    
    @IBOutlet var scrollView: UIScrollView!
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func textFieldDNI(_ sender: UITextField) {
        if let text = sender.text {
            registerButton.isEnabled = isValidID(text)
        }
    }
    
    @IBOutlet var textFieldDateBirth: UITextField!
    
    let datePicker = UIDatePicker()
    
    let abc = ["T", "R", "W", "A", "G", "M", "Y", "F", "P", "D", "X", "B", "N", "J", "Z", "S", "Q", "V", "H", "L", "C", "K", "E"]
    
    func isValidID (_ documentID: String) -> Bool {
        guard let lastCharacter = documentID.last else { return false }
        if documentID.count == 9 && lastCharacter.isLetter {
            var documentID = documentID
            // Ho convertim a variable ja que els paràmetres són constants i volem variar el seu valor per treure-li la última lletra perque només ens quedin números i puguem passar el String a Int.
            documentID.removeLast()
            guard let num = Int(documentID) else { return false }
            let numResto = num % 23
            if String(lastCharacter) == abc[numResto] {
                return true
            }
        } else {
            return false
        }
        return false
    }
    
    func setUpDatePicker() {
        datePicker.datePickerMode = .date
        datePicker.sizeToFit() // Necessari perque aparegui.
        
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = .white
        textFieldDateBirth.inputView = datePicker
        
        // Toolbar:
        let toolBar = UIToolbar()

        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
            toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(donePicker))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelPicker))
      

            toolBar.setItems([ doneButton, spaceButton, cancelButton], animated: false)
       
        textFieldDateBirth.inputAccessoryView = toolBar
 
    }
    
    @objc func donePicker() {
        print("done pitjat")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium

        textFieldDateBirth.text = dateFormatter.string(from: datePicker.date)
              //  self.view.endEditing(true) Això amaga el teclat tambè. 
        textFieldDateBirth.resignFirstResponder()
    }
    @objc func cancelPicker() {
        print("cancel pitjat")
        textFieldDateBirth.resignFirstResponder()
    }
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        guard let lastLetter = textField.text?.last else { return }
//
//        if textField.text?.count == 9 && lastLetter.isLetter {
//            registerButton.isEnabled = true
//        } else {
//            registerButton.isEnabled = false
//        }
////        if textField.text != "" {
////            print(textField.text ?? "hey")
////        }
//    }
    
    @IBOutlet var registerButton: UIButton!
    
    @IBAction func registerTouched(_ sender: Any) {
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.isEnabled = false
        registerKeyboardNotifications()
        setUpDatePicker()
        
    }

    deinit {
        removeKeyboardNotifications()
    }

}

extension FormVC {
    
    func registerKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo else { return }

                var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var newInset: UIEdgeInsets = self.scrollView.contentInset
        newInset.bottom = keyboardFrame.size.height + 8
        scrollView.contentInset = newInset
        scrollView.scrollIndicatorInsets = newInset
        print("EL TECLADO APARECE")

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        print("EL TECLADO DESAPARECE")
    }

    func removeKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    // Aquesta funció és per si l'objecte que estem escoltant deixa d'existir. En un moment ens afegim com a observador i en aquest hi sortim perque ja no ens interessa.

    }
}
