//
//  LanguageListView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/27.
//

import SwiftUI

struct LanguageListView: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    let columns = [ GridItem(.adaptive(minimum: 150)) ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 5) {
                ForEach(cityProvider.langArr, id: \.self) { lang in
                    Button(action: {self.cityProvider.lang = lang}) {
                        Text(lang).padding(10)
                            .font(self.cityProvider.lang == lang ? .headline : .body)
                            .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .stroke(lineWidth: 2)
                                            .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                                            .background(Color(UIColor.systemGray6))
                                            .shadow(radius: 3)
                                            .padding(2))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(.top, 20)
        }
    }
    
}
