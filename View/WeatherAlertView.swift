//
//  WeatherAlertView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2022/04/05.
//

import Foundation
import SwiftUI
import OWOneCall


struct WeatherAlertView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var cityProvider: CityProvider
    
    var body: some View {
        VStack (spacing: 20) {
            #if targetEnvironment(macCatalyst)
            Button(action: {dismiss()}) {
                HStack {
                    Text("Done").foregroundColor(.blue)
                    Spacer()
                }
            }.padding(20)
            #endif
            if let alerts = cityProvider.weather.alerts, alerts.count > 0 {
                ScrollView {
                    ForEach(alerts) { alert in
                        VStack {
                            Text(alert.event).font(.title).foregroundColor(.red).padding(20)
                            Text(alert.description)
                        }
                    }
                }
            } else {
                Text("No weather alerts").font(.title).foregroundColor(.green).padding(20)
            }
        }
    }
    
}
