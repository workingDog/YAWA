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
    
    let backColor = LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom)
    
    let symbolColor = Color(uiColor: UIColor(red: 1, green: 1, blue: 0, alpha: 1))
    
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
                        let icon = cityProvider.weather.current?.weatherIconName() ?? "questionmark"
                        Image(systemName: icon.isEmpty ? "smiley" : icon)
                            .resizable()
                            .frame(width: 70, height: 65)
                            .foregroundColor(symbolColor)
                        Text(cityProvider.weather.current?.weatherInfo() ?? "").padding(.horizontal, 20)
                        WindCurrentImage()
                        Spacer()
                        if let alerts = cityProvider.weather.alerts, alerts.count > 0 {
                            Button("Alerts", action: {showAlert = true})
                                .padding(8)
                                .buttonStyle(.bordered)
                                .foregroundColor(.red)
                        }
                    }
                    .padding(5)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(backColor)
                    .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
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
                                        .foregroundColor(symbolColor)
                                    windHourlyImage(ndx)
                                }
                                Text(String(format: "%.0f", cityProvider.weather.hourly![ndx].temp.rounded())+"°")
                            }
                        }.frame(height: 130)
                    }.padding([.trailing, .leading])
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(backColor)
                .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
            }.textCase(nil)
            
            Section(header: Text("This week").foregroundColor(.accentColor).italic().bold()) {
                ForEach((cityProvider.weather.daily?.dropFirst() ?? [])) { daily in
                    dailyView(daily).padding(15)
                }
                .background(backColor)
                .listRowInsets(EdgeInsets(top: 0,leading: 0,bottom: 0,trailing: 0))
            }.textCase(nil)
        }
        //      .scrollContentBackground(.hidden)
        //      .background(backColor)
        //      .listStyle(.grouped)
        .navigationBarTitle(Text(city.name + ", " + city.country), displayMode: .automatic)
        .fullScreenCover(isPresented: $showAlert) {
            WeatherAlertView().environmentObject(cityProvider)
        }
    }
    
    func dailyView(_ daily: Daily) -> some View {
        HStack {
            VStack (alignment: .leading, spacing: 2){
                Text(Date(utc: daily.dt).dayName(lang: cityProvider.lang))
                    .font(.caption).padding(.leading, 10)
                Image(systemName: cityProvider.dailyIconName(daily))
                    .resizable()
                    .frame(width: 30, height: 25)
                    .foregroundColor(symbolColor)
                    .padding(.horizontal, 20)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Text(String(format: "%.0f", (daily.pop ?? 0)*100)+"%")
                .foregroundColor(.black)
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
            .foregroundColor(symbolColor)
            .rotationEffect(.degrees(cityProvider.windDirHourly(ndx)))  // cityProvider.heading+windDirHourly(ndx)
    }
    
    func WindCurrentImage() -> some View {
        Image(systemName: "location.north.fill")
            .resizable()
            .frame(width: 24, height: 34)
            .foregroundColor(symbolColor)
            .rotationEffect(.degrees(cityProvider.windDirCurrent()))  // cityProvider.heading+windDirCurrent()
    }
    
}

