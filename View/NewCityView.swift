//
//  NewCityView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/26.
//

import Foundation
import SwiftUI

struct NewCityView: View {
    @Environment(\.dismiss) var dismiss
    
    @Environment(CityProvider.self) var cityProvider

    @State var cityName = ""
    @State var cityCountry = ""
    @State var cityCountryCode = ""
    @State var cityLat = ""
    @State var cityLon = ""
  
    
    var body: some View {
        VStack (spacing: 20) {
            #if targetEnvironment(macCatalyst)
            Button(action: {dismiss()}) {
                    HStack {
                        Text("Done").foregroundColor(.blue)
                        Spacer()
                    }
                }.padding(.top, 20)
            #endif
            Text("New city").padding(.top, 35)
            TextField("city name", text: $cityName)
            TextField("country", text: $cityCountry)
            TextField("country code", text: $cityCountryCode)
            TextField("decimal latitude", text: $cityLat)
            TextField("decimal longitude", text: $cityLon)

            Button(action: { onSave() }) {
                Text("Save").padding(25).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                .foregroundColor(.green))
                .padding(.top, 25)

            Spacer()
        }.foregroundColor(.blue)
        .textFieldStyle(CustomTextFieldStyle())
        .frame(width: 333)
    }
    
    func onSave() {
        if let latlon = YawaUtils.getLatLon(lat: cityLat, lon: cityLon), !cityName.isEmpty {
            let newCity = City(name: cityName, country: cityCountry,
                               code: cityCountryCode,
                               lat: latlon.0, lon: latlon.1)
            cityProvider.cities.append(newCity)
        }
        // to go back to the previous view
        dismiss()
    }

}
