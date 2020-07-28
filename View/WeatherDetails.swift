//
//  WeatherDetails.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI
import OWOneCall


struct WeatherDetails: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var city: City
    @State var weather = OWResponse()
    
    
    var body: some View {
        List {
            Section(header: Text("Currently")) {
                HStack {
                    Spacer()
                    Image(systemName: weather.current?.weatherIconName() ?? "smiley")
                        .resizable()
                        .frame(width: 70, height: 65)
                        .foregroundColor(Color.green)
                    Text(weather.current?.weatherInfo() ?? "").padding(.horizontal, 20)
                    WindCurrent()
                    Spacer()
                }.frame(height: 110)
            }.textCase(nil)
            
            Section(header: Text("Next 24 hours")) {
                ScrollView(.horizontal) {
                    HStack(spacing: 22) {
                        ForEach(Array(stride(from: 0, to: (weather.hourly ?? []).count, by: 3)).prefix(9), id: \.self) { ndx in
                            VStack(spacing: 15) {
                                Text(cityProvider.hourFormattedDate(utc: weather.hourly![ndx].dt, offset: weather.timezoneOffset)).font(.footnote)
                                HStack {
                                    Image(systemName: hourlyIconName(ndx))
                                        .resizable()
                                        .frame(width: 35, height: 30)
                                        .foregroundColor(Color.green)
                                    windHourly(ndx)
                                }
                                Text(String(format: "%.0f", weather.hourly![ndx].temp.rounded())+"°")
                            }
                        }.frame(height: 130)
                    }.padding([.trailing, .leading])
                }
            }.textCase(nil)
            
            Section(header: Text("This week")) {
                ForEach((weather.daily?.dropFirst() ?? []), id: \.self) { daily in
                    dailyView(daily)
                }
            }.textCase(nil)
        }
        .padding(20)
        .onAppear(perform: loadData)
        .navigationBarTitle(Text(city.name + ", " + city.country))
    }
    
    func loadData() {
        // for current, daily and hourly forecast
        let options = OWOptions(excludeMode: [.minutely], units: .metric, lang: cityProvider.lang)
        cityProvider.weatherProvider.getWeather(lat: city.lat, lon: city.lon, weather: $weather, options: options)
    }

    func dailyView(_ daily: Daily) -> some View {
        HStack {
            Text(Date(utc: daily.dt).dayName(lang: cityProvider.lang))
            Spacer()
            Image(systemName: dailyIconName(daily))
                .resizable()
                .frame(width: 30, height: 25)
                .foregroundColor(Color.green)
            Spacer()
            HStack {
                Text(String(format: "%.0f", daily.temp.min.rounded())+"°")
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 20, height: 15)
                    .foregroundColor(Color.blue)
                Text(String(format: "%.0f", daily.temp.max.rounded())+"°")
            }
        }
    }
    
    func windHourly(_ ndx: Int) -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 14, height: 24)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(windDirHourly(ndx)))
    }
    
    private func windDirHourly(_ ndx: Int) -> Double {
        if let w = weather.hourly?[ndx] {
            return Double(w.windDeg)+180.0
        }
        return 0.0
    }
    
    func WindCurrent() -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 24, height: 34)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(windDirCurrent()))
    }
    
    private func windDirCurrent() -> Double {
        if let w = weather.current {
            return Double(w.windDeg)+180.0
        }
        return 0.0
    }
    
    private func hourlyIconName(_ ndx: Int) -> String {
        if let theWeather = weather.hourly?[ndx].weather {
            return theWeather.first != nil ? theWeather.first!.iconNameFromId : "smiley"
        } else {
            return "smiley"
        }
    }
    
    private func dailyIconName(_ daily: Daily) -> String {
        return daily.weather.first != nil ? daily.weather.first!.iconNameFromId : "smiley"
    }
    
}
