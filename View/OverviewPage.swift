//
//  OverviewPage.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation
import SwiftUI
import OWOneCall


struct OverviewPage: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse
    
    @State var timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
    @State var timeNow = ""
    let dateFormatter = DateFormatter()
    
    
    var body: some View {
        List {
            Section(header: Text("Currently " + timeNow)
                        .font(.system(.footnote, design: .monospaced))
                        .foregroundColor(.accentColor).bold()
                        .onReceive(timer) { _ in
                            self.doUpdateTimeNow()
                        }) {
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

            Section(header: Text("Next 24 hours").foregroundColor(.accentColor).italic().bold()) {
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
            
            Section(header: Text("This week").foregroundColor(.accentColor).italic().bold()) {
                ForEach((weather.daily?.dropFirst() ?? []), id: \.self) { daily in
                    dailyView(daily)
                }
            }.textCase(nil)
        }
        .listStyle(.plain)
        .onAppear(perform: loadData)
        .padding(20)
        .navigationBarTitle(Text(city.name + ", " + city.country), displayMode: .automatic)
    }
    
    func loadData() {
        timer = Timer.publish(every: 1, tolerance: 0.5, on: .main, in: .common).autoconnect()
        dateFormatter.locale = Locale(identifier: cityProvider.langKey())
        dateFormatter.dateFormat = "LLLL dd, hh:mm:ss a"
    }
    
    func doUpdateTimeNow() {
        dateFormatter.timeZone = TimeZone(secondsFromGMT: weather.timezoneOffset)
        self.timeNow = dateFormatter.string(from: Date())
    }
    
    func dailyView(_ daily: Daily) -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 2){
                Text(Date(utc: daily.dt).dayName(lang: cityProvider.lang)).font(.caption)
                Image(systemName: dailyIconName(daily))
                    .resizable()
                    .frame(width: 30, height: 25)
                    .foregroundColor(Color.green)
            }.frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(String(format: "%.0f", (daily.pop ?? 0)*100)+"%")
                .foregroundColor(.blue)
                .padding(.horizontal, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            HStack {
                Text(String(format: "%.0f", daily.temp.min.rounded())+"°").font(.caption)
                Image(systemName: "arrow.right")
                    .resizable()
                    .frame(width: 10, height: 10)
                    .foregroundColor(Color.blue)
                Text(String(format: "%.0f", daily.temp.max.rounded())+"°").font(.caption)
            }
        }
    }
    
    func windHourly(_ ndx: Int) -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 14, height: 24)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(windDirHourly(ndx)))  // self.cityProvider.heading+windDirHourly(ndx)
    }
    
    // todo check for correctness
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
            .rotationEffect(.degrees(windDirCurrent()))  // self.cityProvider.heading+windDirCurrent()
    }
    
    // todo check for correctness
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
