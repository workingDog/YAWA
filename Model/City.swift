//
//  City.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import CoreLocation

struct City: Codable, Identifiable, Hashable {
    let id = UUID()
    
    var name: String = ""
    var country: String = ""
    var code: String = ""
    var lat: Double = 0.0
    var lon: Double = 0.0

    enum CodingKeys: String, CodingKey, CaseIterable {
        case name, country, code, lat, lon
    }
    
    func asCoords() -> CLLocationCoordinate2D {
         CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
}
