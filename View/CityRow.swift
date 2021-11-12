//
//  CityRow.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import MapKit
import CoreLocation

struct CityRow: View {
    
    @State var city: City

    @State var region = MKCoordinateRegion()
    
    var body: some View {
        NavigationLink(destination: WeatherDetails(city: city, region: region)) {
            HStack {
                Text(city.name)
                Spacer()
                Image(city.code).resizable().renderingMode(.original).frame(width: 40, height: 30)
                Spacer()
                Text(city.country).font(.caption)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10)
                            .stroke(lineWidth: 1)
                            .foregroundColor(Color.primary)
                            .background(Color(UIColor.systemGray6))
                            .shadow(radius: 3)
                            .padding(2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: city.lat, longitude: city.lon),
                                    span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    }
    
}
