//
//  MapViewer.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/30.
//

import Foundation
import SwiftUI
import OWOneCall
import MapKit
import CoreLocation


struct MapViewer: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse

    // Tokyo
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.685, longitude: 139.7514),
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    
    @State var cityAnno = [CityMapLocation]()
    
    
    var body: some View {
        VStack (spacing: 1) {
            Map(coordinateRegion: $region, showsUserLocation: true,
                annotationItems: cityAnno) { pin in
                MapPin(coordinate: pin.coordinate)
            }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        region = MKCoordinateRegion( center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon),
            span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        // for current, daily and hourly forecast
        let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: cityProvider.lang)
        cityProvider.weatherProvider.getWeather(lat: city.lat, lon: city.lon, weather: $weather, options: options)
        loadLocations()
    }
    
    func loadLocations() {
        for sity in cityProvider.cities {
            if sity.country == city.country {
                cityAnno.append(CityMapLocation(title: sity.name, subtitle: sity.country, lat: sity.lat, lon: sity.lon))
            }
        }
    }
    
}
