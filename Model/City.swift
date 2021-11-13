//
//  City.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation

struct City: Codable, Identifiable, Equatable {
    var id = UUID().uuidString
    
    var name: String = ""
    var country: String = ""
    var code: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
}
