//
//  NewCityView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/26.
//

import Foundation
import SwiftUI

struct NewCityView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var cityProvider: CityProvider

    @State var cityName = ""
    @State var cityCountry = ""
    @State var cityLat = ""
    @State var cityLon = ""
  
    
    var body: some View {
        VStack (spacing: 30) {
            Text("New city").padding(.top, 30)
            TextField("city name", text: $cityName).padding(8).textFieldStyle(CustomTextFieldStyle())
            TextField("country", text: $cityCountry).padding(8).textFieldStyle(CustomTextFieldStyle())
            TextField("decimal latitude", text: $cityLat).padding(8).textFieldStyle(CustomTextFieldStyle())
            TextField("decimal longitude", text: $cityLon).padding(8).textFieldStyle(CustomTextFieldStyle())

            Button(action: {self.onSave()}) {
                Text("Save").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                .foregroundColor(.green))
                .padding(.top, 30)

            Spacer()
        }.foregroundColor(.blue)
        .frame(width: 333)
    }
    
    func onSave() {
        if let latlon = CityProvider.getLatLon(lat: cityLat, lon: cityLon), !cityName.isEmpty {
            let newCity = City(name: cityName, country: cityCountry, lat: latlon.0, lon: latlon.1)
            cityProvider.cities.append(newCity)
        }
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    public struct CustomTextFieldStyle : TextFieldStyle {
        public func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
                .font(.callout)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 15).strokeBorder(Color.blue, lineWidth: 2))
        }
    }
    
}
