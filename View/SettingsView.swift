//
//  SettingsView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall


struct SettingsView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var theKey = "your key"
    
    @State private var searchQuery: String = ""
    @State private var startLang: String?
    
    
    var body: some View {
        VStack (spacing: 30) {
            Text("Settings").padding(30)
            TextField("openweather key", text: $theKey).foregroundColor(.blue)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(.top, 40)
            HStack {
                Spacer()
                TextField("language search", text: $searchQuery).foregroundColor(.blue).padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                    .foregroundColor(.blue)
                    .frame(width: 333)
                Button(action: {self.searchQuery = ""}) {
                    Image(systemName: "xmark.circle").font(.title)
                }
                Spacer()
            }.padding(.top, 40)
            
            ScrollViewReader { scroller in
                ScrollView (.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(cityProvider.langArr.filter{self.searchFor($0)}.sorted(by: { $0 < $1 }), id: \.self) { lang in
                            Button(action: {
                                self.cityProvider.lang = lang
                                self.searchQuery = lang
                            }) {
                                Text(lang).padding(10)
                                    .font(self.cityProvider.lang == lang ? .body : .caption)
                                    .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                                    .frame(width: 100)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                                                    .background(Color(UIColor.systemGray6))
                                                    .padding(2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }.onChange(of: self.startLang) { txt in
                    if let str = txt {
                        withAnimation {
                            scroller.scrollTo(str)
                        }
                    }
                }
            }
            
            Button(action: {self.onSave()}) {
                Text("Save").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
            .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                        .foregroundColor(.green))
            .padding(.top, 30)
            
            Spacer()
        }.onAppear(perform: loadData)
        .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
    }
    
    func loadData() {
        startLang = cityProvider.lang
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }
    
    func onSave() {
        self.cityProvider.weatherProvider = OWProvider(apiKey: theKey)
        StoreService.setOWKey(key: theKey)
        // todo validate lang
        StoreService.setLang(str: self.cityProvider.lang)
        // to go back to the previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
}
