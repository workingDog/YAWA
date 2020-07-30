//
//  WeatherDetails.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import OWOneCall


struct WeatherDetails: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var city: City
    @State var weather = OWResponse()
    

    var body: some View {
        TabView {
            OverviewPage(city: $city, weather: $weather)
            HourlyPage(city: $city, weather: $weather)
            MapViewer(city: $city, weather: $weather)
        }
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(PageTabViewStyle())
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        // for current, daily and hourly forecast
        let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: cityProvider.lang)
        cityProvider.weatherProvider.getWeather(lat: city.lat, lon: city.lon, weather: $weather, options: options)
    }

}
