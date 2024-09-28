//
//  CityProvider.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import Observation
import OWOneCall
import CoreLocation


@Observable class CityProvider: NSObject, CLLocationManagerDelegate {
    
    var weather = OWResponse()
    var cities: [City] = []
    var lang = "English"
    var heading: Double = .zero
    
    @ObservationIgnored let defaultCity = City(name: "Tokyo", country: "Japan", code: "jp", lat: 35.685, lon: 139.7514)
    @ObservationIgnored var weatherProvider = OWProvider(apiKey: "your key")
    @ObservationIgnored let locationManager = CLLocationManager()
    @ObservationIgnored var languageNames = ["en":"English"]
    @ObservationIgnored var langArr = ["English"]
    @ObservationIgnored let hourFormatter = DateFormatter()
    
    // current selected city
    var currentCity = City(name: "Tokyo", country: "Japan", code: "jp", lat: 35.685, lon: 139.7514)
    
    
    override init() {
        super.init()
        hourFormatter.dateFormat = "hh:mm a"
        loadCities()
        languageNames = YawaUtils.langDictionary
        langArr = Array(languageNames.values.sorted {$0 < $1})
        
        locationManager.delegate = self
        startLocationManager()
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.headingAvailable() {
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
        }
    }
    
    func loadCities() {
        if let url = Bundle.main.url(forResource: "cities", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                cities = try JSONDecoder().decode([City].self, from: data)
            } catch {
                print("====> CityProvider loadCities reading error:\(error)")
            }
        }
    }
    
    // city of current location 
    func getHomeCity() -> City {
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
        heading = -1 * newHeading.magneticHeading
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
            return Double(w.windDeg) + 180.0
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
        return daily.weatherIconName().isEmpty ? "smiley" : daily.weatherIconName()
    }
    
    func localTimeFor(_ t: Int?) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: langKey())
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezoneOffset)
        dateFormatter.dateFormat = "LLLL dd, hh:mm a"
        return dateFormatter.string(from: Date(utc: t ?? 0))
    }
    
    func getTimezoneOffset(for city: City, completion: @escaping (Int) -> Void) {
        // for current, daily and hourly forecast
        let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: lang)
        weatherProvider.getWeather(lat: city.lat, lon: city.lon, options: options) { response in
            if let response = response{
                completion(response.timezoneOffset)
            }
        }
    }

    func timeDifference(completion: @escaping (String) -> Void) {
        let homeCity = getHomeCity()
        if homeCity.name != currentCity.name && homeCity.country != currentCity.country {
            getTimezoneOffset(for: homeCity) { tz in
                let seconds = tz - self.weather.timezoneOffset
                let hours = seconds / 3600
                let minutes = (seconds % 3600) / 60
                
                var result = String(abs(hours))
                result = result + (minutes > 0 ? ":" + String(minutes) : ":0")
                result = result + (hours < 0 ? " ahead" : " behind")
                
                completion(result)
            }
        } else {
            completion("")
        }
    }

}
