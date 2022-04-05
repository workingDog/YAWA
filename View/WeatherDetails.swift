//
//  WeatherDetails.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import OWOneCall
import MapKit
import CoreLocation


struct WeatherDetails: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var city: City
    @State var region: MKCoordinateRegion
    
    var body: some View {
        TabView {
            OverviewPage(city: city)
            HourlyPage()
            MapViewer(city: city, region: region)
        }
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
        .tabViewStyle(.page)
        .onAppear{
            cityProvider.loadWeatherData(for: city)
        }
    }
    
}
