//
//  StoreService.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation


class StoreService {
    
    static func getOWKey() -> String? {
        KeychainWrapper.standard.string(forKey: "yawa.openweather.key")
    }
    
    static func setOWKey(key: String) {
        KeychainWrapper.standard.set(key, forKey: "yawa.openweather.key")
    }
    
    static func getLang() -> String? {
        return UserDefaults.standard.string(forKey: "yawa.defaultlang.key")
    }
    
    static func setLang(str: String) {
        UserDefaults.standard.set(str, forKey: "yawa.defaultlang.key")
    }
    
}
