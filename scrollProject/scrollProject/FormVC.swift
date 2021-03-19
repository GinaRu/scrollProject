//
//  FormVC.swift
//  scrollProject
//
//  Created by Georgina Rubira Pairó on 19/03/2021.
//

import Foundation
import UIKit

class FormVC: UIViewController {

    @IBAction func closeButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldDNI(_ sender: UITextField) {
        if let text = sender.text {
            registerButton.isEnabled = isValidID(text)
        }
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
    }


}
