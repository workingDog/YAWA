//
//  CityProvider.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import Combine
import OWOneCall
import CoreLocation


class CityProvider: ObservableObject {
    
    let fileName = "worldcities_clean"
    let lang = "en"         // "ja"
    let frmt = "yyyy-MM-dd" // "yyyy年MM月dd日"
   
    let weatherProvider = OWProvider(apiKey: "your-key")
    
    @Published var cities: [City] = []
    
    let locationManager = CLLocationManager()
    
    init() {
        self.cities = loadCities()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadCities() -> [City] {
        var cities = [City]()
        if let url = Bundle.main.url(forResource: fileName, withExtension: "csv") {
            do {
                let data = try String(contentsOf: url)
                let lines = data.split(separator: "\n")
                for line in lines {
                    let cols = line.split(separator: ",")
                    cities.append(City(name: String(cols[0]), country: String(cols[3]),
                                       lat: Double(cols[1]) ?? 0.0,
                                       lon: Double(cols[2]) ?? 0.0))
                }
                return cities.sorted {$0.name.localizedStandardCompare($1.name) == .orderedAscending}
            } catch {
                print("====> loadCities reading error:\(error)")
            }
        }
        return []
    }
    
    func getCurrentCity() -> City? {
        if locationManager.authorizationStatus() == .authorizedWhenInUse ||
            locationManager.authorizationStatus() == .authorizedAlways {
            // locationManager.requestLocation()
            let loc = locationManager.location
            // locationManager.stopUpdatingLocation()
            if let coord = loc?.coordinate {
                return nearestTo(lat: coord.latitude, lon: coord.longitude)
            }
        }
        return nil
    }
 
    private func nearestTo(lat: Double, lon: Double) -> City? {
        let delta = 0.005
        return cities.first(where: {
            $0.lat >= lat-delta && $0.lat <= lat+delta &&
            $0.lon >= lat-delta && $0.lon <= lat+delta
        })
    }
   
    func hourFormattedDate(utc: Int, offset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        return dateFormatter.string(from: utc.dateFromUTC())
    }
    
    static func getLatLon(lat: String, lon: String) -> (Double, Double)? {
        if let theLat = Double(lat), let theLon = Double(lon),
           theLat > -90.0 && theLat < 90.0,
           theLon > -180.0 && theLon < 180.0 {
            return (theLat, theLon)
        }
        return nil
    }
   
}
