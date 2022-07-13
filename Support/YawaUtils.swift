//
//  YawaUtils.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation
import SwiftUI


class YawaUtils {
    
    static func getLatLon(lat: String, lon: String) -> (Double, Double)? {
        if let theLat = Double(lat), let theLon = Double(lon),
           theLat > -90.0 && theLat < 90.0,
           theLon > -180.0 && theLon < 180.0 {
            return (theLat, theLon)
        }
        return nil
    }
    
    static func getNumberFormatter() -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.zeroSymbol = ""
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 0
        numberFormatter.locale = Locale.current
        return numberFormatter
    }
    
    static let langDictionary: [String:String] = [
        "af"  :  "Afrikaans",
        "al"  :  "Albanian",
        "ar"  :  "Arabic",
        "az"  :  "Azerbaijani",
        "bg"  :  "Bulgarian",
        "ca"  :  "Catalan",
        "cz"  :  "Czech",
        "da"  :  "Danish",
        "de"  :  "German",
        "el"  :  "Greek",
        "en"  :  "English",
        "eu"  :  "Basque",
        "fa"  :  "Persian (Farsi)",
        "fi"  :  "Finnish",
        "fr"  :  "French",
        "gl"  :  "Galician",
        "he"  :  "Hebrew",
        "hi"  :  "Hindi",
        "hr"  :  "Croatian",
        "hu"  :  "Hungarian",
        "id"  :  "Indonesian",
        "it"  :  "Italian",
        "ja"  :  "Japanese",
        "kr"  :  "Korean",
        "la"  :  "Latvian",
        "lt"  :  "Lithuanian",
        "mk"  :  "Macedonian",
        "no"  :  "Norwegian",
        "nl"  :  "Dutch",
        "pl"  :  "Polish",
        "pt"  :  "Portuguese",
        "pt_br"  :  "Portuguese (Brazil)",
        "ro"  :  "Romanian",
        "ru"  :  "Russian",
 //       "sv"  :  "Swedish",
        "se"  :  "Swedish",
        "sk"  :  "Slovak",
        "sl"  :  "Slovenian",
 //       "sp"  :  "Spanish",
        "es"  :  "Spanish",
        "sr"  :  "Serbian",
        "th"  :  "Thai",
        "tr"  :  "Turkish",
 //       "ua"  :  "Ukrainian",
        "uk"  :  "Ukrainian",
        "vi"  :  "Vietnamese",
        "zh_cn"  :  "Chinese Simplified",
        "zh_tw" :   "Chinese Traditional",
        "zu"  :  "Zulu"]  
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(12)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10.0)
    }
}

struct TealButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(12)
            .background(LinearGradient(gradient: Gradient(colors: [Color.teal, Color.teal]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10.0)
    }
}

struct BlueButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing))
            .cornerRadius(10.0)
    }
}

public struct CustomTextFieldStyle : TextFieldStyle {
    public func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .font(.callout)
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 15).strokeBorder(Color.blue, lineWidth: 2))
    }
}


