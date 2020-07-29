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
    
    var weatherProvider = OWProvider(apiKey: "your key")
    let locationManager = CLLocationManager()
    
    @Published var cities: [City] = []
    @Published var lang = "English"

    var languageNames = ["en":"English"]
    var langArr = ["English"]
    
    let hourFormatter = DateFormatter()

    
    init() {
        hourFormatter.dateFormat = "hh:mm a"
        loadCities()
        loadLanguages()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func loadCities() {
        if let url =  Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                cities = try JSONDecoder().decode([City].self, from: data)
            } catch {
                print("====> CityProvider loadCities reading error:\(error)")
            }
        }
    }
    
    func loadLanguages() {
        let currentLocale = NSLocale.current as NSLocale
        for languageCode in NSLocale.availableLocaleIdentifiers {
            if let name = currentLocale.displayName(forKey: NSLocale.Key.languageCode, value: languageCode),
               !languageNames.values.contains(name) {
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
  //            locationManager.stopUpdatingLocation()
                return nearestTo(lat: coord.latitude, lon: coord.longitude)
            }
        }
        return nil
    }
    
    private func nearestTo(lat: Double, lon: Double) -> City? {
        let delta = 0.05
        return cities.first(where: {
            $0.lat >= lat-delta && $0.lat <= lat+delta &&
                $0.lon >= lon-delta && $0.lon <= lon+delta
        })
    }
    
    func langKey() -> String {
        if let keyval = languageNames.first(where: {$1 == lang}) {
            return keyval.key
        }
        return "en"
    }
    
    func hourFormattedDate(utc: Int, offset: Int) -> String {
        hourFormatter.locale = Locale(identifier: langKey())
        hourFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        return hourFormatter.string(from: utc.dateFromUTC())
    }
    
}
