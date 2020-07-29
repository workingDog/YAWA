//
//  HourlyPage2.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

//
//  HourlyPage.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall
import SwiftUICharts


struct HourlyPage2: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse
    
    @State var tempData: [Double] = []
    @State var rainData: [Double] = []
    
    @State var title = ""
    @State var viewtype = 0
    
    let mixedColorStyle = ChartStyle(backgroundColor: .white, foregroundColor: [
        ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark),
        ColorGradient(.purple, .blue)
    ])
    let blueStlye = ChartStyle(backgroundColor: .white,
                               foregroundColor: [ColorGradient(.purple, .blue)])
    let orangeStlye = ChartStyle(backgroundColor: .white,
                                 foregroundColor: [ColorGradient(ChartColors.orangeBright, ChartColors.orangeDark)])
    
    
    var body: some View {
        VStack {
            CardView {
                LineChart()
                    .data(tempData)
                    .chartStyle(blueStlye)
            }.padding(20)
            
            Spacer()
            
            CardView {
                LineChart()
                    .data(rainData)
                    .chartStyle(orangeStlye)

            }.padding(20)
            
            Spacer()
        } .onAppear(perform: loadData)
    }
    
    func loadData() {
        if let hourly = weather.hourly {
            (0..<hourly.count).map{ i in
                // temperature
                self.tempData.append(hourly[i].temp)
                // precipitation
                if let rain = hourly[i].rain?.the1H {
                    self.rainData.append(rain)
                }
            }
        }
        self.rainData = [0, 5, 6, 2, 13, 4, 3, 6]
    }
    
    
    
}

