//
//  CityMapLocation.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/30.
//

import Foundation
import SwiftUI
import MapKit


class CityMapLocation: NSObject, MKAnnotation, Identifiable {
    
    var id = UUID().uuidString
    
    var title: String?
    var subtitle: String?
    dynamic var coordinate: CLLocationCoordinate2D
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
    }
    
    convenience init(title: String?, subtitle: String?, lat: Double, lon: Double) {
        self.init(title: title, subtitle: subtitle, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
    }
    
    convenience init(city: City) {
        self.init(title: city.name, subtitle: city.country, coordinate: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon))
    }
    

}
