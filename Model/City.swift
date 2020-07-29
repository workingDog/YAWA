//
//  City.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation

struct City: Codable, Identifiable, Equatable {
    
    var id = UUID().uuidString
    
    var name: String
    var country: String
    var code: String
    var lat: Double
    var lon: Double
    
    init() {
        self.name = ""
        self.country = ""
        self.code = ""
        self.lat = 0.0
        self.lon = 0.0
    }
    
    init(name: String, country: String, code: String, lat: Double, lon: Double) {
        self.name = name
        self.country = country
        self.code = code
        self.lat = lat
        self.lon = lon
    }
    
    init(id: String, name: String, country: String, code: String, lat: Double, lon: Double) {
        self.id = id
        self.name = name
        self.country = country
        self.code = code
        self.lat = lat
        self.lon = lon
    }
    
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
}
