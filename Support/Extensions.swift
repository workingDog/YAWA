//
//  Extensions.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import CoreGraphics
import MapKit
import SwiftUI


extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

}

public extension Int {
    
    func dateFromUTC() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self))
    }
    
}

public extension Date {
    
    var utc: Int {
        return Int(self.timeIntervalSince1970)
    }

    init(utc: Int) {
        self = Date(timeIntervalSince1970: TimeInterval(utc))
    }
    
    func dayName(lang: String = "en") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: lang)
        return dateFormatter.string(from: self)
    }
    
    func dayMonthNumber(lang: String = "en") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
    
    func monthDay(lang: String = "en") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: lang)
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: self)
        return dayName(lang: lang) + ", " + month + " " + dayMonthNumber(lang: lang)
    }
    
    func hour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    func hourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
}

