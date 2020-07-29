//
//  DateValueFormatter.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation
import SwiftUI
import Charts


public class DateValueFormatter: NSObject, IAxisValueFormatter {
    
    private let dateFormatter = DateFormatter()
    
    // 0=Hour, 1=Month, 2=Week
    var viewtype: Int
    
    init(_ viewtype: Int) {
        self.viewtype = viewtype
        super.init()
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let theDate = Date(timeIntervalSince1970: value)
        switch viewtype {
        case 0:
            dateFormatter.dateFormat = "hh:mm a"
            return dateFormatter.string(from: theDate)
        case 1:
            dateFormatter.dateFormat = "MMM-dd"
            return dateFormatter.string(from: theDate)
        case 2:
            return dateFormatter.shortWeekdaySymbols[Calendar.current.component(.weekday, from: theDate) - 1]
        default:
            return dateFormatter.string(from: theDate)
        }
    }
}
