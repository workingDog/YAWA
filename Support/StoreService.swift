//
//  StoreService.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation


class StoreService {
    
    static var shared = StoreService()
    
    init() {
        KeychainInterface.service = Bundle.main.bundleIdentifier ?? "keychain.com.keychain"
        KeychainInterface.account = "yawa.openweather.account"
    }
    
    func getOWKey() -> String? {
        KeychainInterface.getKey()
    }
    
    func setOWKey(key: String) {
        // if there is no key, store `key` in keychain
        if KeychainInterface.getKey() == nil {
            KeychainInterface.setKey(key: key)
        } else {
            // if there is already a key in keychain, must use update to override the old one
            KeychainInterface.updateKey(key: key)
        }
    }
    
    func getLang() -> String? {
        return UserDefaults.standard.string(forKey: "yawa.defaultlang.key")
    }
    
    func setLang(str: String) {
        UserDefaults.standard.set(str, forKey: "yawa.defaultlang.key")
    }
    
}
