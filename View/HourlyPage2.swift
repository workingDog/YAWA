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

/*
import SwiftUI
import OWOneCall
import SwiftUICharts


struct HourlyPage2: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @Binding var city: City
    @Binding var weather: OWResponse
    
//    @State var tempData: [Double] = []
//    @State var rainData: [Double] = []
    
    @State var tempData = ChartData()
    @State var rainData = ChartData()
    
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
            BarChartView(data: tempData, title: "Temperature", legend: "Celcius")
            
//            CardView {
//                LineChart()
//                    .data(tempData)
//                    .chartStyle(blueStlye)
//            }.padding(20)
            
            Spacer()
            
            CardView {
                LineChart()
                  //  .data(rainData)
                    .chartStyle(orangeStlye)

            }.padding(20)
            
            Spacer()
        } .onAppear(perform: loadData)
    }
    
    func loadData() {
        var tempPoints: [(String,Double)] = []
        var rainPoints: [(String,Double)] = []
        if let hourly = weather.hourly {
            let _ = (0..<hourly.count).map { i in
                let hour: String = hourly[i].getDate().hour()
                // temperature
                tempPoints.append( (hour, hourly[i].temp) )
                // precipitation
                if let rain = hourly[i].rain?.the1H {
                    rainPoints.append( (hour, rain) )
                }
            }
        }
        tempData = ChartData(tempPoints)
        rainData = ChartData(rainPoints)
    }
  
}
*/
