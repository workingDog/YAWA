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
    
    let weatherProvider = OWProvider(apiKey: "your key")
    let locationManager = CLLocationManager()
    
    @Published var cities: [City] = []
    @Published var lang = "English"

    var languageNames = ["en":"English"]
    var langArr = ["English"]
    
    init() {
        loadCities()
        loadLanguages()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadCities() {
        if let url =  Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let theCities = try JSONDecoder().decode([City].self, from: data)
                cities = theCities
            } catch {
                print("====> loadCities loadCitiesJson reading error:\(error)")
            }
        }
    }
    
    func loadLanguages() {
        let currentLocale = NSLocale.current as NSLocale
        for languageCode in NSLocale.availableLocaleIdentifiers {
            if let name = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode), !languageNames.values.contains(name) {
                languageNames[languageCode] = name
            }
        }
        langArr = Array(languageNames.values.sorted {$0 < $1})
    }
    
    func getCurrentCity() -> City? {
        if locationManager.authorizationStatus() == .authorizedWhenInUse ||
            locationManager.authorizationStatus() == .authorizedAlways {
            let loc = locationManager.location
            if let coord = loc?.coordinate {
                locationManager.stopUpdatingLocation()
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
    
    func langKey() -> String {
        if let keyval = languageNames.first(where: {$1 == lang}) {
            return keyval.key
        }
        return "en"
    }
    
    func hourFormattedDate(utc: Int, offset: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: langKey())
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
