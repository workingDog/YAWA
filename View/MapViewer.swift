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
    
    @State private var mapType: Int = 1
    @State private var mapTypes = ["Standard", "Satellite", "Hybrid"]
    
    
    var body: some View {
        VStack (spacing: 1) {
            mapTools
            // do this until Map takes mayType as a dynamic parameter
            if mapType == 0 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    pin.title == self.city.name
                        ? MapPin(coordinate: pin.coordinate, tint: .blue)
                        : MapPin(coordinate: pin.coordinate, tint: .red)
                }.mapStyle(.standard)
            }
            if mapType == 1 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    pin.title == self.city.name
                        ? MapPin(coordinate: pin.coordinate, tint: .blue)
                        : MapPin(coordinate: pin.coordinate, tint: .red)
                }.mapStyle(.satellite)
            }
            if mapType == 2 {
                Map(coordinateRegion: $region, showsUserLocation: true,
                    annotationItems: cityAnno) { pin in
                    pin.title == self.city.name
                        ? MapPin(coordinate: pin.coordinate, tint: .blue)
                        : MapPin(coordinate: pin.coordinate, tint: .red)
                }.mapStyle(.hybrid)
            }

        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon),
                                     span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
        loadLocations()
    }
    
    func loadLocations() {
        // create a map location for all cities of this city.country
        for sity in cityProvider.cities {
            if sity.country == city.country {
                cityAnno.append(CityMapLocation(title: sity.name, subtitle: sity.country, lat: sity.lat, lon: sity.lon))
            }
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
            Picker(selection: $mapType, label: Text("")) {
                ForEach(0 ..< mapTypes.count) {
                    Text(mapTypes[$0])
                }
            }.pickerStyle(SegmentedPickerStyle())
            .labelsHidden()
            .padding(5)
            .fixedSize()
        }.padding(5)
    }
 
}
