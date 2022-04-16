//
//  HourlyPage.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall


struct ChartsPage: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var tempData: [(x: Double, y: Double)] = []
    @State var rainData: [(x: Double, y: Double)] = []
    @State var snowData: [(x: Double, y: Double)] = []
    @State var windData: [(x: Double, y: Double)] = []
    @State var cloudData: [(x: Double, y: Double)] = []
    
    @State var viewtype = 0

    var body: some View {
        ScrollView {
            LineChartSwiftUI(theData: $tempData, title: "Temperature °", viewtype: $viewtype)
                .frame(height: 300)
            
            LineChartSwiftUI(theData: $rainData, title: "Chance of rain %", viewtype: $viewtype)
                .frame(height: 300)
            
            LineChartSwiftUI(theData: $windData, title: "Wind speed m/s", viewtype: $viewtype)
                .frame(height: 300)
            
            LineChartSwiftUI(theData: $cloudData, title: "Cloud coverage %", viewtype: $viewtype)
                .frame(height: 300)
            
            Spacer()
        }.padding(15)
        .onAppear(perform: loadData)
    }
      
    func loadData() {
        if let hourly = cityProvider.weather.hourly {
            let hstep = 3
            let startOfDay = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
            let now = Date().timeIntervalSince1970
            let hourStep: TimeInterval = 3600*Double(hstep)
            // make a vector of Int(TimeInterval) for each (hour*hstep)
            let hourVector = stride(from: startOfDay, to: now, by: hourStep).map { Int($0) }
            
            tempData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: hourly[i*hstep].temp)
            }
            
            rainData = (0..<hourVector.count).map { i in
                let prob = hourly[i*hstep].pop != nil ? hourly[i*hstep].pop! * 100.0 : 0.0
                return (x: Double(hourVector[i]), y: prob)
            }
            
            windData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: hourly[i*hstep].windSpeed)
            }
            
            cloudData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: Double(hourly[i*hstep].clouds))
            }
        }
    }
    
}

