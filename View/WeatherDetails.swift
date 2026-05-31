//
//  WeatherDetails.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI


struct WeatherDetails: View {
    
    @Environment(CityProvider.self) var cityProvider
    
    let city: City
    
    var body: some View {
        TabView {
            OverviewPage(city: city)
            ChartsPage()
            MapViewer(city: city)
        }
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(.page)
        .task {
            cityProvider.currentCity = city
            await cityProvider.loadWeatherData(for: city)
        }
    }
    
}
