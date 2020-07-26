//
//  City.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation

struct City: Identifiable, Equatable {
    
    let id = UUID().uuidString
    var name: String
    var country: String
    var lon: Double
    var lat: Double
    
    init() {
        self.name = ""
        self.country = ""
        self.lon = 0.0
        self.lat = 0.0
    }
    
    init(name: String, country: String, lat: Double, lon: Double) {
        self.name = name
        self.country = country
        self.lon = lon
        self.lat = lat
    }
    
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.id == rhs.id
    }
    
}
