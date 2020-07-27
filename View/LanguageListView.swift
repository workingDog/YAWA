//
//  LanguageListView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/27.
//

import SwiftUI

struct LanguageListView: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    var body: some View {
        VStack {
            List {
                ForEach(cityProvider.langArr, id: \.self) { lang in
                    Button(action: {self.cityProvider.lang = lang}) {
                        Text(lang).padding(10).foregroundColor(self.cityProvider.lang == lang ? Color.white : Color.primary)
                    }.frame(width: 300)
                    .listRowBackground(self.cityProvider.lang == lang ? Color.blue : Color(UIColor.systemGroupedBackground))
                }
            }
        }.frame(width: 300)
    }
    
}
