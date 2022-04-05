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
    
    @State var city: City
    
    @State var showAlert = false
    @State var timeNow = ""
    
    let timer = Timer.publish(every: 1, tolerance: 1.0, on: .main, in: .common).autoconnect()
    let dateFormatter = DateFormatter()
    
    
    func updateTime() {
        dateFormatter.locale = Locale(identifier: cityProvider.langKey())
        dateFormatter.dateFormat = "LLLL dd, hh:mm:ss a"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: cityProvider.weather.timezoneOffset)
        timeNow = dateFormatter.string(from: Date())
    }
    
    var body: some View {
        List {
            Section(header: Text(timeNow)
                .font(.system(.footnote, design: .monospaced))
                .foregroundColor(.accentColor).bold()
                .onReceive(timer) { _ in
                    updateTime()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: cityProvider.weather.current?.weatherIconName() ?? "smiley")
                            .resizable()
                            .frame(width: 70, height: 65)
                            .foregroundColor(Color.green)
                        Text(cityProvider.weather.current?.weatherInfo() ?? "").padding(.horizontal, 20)
                        WindCurrentImage()
                        Spacer()
                        if let alerts = cityProvider.weather.alerts, alerts.count > 0 {
                            Button("Alert", action: {showAlert = true})
                                .padding(8)
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                        }
                    }.frame(height: 110)
                }.textCase(nil)
            
            Section(header: Text("Next 24 hours").foregroundColor(.accentColor).italic().bold()) {
                ScrollView(.horizontal) {
                    HStack(spacing: 22) {
                        ForEach(Array(stride(from: 0, to: (cityProvider.weather.hourly ?? []).count, by: 3)).prefix(9), id: \.self) { ndx in
                            VStack(spacing: 15) {
                                Text(cityProvider.hourFormattedDate(utc: cityProvider.weather.hourly![ndx].dt, offset: cityProvider.weather.timezoneOffset)).font(.footnote)
                                HStack {
                                    Image(systemName: cityProvider.hourlyIconName(ndx))
                                        .resizable()
                                        .frame(width: 35, height: 30)
                                        .foregroundColor(Color.green)
                                    windHourlyImage(ndx)
                                }
                                Text(String(format: "%.0f", cityProvider.weather.hourly![ndx].temp.rounded())+"°")
                            }
                        }.frame(height: 130)
                    }.padding([.trailing, .leading])
                }
            }.textCase(nil)
            
            Section(header: Text("This week").foregroundColor(.accentColor).italic().bold()) {
                ForEach((cityProvider.weather.daily?.dropFirst() ?? []), id: \.self) { daily in
                    dailyView(daily).listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            }.textCase(nil)
            
        }
        .listStyle(.grouped)
        .onAppear {
            updateTime()
        }
        .padding(10)
        .navigationBarTitle(Text(city.name + ", " + city.country), displayMode: .automatic)
        .fullScreenCover(isPresented: $showAlert) {
            WeatherAlertView().environmentObject(cityProvider)
        }
    }
    
    func dailyView(_ daily: Daily) -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 2){
                Text(Date(utc: daily.dt).dayName(lang: cityProvider.lang)).font(.caption)
                Image(systemName: cityProvider.dailyIconName(daily))
                    .resizable()
                    .frame(width: 30, height: 25)
                    .foregroundColor(Color.green)
                    .padding(.horizontal, 20)
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
            }.padding(.trailing, 10)
        }
    }
    
    func windHourlyImage(_ ndx: Int) -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 14, height: 24)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(cityProvider.windDirHourly(ndx)))  // cityProvider.heading+windDirHourly(ndx)
    }
    
    func WindCurrentImage() -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 24, height: 34)
            .foregroundColor(Color.orange)
            .rotationEffect(.degrees(cityProvider.windDirCurrent()))  // cityProvider.heading+windDirCurrent()
    }
    
}

