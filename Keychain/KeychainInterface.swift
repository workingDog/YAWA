//
//  KeychainClass.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2023/08/23.
//

import Foundation

// based on: https://www.advancedswift.com/secure-private-data-keychain-swift/

class KeychainInterface {
    
    static var service = "test.com.keychain"
    static var account = "test.com.key"
    
    enum KeychainError: Error {
        // Attempted read for an item that does not exist.
        case itemNotFound
        
        // Attempted save to override an existing item.
        // Use update instead of save to update existing items
        case duplicateItem
        
        // A read of an item in any format other than Data
        case invalidItemFormat
        
        // Any operation result status than errSecSuccess
        case unexpectedStatus(OSStatus)
    }
    
    //------ convenience for api ---------------------------------
    
    static func getKey() -> String? {
        getPassword()
    }
    
    static func setKey(key: String) {
        do {
            try savePassword(key)
        } catch {
            print("setKey(): \(error)")
        }
    }
    
    static func updateKey(key: String) {
        do {
            try updatePassword(with: key)
        } catch {
            print("updateKey(): \(error)")
        }
    }
    
    //-----------------------------------------------------------
    
    static func savePassword(_ password: String) throws {
        try save(password: password.data(using: .utf8)!, service: service, account: account)
    }
    
    static func getPassword() -> String? {
        do {
            let data = try readPassword(service: service, account: account)
            let str = String(data: data, encoding: .utf8)
            return str
        } catch {
            return nil
        }
    }
    
    static func updatePassword(with password: String) throws {
        let data = password.data(using: .utf8)!
        try update(password: data, service: service, account: account)
    }
    
    static func save(password: Data, service: String, account: String) throws {
        
        let query: [CFString: Any] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to save in Keychain
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            
            // kSecValueData is the item value to save
            kSecValueData: password
        ]
        
        // SecItemAdd attempts to add the item identified by
        // the query to keychain
        let status = SecItemAdd(query as CFDictionary, nil)
        
        // errSecDuplicateItem is a special case where the
        // item identified by the query already exists. Throw
        // duplicateItem so the client can determine whether
        // or not to handle this as an error
        if status == errSecDuplicateItem {
            throw KeychainError.duplicateItem
        }
        
        // Any status other than errSecSuccess indicates the
        // save operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func update(password: Data, service: String, account: String) throws {
        let query: [CFString: Any] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to update in Keychain
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ]
        
        // attributes is passed to SecItemUpdate with
        // kSecValueData as the updated item value
        let attributes: [CFString: Any] = [
            kSecValueData: password
        ]
        
        // SecItemUpdate attempts to update the item identified
        // by query, overriding the previous value
        let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
        
        // errSecItemNotFound is a special status indicating the
        // item to update does not exist. Throw itemNotFound so
        // the client can determine whether or not to handle
        // this as an error
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        // Any status other than errSecSuccess indicates the
        // update operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
    static func readPassword(service: String, account: String) throws -> Data {
        let query: [CFString: Any] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to read in Keychain
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            
            // kSecMatchLimitOne indicates keychain should read
            // only the most recent item matching this query
            kSecMatchLimit: kSecMatchLimitOne,
            
            // kSecReturnData is set to kCFBooleanTrue in order
            // to retrieve the data for the item
            kSecReturnData: kCFBooleanTrue ?? "true"
        ]
        
        // SecItemCopyMatching will attempt to copy the item
        // identified by query to the reference itemCopy
        var itemCopy: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &itemCopy)
        
        // errSecItemNotFound is a special status indicating the
        // read item does not exist. Throw itemNotFound so the
        // client can determine whether or not to handle
        // this case
        guard status != errSecItemNotFound else {
            throw KeychainError.itemNotFound
        }
        
        // Any status other than errSecSuccess indicates the
        // read operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
        
        // This implementation of KeychainInterface requires all
        // items to be saved and read as Data. Otherwise,
        // invalidItemFormat is thrown
        guard let password = itemCopy as? Data else {
            throw KeychainError.invalidItemFormat
        }
        
        return password
    }
    
    static func deletePassword(service: String, account: String) throws {
        let query: [CFString: Any] = [
            // kSecAttrService,  kSecAttrAccount, and kSecClass
            // uniquely identify the item to delete in Keychain
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ]
        
        // SecItemDelete attempts to perform a delete operation
        // for the item identified by query. The status indicates
        // if the operation succeeded or failed.
        let status = SecItemDelete(query as CFDictionary)
        
        // Any status other than errSecSuccess indicates the
        // delete operation failed.
        guard status == errSecSuccess else {
            throw KeychainError.unexpectedStatus(status)
        }
    }
    
}
