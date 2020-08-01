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
    
    @State private var mapType: Int = 0
    @State private var mapTypes = ["Standard", "Satellite", "Hybrid"]
    @State var showInfo = false
    
    
    var body: some View {
        ZStack {
            VStack (spacing: 1) {
                mapTools
                mapview
            }
            if showInfo {
                WeatherCardInfo(weather: $weather, showInfo: $showInfo).padding(.top, 100)
            }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon),
                                    span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        loadLocations()
    }
    
    var mapview: some View {
        Group {
            // do this until Map takes mayType as a dynamic parameter
            if mapType == 0 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
                        annoView(cityName: pin.title!)
                    }
                }.mapStyle(.standard)
            }
            
            if mapType == 1 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
                        annoView(cityName: pin.title!)
                    }
                }.mapStyle(.satellite)
            }
            
            if mapType == 2 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    MapAnnotation(coordinate: pin.coordinate) {
                        annoView(cityName: pin.title!)
                    }
                }.mapStyle(.hybrid)
            }
        }
    }
    
    func loadLocations() {
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
    
    func getMapType() -> MKMapType {
        switch mapType {
        case 0: return .standard
        case 1: return .satellite
        case 2: return .hybrid
        default:
            return .standard
        }
    }
    
    var mapTools: some View {
        HStack {
            Spacer()
            Picker(selection: Binding<Int> (
                get: { mapType },
                set: {
                    showInfo = false
                    mapType = $0
                }
            ), label: Text("")) {
                ForEach(0 ..< mapTypes.count) {
                    Text(mapTypes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(5)
            .fixedSize()
        }.padding(5)
    }
    
    func annoView(cityName: String) -> some View {
        Button(action: {showInfo = true}) {
            VStack {
                Text(cityName == city.name
                        ? String(format: "%.0f", (weather.current?.temp ?? 0.0).rounded())+"°"
                        : ""
                ).bold()
                Image(systemName: cityName == city.name ? currentIconName() : "mappin.and.ellipse")
            }.foregroundColor(.red).scaleEffect(1.2)
        }.padding(5).frame(width: 75, height: 75)
        .contentShape(Rectangle())
        .background(cityName == city.name
                        ? RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.secondary)
                        .background(Color(UIColor.systemGray6))
                        .padding(1)
                        
                        : RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 1)
                        .foregroundColor(Color.clear)
                        .background(Color.clear)
                        .padding(1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .zIndex(2)
    }

}
