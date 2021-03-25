//
//  KeychainService.swift
//  RegisterMap
//
//  Created by Francesc Navarro on 24/03/2021.
//  Copyright © 2021 Cesc. All rights reserved.
//

import Foundation
import Security

enum Key: String {
    case password
    case username
}

// see https://stackoverflow.com/a/37539998/1694526
// Arguments for the keychain queries
let kSecClassValue = NSString(format: kSecClass)
let kSecAttrAccountValue = NSString(format: kSecAttrAccount)
let kSecValueDataValue = NSString(format: kSecValueData)
let kSecClassGenericPasswordValue = NSString(format: kSecClassGenericPassword)
let kSecAttrServiceValue = NSString(format: kSecAttrService)
let kSecMatchLimitValue = NSString(format: kSecMatchLimit)
let kSecReturnDataValue = NSString(format: kSecReturnData)
let kSecMatchLimitOneValue = NSString(format: kSecMatchLimitOne)

class KeychainService: NSObject {
    
    class func updateString(key: Key, account:String = "my_account", data: String) {
        if let dataFromString: Data = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key.rawValue, account], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue])
            
            let status = SecItemUpdate(keychainQuery as CFDictionary, [kSecValueDataValue:dataFromString] as CFDictionary)
            
            if (status != errSecSuccess) {
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("Read failed: \(err)")
                }
            }
        }
    }
    
    // En el següent cas li hem donat un valor per defecte a account, tot i que podriem crear la constant account a dintre i eliminar el paràmetre i relacionar-ho amb el paràmetre key (que és l'únic que hi ha ara).
    
    class func removeString(key: Key, account:String = "my_account") {
        
        // Instantiate a new default keychain query
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key.rawValue, account, kCFBooleanTrue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue])
        
        // Delete any existing items
        let status = SecItemDelete(keychainQuery as CFDictionary)
        if (status != errSecSuccess) {
            if let err = SecCopyErrorMessageString(status, nil) {
                print("Remove failed: \(err)")
            }
        }
    }
    
    class func saveString(key: Key, account:String = "my_account", data: String) {
        if let dataFromString = data.data(using: String.Encoding.utf8, allowLossyConversion: false) {
            
            // Instantiate a new default keychain query
            let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key.rawValue, account, dataFromString], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecValueDataValue])
            
            // Add the new keychain item
            let status = SecItemAdd(keychainQuery as CFDictionary, nil)
            
            if (status != errSecSuccess) {    // Always check the status
                if let err = SecCopyErrorMessageString(status, nil) {
                    print("Write failed: \(err)")
                }
            }
        }
    }
    
    class func loadString(key: Key, account:String = "my_account") -> String? {
        // Instantiate a new default keychain query
        // Tell the query to return a result
        // Limit our results to one item
        let keychainQuery: NSMutableDictionary = NSMutableDictionary(objects: [kSecClassGenericPasswordValue, key.rawValue, account, kCFBooleanTrue, kSecMatchLimitOneValue], forKeys: [kSecClassValue, kSecAttrServiceValue, kSecAttrAccountValue, kSecReturnDataValue, kSecMatchLimitValue])
        
        var dataTypeRef :AnyObject?
        
        // Search for the keychain items
        let status: OSStatus = SecItemCopyMatching(keychainQuery, &dataTypeRef)
        var contentsOfKeychain: String?
        
        if status == errSecSuccess {
            if let retrievedData = dataTypeRef as? Data {
                contentsOfKeychain = String(data: retrievedData, encoding: String.Encoding.utf8)
            }
        } else {
            print("Nothing was retrieved from the keychain. Status code \(status)")
        }
        
        return contentsOfKeychain
    }
    
}
