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
                    Spacer()
                }.frame(height: 110)
            }
            
            Section(header: Text("Next 24 hours")) {
                ScrollView(.horizontal) {
                    HStack(spacing: 22) {
                        ForEach(Array(stride(from: 0, to: (weather.hourly ?? []).count, by: 3)).prefix(9), id: \.self) { ndx in
                            VStack(spacing: 15) {
                                Text(cityProvider.hourFormattedDate(utc: weather.hourly![ndx].dt, offset: weather.timezoneOffset)).font(.footnote)
                                Image(systemName: hourlyIconName(ndx))
                                    .resizable()
                                    .frame(width: 30, height: 25)
                                    .foregroundColor(Color.green)
                                Text(String(format: "%.1f", weather.hourly![ndx].temp)+"°")
                            }
                        }.frame(height: 120)
                    }.padding([.trailing, .leading])
                }
            }
            
            Section(header: Text("This week")) {
                ForEach((weather.daily?.dropFirst() ?? []), id: \.self) { daily in
                    dailyView(daily)
                }
            }
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
            VStack {
                Text("min").font(.caption).foregroundColor(.blue)
                Text(String(format: "%.1f", daily.temp.min)+"°")
            }
            VStack {
                Text("max").font(.caption).foregroundColor(.blue)
                Text(String(format: "%.1f", daily.temp.max)+"°")
            }
        }
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
