//
//  CityRow.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import SwiftUI

struct CityRow: View {
    
    @State var city: City
    
    var body: some View {
        NavigationLink(destination: WeatherDetails(city: self.city)) {
            HStack {
                Text(city.name).font(.title)
                Spacer()
                Text(city.country).font(.title)
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
