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
                        VStack (spacing: 15) {
                            Text(alert.event).font(.title).foregroundColor(.red)
                            Text("From: \(cityProvider.localTimeFor(alert.start))")
                                .foregroundColor(.blue)
                            Text("To: \(cityProvider.localTimeFor(alert.end))")
                                .foregroundColor(.blue)
                            Text(alert.description)
                        }.padding(20)
                    }
                }
            } else {
                Text("No weather alerts").font(.title).foregroundColor(.green).padding(20)
            }
        }
    }
    
}
