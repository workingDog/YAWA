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

// experimental

struct MapViewer: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse
    @State var region: MKCoordinateRegion
    
    @State var cityAnno = [CityMapLocation]()
    @State var selectedCity = City()
    
    @State private var mapType: MKMapType = .satellite
    @State var showInfo = false
    
 
    var body: some View {
        ZStack {
            VStack (spacing: 1) {
                mapTools
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
                        annoView(cityName: pin.title!)
                    }
                }.mapStyle(mapType)  // <-- does not work (see Extensions.swift)
            }
            if showInfo {
                WeatherCardInfo(city: selectedCity, showInfo: $showInfo).padding(.top, 100)
            }
        }.onAppear{ loadData() }
    }
    
    func loadData() {
        selectedCity = city
        // create a map location for all cities of this city.country
        for theCity in cityProvider.cities {
            if theCity.country == city.country {
                cityAnno.append(CityMapLocation(city: theCity))
            }
        }
    }
    
    private func currentIconName() -> String {
        if let current = weather.current {
            return current.weatherIconName()
        } else {
            return "smiley"
        }
    }

    var mapTools: some View {
        HStack {
            Spacer()
            Picker("", selection: $mapType) {
                Text("Standard").tag(MKMapType.standard)
                Text("Satellite").tag(MKMapType.satellite)
                Text("Hybrid").tag(MKMapType.hybrid)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(5)
            .fixedSize()
        }.padding(5)
    }
    
    func annoView(cityName: String) -> some View {
        Button(action: {
            // set the selectedCity
            if let thisCity = cityProvider.cities.first(where: {$0.name == cityName}) {
                selectedCity = thisCity
            }
            showInfo = true
        }) {
            VStack {
                Text(cityName == city.name
                        ? String(format: "%.0f", (weather.current?.temp ?? 0.0).rounded())+"°"
                        : ""
                ).bold()
                Image(systemName: cityName == city.name ? currentIconName() : "mappin.and.ellipse")
            }.foregroundColor(.red).scaleEffect(1.2)
        }.padding(5).frame(width: 75, height: 75)
        .contentShape(Rectangle())
        .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 1)
                        .foregroundColor(cityName == city.name ? Color.secondary : Color.clear)
                        .background(cityName == city.name ? Color(UIColor.systemGray6) : Color.clear)
                        .padding(1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .zIndex(2)
    }
    
}
