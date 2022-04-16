//
//  LineChartSwiftUI.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation
import SwiftUI
import Charts


struct LineChartSwiftUI: UIViewRepresentable {
    
    @Binding var theData: [(x: Double, y: Double)]
    @State var title: String
    // 0=Hour, 1=Month, 2=Week
    @Binding var viewtype: Int
    
    let theChart = LineChartView()
    
    func makeUIView(context: UIViewRepresentableContext<LineChartSwiftUI>) -> LineChartView {
        setupChart()
        return theChart
    }
    
    func updateUIView(_ uiView: LineChartView, context: UIViewRepresentableContext<LineChartSwiftUI>) {
        if viewtype == 2 {uiView.xAxis.setLabelCount(7, force: true)}
        uiView.xAxis.valueFormatter = DateValueFormatter(viewtype)
        let data = LineChartData(dataSets: [getData()])
        uiView.data = data
        uiView.notifyDataSetChanged()
    }
    
    func setupChart() {
        theChart.minOffset = 20
        theChart.isMultipleTouchEnabled = false
        theChart.doubleTapToZoomEnabled = false
        theChart.dragEnabled = false
        theChart.dragXEnabled = false
        theChart.dragYEnabled = false
        
        theChart.noDataText = "No Data Available"
        // theChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: theTimes)
        theChart.xAxis.labelPosition = .bottom
        // no grid lines
        theChart.xAxis.drawGridLinesEnabled = false
        theChart.xAxis.drawAxisLineEnabled = false
        theChart.leftAxis.drawGridLinesEnabled = false
        theChart.leftAxis.drawAxisLineEnabled = false
        
        theChart.xAxis.avoidFirstLastClippingEnabled = true
        // theChart.xAxis.setLabelCount(theTimes.count, force: true)
        theChart.xAxis.labelFont = .systemFont(ofSize: 10)
        theChart.legend.verticalAlignment = .top
        theChart.legend.font = .systemFont(ofSize: 14)
        theChart.leftAxis.labelFont = .systemFont(ofSize: 12)
        theChart.xAxis.valueFormatter = DateValueFormatter(viewtype)
        theChart.xAxis.granularity = 1.0
        if viewtype == 2 {theChart.xAxis.setLabelCount(7, force: true)}
        
        theChart.rightAxis.enabled = false
        theChart.leftAxis.axisMinimum = 0
        theChart.leftAxis.enabled = false
        
        theChart.legend.textColor = UIColor.label
        theChart.leftAxis.labelTextColor = UIColor.label
        theChart.xAxis.labelTextColor = UIColor.label

        theChart.leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: YawaUtils.getNumberFormatter())
    }
    
    func getData() -> LineChartDataSet {
        let dataPoints: [ChartDataEntry] = theData.map { ChartDataEntry(x: $0.x, y: $0.y) }
        
        let chartData = LineChartDataSet(entries: dataPoints, label: title)
        chartData.mode = .cubicBezier
        chartData.axisDependency = .left
        chartData.setColor(UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1))
        chartData.lineWidth = 4.0
        chartData.drawCirclesEnabled = true
        chartData.drawValuesEnabled = true
        chartData.fillAlpha = 0.26
        chartData.fillColor = UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)
        chartData.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        chartData.drawCircleHoleEnabled = true
        chartData.drawFilledEnabled = true
        chartData.valueFormatter = DefaultValueFormatter(formatter: YawaUtils.getNumberFormatter())

        chartData.valueFont = .systemFont(ofSize: 14)
        
        let color = ChartColorTemplates.joyful()[0]
        chartData.setColor(color)
        return chartData
    }

}
