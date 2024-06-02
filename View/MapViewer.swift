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
    
    @Environment(CityProvider.self) var cityProvider
    
    let city: City
    @State private var selectedCity = City()
    
    @State private var mapType: Int = 0
    @State private var showInfo = false
    
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
//                        ForEach(cityProvider.cities.filter{$0.country == city.country}) { pin in
//                            Annotation("", coordinate: pin.asCoords()) {
//                                annoView(pin)
//                            }
//                        }
                        Annotation("", coordinate: city.asCoords()) {
                            annoView(city)
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
            cameraPosition = .camera(
                MapCamera(centerCoordinate: selectedCity.asCoords(), distance: 50000, heading: 0, pitch: 77)
            )
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
    
    func annoView(_ theCity: City) -> some View {
        Button(action: {
            selectedCity = theCity
            showInfo = true
        }) {
            VStack {
                Text(String(format: "%.0f", (cityProvider.weather.current?.temp ?? 0.0).rounded())+"°").bold()
                Image(systemName: currentIconName())
            }.foregroundColor(.red).scaleEffect(1.2)
        }.padding(5).frame(width: 75, height: 75)
        .contentShape(Rectangle())
        .background(RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.secondary)
                        .background(Color(UIColor.systemGray6))
                        .padding(1))
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .zIndex(2)
    }
    
}
