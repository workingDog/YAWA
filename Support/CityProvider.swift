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


class CityProvider: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    let defaultCity = City(name: "Tokyo", country: "Japan", code: "jp", lat: 35.685, lon: 139.7514)

    var weatherProvider = OWProvider(apiKey: "your key")
    let locationManager = CLLocationManager()

    @Published var weather = OWResponse()

    @Published var cities: [City] = []
    @Published var lang = "English"
    
    @Published var heading: Double = .zero
        
    var languageNames = ["en":"English"]
    var langArr = ["English"]
    
    let hourFormatter = DateFormatter()

    
    override init() {
        super.init()
        hourFormatter.dateFormat = "hh:mm a"
        loadCities()
        languageNames = YawaUtils.langDictionary
        langArr = Array(languageNames.values.sorted {$0 < $1})
        
        self.locationManager.delegate = self
        self.startLocationManager()
    }
    
    private func startLocationManager() {
        self.locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            self.locationManager.startUpdatingLocation()
            self.locationManager.startUpdatingHeading()
        }
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

    func getCurrentCity() -> City {
        if locationManager.authorizationStatus == .authorizedWhenInUse ||
            locationManager.authorizationStatus == .authorizedAlways {
            let loc = locationManager.location
            if let coord = loc?.coordinate {
                // locationManager.stopUpdatingLocation()
                if let nearCity = nearestTo(lat: coord.latitude, lon: coord.longitude) {
                    return nearCity
                }
            }
        }
        return defaultCity
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
    
    // CLLocationManagerDelegate, when a new heading is available
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        self.heading = -1 * newHeading.magneticHeading
    }
    
    func hourFormattedDate(utc: Int, offset: Int) -> String {
        hourFormatter.locale = Locale(identifier: langKey())
        hourFormatter.timeZone = TimeZone(secondsFromGMT: offset)
        return hourFormatter.string(from: utc.dateFromUTC())
    }
    
    func loadWeatherData(for city: City) {
        // for current, daily and hourly forecast
        let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: lang)
        weatherProvider.getWeather(lat: city.lat, lon: city.lon, options: options) { response in
            if let theWeather = response {
                self.weather = theWeather
            }
        }
    }
    
    // todo check for correctness
    func windDirHourly(_ ndx: Int) -> Double {
        if let w = weather.hourly?[ndx] {
            return Double(w.windDeg)+180.0
        }
        return 0.0
    }
    
    func WindCurrent() -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 24, height: 34)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(windDirCurrent()))  // cityProvider.heading+windDirCurrent()
    }
    
    // todo check for correctness
    func windDirCurrent() -> Double {
        if let w = weather.current {
            return Double(w.windDeg)+180.0
        }
        return 0.0
    }
    
    func hourlyIconName(_ ndx: Int) -> String {
        if let theWeather = weather.hourly?[ndx].weather {
            return theWeather.first != nil ? theWeather.first!.iconNameFromId : "smiley"
        } else {
            return "smiley"
        }
    }
    
    func dailyIconName(_ daily: Daily) -> String {
        return daily.weather.first != nil ? daily.weather.first!.iconNameFromId : "smiley"
    }
    
    
}
