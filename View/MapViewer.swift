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
    
    @State var city: City

    @State var cityAnno = [CityMapLocation]()
    @State var selectedCity = City()
    
    @State private var mapType: Int = 0
    @State var showInfo = false
    
    @State private var cameraPosition: MapCameraPosition = .camera(
        MapCamera(centerCoordinate: CLLocationCoordinate2D(), distance: 50000, heading: 0, pitch: 0)
    )
    
    var selectedMapStyle: MapStyle {
        return switch(mapType) {
            case 0: .standard(elevation: .automatic)
            case 1: .imagery
            case 2: .hybrid
            default: .standard(elevation: .automatic)
        }
    }
 
    var body: some View {
        ZStack {
            VStack (spacing: 1) {
                mapTools
                MapReader{ reader in
                    Map(position: $cameraPosition, interactionModes: .all) {
                        ForEach(cityAnno) { pin in
                            Annotation("", coordinate: pin.coordinate) {
                                annoView(cityName: pin.title!)
                            }
                        }
                    }
                    .mapControls {
                        MapCompass()
                        MapScaleView()
                        MapPitchToggle()
                    }
                    .mapStyle(selectedMapStyle)
                }
            }
            if showInfo {
                WeatherCardInfo(city: selectedCity, showInfo: $showInfo).padding(.top, 100)
            }
        }.onAppear {
            selectedCity = city
            loadData()
            cameraPosition = .camera(
                MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: selectedCity.lat, longitude: selectedCity.lon),
                          distance: 30000,
                          heading: 0,
                          pitch: 77)
            )
        }
    }
    
    func loadData() {
        // create a map location for all cities of this city.country
        for theCity in cityProvider.cities {
            if theCity.country == city.country {
                cityAnno.append(CityMapLocation(city: theCity))
            }
        }
    }
    
    private func currentIconName() -> String {
        if let current = cityProvider.weather.current {
            return current.weatherIconName()
        } else {
            return "smiley"
        }
    }

    var mapTools: some View {
        HStack {
            Spacer()
            Picker("", selection: $mapType) {
                Text("Standard").tag(0)
                Text("Satellite").tag(1)
                Text("Hybrid").tag(2)
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
                     ? String(format: "%.0f", (cityProvider.weather.current?.temp ?? 0.0).rounded())+"°"
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
