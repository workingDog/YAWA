//
//  LanguageView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/27.
//

import SwiftUI

struct LanguageView: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State private var langSelection: Int = 0
    
    
    var body: some View {
        Picker("", selection: Binding<Int>(
                get: { self.langSelection },
                set: {
                    self.langSelection = $0
                    self.cityProvider.lang = self.cityProvider.langArr[langSelection]
                })) {
            ForEach(0..<self.cityProvider.langArr.count) {
                Text(self.cityProvider.langArr[$0]).font(.title)
            }
        }.pickerStyle(WheelPickerStyle())
        .frame(width: 444, height: 555)
        .onAppear(perform: loadData)
    }
    
    func loadData() {
        if let ndx = self.cityProvider.langArr.firstIndex(of: self.cityProvider.lang) {
            langSelection = ndx
        }
    }
    
}
