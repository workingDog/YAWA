//
//  ChartsPage.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall
import Charts


struct WData: Identifiable {
    let id = UUID()
    var date: Date
    var value: Double
}

struct ChartsPage: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var tempData: [WData] = []
    @State var rainData: [WData] = []
    @State var windData: [WData] = []
    @State var cloudData: [WData] = []
    //   @State var snowData: [WData] = []
    
    @State var viewtype = 0
    
    // not used yet
    var ChartsTool: some View {
        HStack {
            Spacer()
            Picker("", selection: $viewtype) {
                Text("Hour").tag(0)
                Text("Month").tag(1)
                Text("Week").tag(2)
            }
            .pickerStyle(.segmented)
            .labelsHidden()
            .padding(5)
            .fixedSize()
        }.padding(5)
    }
    
    func chartOf(_ data: [WData], title: String, yaxis: String) -> some View {
        GroupBox(title) {
            Chart (data) { wdata in
                LineMark(
                    x: .value("hour", wdata.date, unit: .hour),
                    y: .value("value", wdata.value)
                ).interpolationMethod(.monotone)
                PointMark(
                    x: .value("hour", wdata.date, unit: .hour),
                    y: .value("value", wdata.value)
                ).foregroundStyle(.red)
                .annotation(position: .top) {
                    Text("\(wdata.value, specifier: "%.1f")").font(.caption)
                }
            }.frame(height: 333)
                .chartYAxis {
                    AxisMarks() { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            Text("\(value.as(Int.self) ?? 0)\(yaxis)")
                        }
                    }
                }
        }
    }
    
    var body: some View {
        ScrollView {
            chartOf(tempData, title: "Temperature °C", yaxis: "°")
            chartOf(rainData, title: "Chance of rain %", yaxis: "%")
            chartOf(windData, title: "Wind speed m/s", yaxis: " m/s")
            chartOf(cloudData, title: "Cloud coverage %", yaxis: "%")
        }
        .chartXAxis {
            AxisMarks(values: .stride(by: .hour, count: 2)) { _ in
                AxisTick()
                AxisGridLine()
                AxisValueLabel(format: .dateTime.hour(.defaultDigits(amPM: .abbreviated)), centered: true)
            }
        }
        .chartPlotStyle {
            $0.background(.pink.opacity(0.1))
                .border(Color.pink, width: 1)
        }
        .padding(30)
        .onAppear{ loadData() }
    }
    
    func loadData() {
        if let hourly = cityProvider.weather.hourly {
            let hstep = 3
            let startOfDay = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
            let now = Date().timeIntervalSince1970
            let hourStep: TimeInterval = 3600*Double(hstep)
            // make a vector of Date for each (hour*hstep)
            let hourVector = stride(from: startOfDay, to: now, by: hourStep).map { Date(timeInterval: $0, since: Date()) }
            
            tempData = (0..<hourVector.count).map { i in
                return WData(date: hourVector[i], value: hourly[i*hstep].temp)
            }
            
            rainData = (0..<hourVector.count).map { i in
                let prob = hourly[i*hstep].pop != nil ? hourly[i*hstep].pop! * 100.0 : 0.0
                return WData(date: hourVector[i], value: prob)
            }
            
            windData = (0..<hourVector.count).map { i in
                return WData(date: hourVector[i], value: hourly[i*hstep].windSpeed)
            }
            
            cloudData = (0..<hourVector.count).map { i in
                return WData(date: hourVector[i], value: Double(hourly[i*hstep].clouds))
            }
        }
    }
    
}
