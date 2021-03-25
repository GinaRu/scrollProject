//
//  FormVC.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 19/03/2021.
//

import Foundation
import UIKit

class FormVC: BaseVC {

    @IBOutlet var textFieldPassword: UITextField!
    @IBOutlet var labelPassword: UILabel!
    
    @IBOutlet var textFieldDNIOutlet: UITextField!

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageViewLogo: UIImageView!
    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func textFieldDNI(_ sender: UITextField) {
        if let text = sender.text {
            registerButton.isEnabled = isValidID(text)
        }
    }
    
    @IBOutlet var textFieldDateBirth: UITextField!
    @IBOutlet var registerButton: UIButton!
    @IBAction func registerTouched(_ sender: Any) {
        guard let password = textFieldPassword.text else { return }
        let (isValid, errorMessage) = isValidPassword(password: password)
        if isValid == true {
            labelPassword.text = errorMessage
            labelPassword.textColor = .green
        } else if isValid == false {
            labelPassword.text = errorMessage
            labelPassword.textColor = .red
        }
        // if passwordisValid() = true
        // label: "password correcte" (en verd)
        // else if passwordisValid() = false:
        // altre funció.
        // label: "The password must contain a capital letter.
    }
    
    
    let datePicker = UIDatePicker()
    
    
    
    func isValidPassword (password: String) -> (Bool, String) {
        var resultMessage = ""
        var isValid = true
  
        if password.count < 6 {
            resultMessage += "Too short. Must contain 6 characters. "
            isValid = false
        }
        if password.rangeOfCharacter(from: CharacterSet.alphanumerics) == nil {
            resultMessage += "Must contain one number."
            isValid = false
        }
        if password.rangeOfCharacter(from: CharacterSet.uppercaseLetters) == nil {
            resultMessage += "Must contain one uppercase letter. "
            isValid = false
        }
        if password.rangeOfCharacter(from: CharacterSet.symbols) == nil {
            resultMessage += "Must contain one symbol. "
            isValid = false
        } else {
            resultMessage = "Congratulations! Your password is safe enought."
            isValid = true
        }
        return (isValid, resultMessage)
    }
    
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
        if textFieldDateBirth.text != "" {
            textFieldDateBirth.text = ""
        }
        textFieldDateBirth.resignFirstResponder()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        imageViewLogo.image = UIImage(named: "logo")
        registerButton.isEnabled = false
    
        setUpDatePicker()
    }
    
    @objc override func keyboardWillShow(notification: NSNotification) {
        // Si volguessim que fes tambè el que fa la funció de BaseVC (ara no fa res però li podriem dir que fes algo), només hauriem de cridarla abans del que ve a continuació així:
        // super.keyboardWillShow(notification: notification)
        // Hem agafat el mateix paràmetre perquè realment és la mateixa funció, només que en aquest VC l'estem overriding.
        
        
        guard let userInfo = notification.userInfo else { return }

                var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
                keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var newInset: UIEdgeInsets = self.scrollView.contentInset
        newInset.bottom = keyboardFrame.size.height + 8
        scrollView.contentInset = newInset
        scrollView.scrollIndicatorInsets = newInset
        print("EL TECLADO APARECE")

    }

    @objc override func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset = UIEdgeInsets.zero
        scrollView.scrollIndicatorInsets = UIEdgeInsets.zero
        print("EL TECLADO DESAPARECE")
    }
}


