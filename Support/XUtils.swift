//
//  XUtils.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import Foundation
import SwiftUI


class XUtils {

    static func getLatLon(lat: String, lon: String) -> (Double, Double)? {
        if let theLat = Double(lat), let theLon = Double(lon),
           theLat > -90.0 && theLat < 90.0,
           theLon > -180.0 && theLon < 180.0 {
            return (theLat, theLon)
        }
        return nil
    }
  
}

struct GradientButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .foregroundColor(Color.white)
            .padding(8)
            .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
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


