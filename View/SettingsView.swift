//
//  SettingsView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall


struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var cityProvider: CityProvider

    @State var theKey = "your key"
    
    var body: some View {
        VStack (spacing: 30) {
            Text("Settings").padding(.top, 30)
            TextField("openweather key", text: $theKey)
            TextField("default language", text: self.$cityProvider.lang)

            Button(action: {self.onSave()}) {
                Text("Save").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                .foregroundColor(.green))
                .padding(.top, 30)
            Spacer()
        }.foregroundColor(.blue)
        .textFieldStyle(CustomTextFieldStyle())
        .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
        .padding(5)
    }
    
    func onSave() {
        self.cityProvider.weatherProvider = OWProvider(apiKey: theKey)
        StoreService.setOWKey(key: theKey)
        // todo validate lang
        StoreService.setLang(str: self.cityProvider.lang)
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
