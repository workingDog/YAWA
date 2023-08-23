//
//  WeatherCardInfo.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/31.
//

import Foundation
import SwiftUI
import OWOneCall



struct WeatherCardInfo: View {
    
    @Environment(CityProvider.self) var cityProvider
    
    @State var city: City
    @Binding var showInfo: Bool
    
    @State var weather = OWResponse()
    
    var body: some View {
        Button(action: {showInfo = false}) {
            VStack (spacing: 10) {
                Text(city.name).font(.title).foregroundColor(Color.black)
                HStack {
                    Spacer()
                    Image(systemName: weather.current?.weatherIconName() ?? "smiley")
                        .resizable()
                        .frame(width: 70, height: 65)
                        .foregroundColor(Color.green)
                    Spacer()
                    WindCurrent()
                    Spacer()
                }.padding(20)
                Text(weather.current?.weatherInfo() ?? "")
                Text("Clouds \(weather.current?.clouds ?? 0) %")
                VStack {
                    Text(cityProvider.localTimeFor(weather.current?.sunrise))
                    Text("Sunrise").font(.caption)
                }.padding(.horizontal, 20)
                VStack {
                    Text(cityProvider.localTimeFor(weather.current?.sunset))
                    Text("Sunset").font(.caption)
                }.padding(.horizontal, 20)
            }.frame(width: 400, height: 400)
            .background(RoundedRectangle(cornerRadius: 25)
                            .stroke(lineWidth: 2)
                            .background(Color(UIColor.systemGray6))
                            .padding(1))
            .clipShape(RoundedRectangle(cornerRadius: 25))
        }
        .onAppear {
            // for current, daily and hourly forecast
            let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: cityProvider.lang)
            cityProvider.weatherProvider.getWeather(lat: city.lat, lon: city.lon, weather: $weather, options: options)
        }
    }

    func WindCurrent() -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 24, height: 34)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(windDirCurrent()))  // self.cityProvider.heading+windDirCurrent()
    }
    
    // todo check for correctness
    private func windDirCurrent() -> Double {
        if let w = weather.current {
            return Double(w.windDeg)+180.0
        }
        return 0.0
    }

}
