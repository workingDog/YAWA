//
//  City.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import CoreLocation


struct City: Codable, Identifiable, Equatable, Hashable {
    let id = UUID().uuidString
    
    var name: String = ""
    var country: String = ""
    var code: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0
    
    public static func == (lhs: City, rhs: City) -> Bool {
        lhs.name == rhs.name &&
        lhs.country == rhs.country &&
        lhs.code == rhs.code &&
        lhs.lat == rhs.lat &&
        lhs.lon == rhs.lon
    }
    
    enum CodingKeys: String, CodingKey, CaseIterable {
        case name, country, code, lat, lon
    }
    
    func asCoords() -> CLLocationCoordinate2D {
         CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}
