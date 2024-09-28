//
//  CityRow.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import Foundation
import SwiftUI

struct CityRow: View {
    let city: City

    var body: some View {
        NavigationLink(destination: WeatherDetails(city: city)) {
            HStack {
                Text(city.name).frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Image(city.code).resizable().renderingMode(.original).frame(width: 40, height: 30)
                Spacer()
                Text(city.country).font(.caption).frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(10)
            .background(RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 1)
                .foregroundColor(Color.primary)
                .background(Color(UIColor.systemGray6))
                .shadow(radius: 3)
                .padding(2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
    
}
