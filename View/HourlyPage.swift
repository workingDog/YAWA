//
//  HourlyPage.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall
import SwiftUICharts


struct HourlyPage: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse
    
    @State var tempData: [(x: Double, y: Double)] = []
    @State var rainData: [(x: Double, y: Double)] = []
    @State var snowData: [(x: Double, y: Double)] = []
    @State var windData: [(x: Double, y: Double)] = []
    @State var cloudData: [(x: Double, y: Double)] = []
    
    @State var viewtype = 0

    var body: some View {
        ScrollView {
            LineChartSwiftUI(theData: self.$tempData, title: "Temperature °", viewtype: self.$viewtype)
                .frame(height: 333)
            
            LineChartSwiftUI(theData: self.$rainData, title: "Chance of rain %", viewtype: self.$viewtype)
                .frame(height: 333)
            
            LineChartSwiftUI(theData: self.$windData, title: "Wind speed m/s", viewtype: self.$viewtype)
                .frame(height: 333)
            
            LineChartSwiftUI(theData: self.$cloudData, title: "Cloud coverage %", viewtype: self.$viewtype)
                .frame(height: 333)
            
            Spacer()
        }.padding(10)
        .onAppear(perform: loadData)
    }
      
    func loadData() {
        if let hourly = weather.hourly {
            let hstep = 3
            let startOfDay = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
            let now = Date().timeIntervalSince1970
            let hourStep: TimeInterval = 3600*Double(hstep)
            // make a vector of Int(TimeInterval) for each (hour*hstep)
            let hourVector = stride(from: startOfDay, to: now, by: hourStep).map { Int($0) }
            
            self.tempData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: hourly[i*hstep].temp)
            }
            
            self.rainData = (0..<hourVector.count).map { i in
                let prob = hourly[i*hstep].pop != nil ? hourly[i*hstep].pop! * 100.0 : 0.0
                return (x: Double(hourVector[i]), y: prob)
            }
            
            self.windData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: hourly[i*hstep].windSpeed)
            }
            
            self.cloudData = (0..<hourVector.count).map { i in
                return (x: Double(hourVector[i]), y: Double(hourly[i*hstep].clouds))
            }
        }
    }
    
}

