//
//  SettingsView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/28.
//

import SwiftUI
import OWOneCall


struct SettingsView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var theKey = ""
    
    @State private var searchQuery: String = ""
    @State private var startLang: String?
    @FocusState var focusValue: Bool
    
    
    var body: some View {
        VStack (spacing: 20) {
#if targetEnvironment(macCatalyst)
            Button(action: {dismiss()}) {
                HStack {
                    Text("Done").foregroundColor(.blue)
                    Spacer()
                }
            }.padding(20)
#endif
            Text("Settings").padding(20)
            TextField("openweather key", text: $theKey)
                .foregroundColor(.blue)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(10)
            HStack {
                Spacer()
                TextField("default language", text: $searchQuery)
                    .focused($focusValue)
                    .foregroundColor(.blue).padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                    .foregroundColor(.blue)
                    .frame(width: 333)
                Button(action: {
                    searchQuery = ""
                    focusValue = false
                }) {
                    Image(systemName: "xmark.circle").font(.title)
                }
                Spacer()
            }.padding(.top, 40)
            
            Divider()
            ScrollViewReader { scroller in
                ScrollView (.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(cityProvider.langArr.filter{searchFor($0)}.sorted(by: { $0 < $1 }), id: \.self) { lang in
                            Button(action: {
                                searchQuery = lang
                            }) {
                                Text(lang).padding(10)
                                    .font(cityProvider.lang == lang ? .body : .caption)
                                    .foregroundColor(cityProvider.lang == lang ? Color.red : Color.primary)
                                    .frame(width: 120)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(cityProvider.lang == lang ? Color.red : Color.primary)
                                        .background(Color(UIColor.systemGray6))
                                        .padding(2))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    }
                }
                .onChange(of: startLang) {
                    if let str = startLang {
                        withAnimation {
                            scroller.scrollTo(str)
                        }
                    }
                }
            }
            Divider()
            
            Button(action: {onSave()}) {
                Text("Save").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                    .foregroundColor(.green))
                .padding(.top, 30)
            
            Spacer()
        }
        .onAppear {
            startLang = cityProvider.lang
        }
        .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }
    
    func onSave() {
        cityProvider.weatherProvider = OWProvider(apiKey: theKey)
        StoreService.shared.setOWKey(key: theKey)
        // todo validate lang
        StoreService.shared.setLang(str: self.cityProvider.lang)
        // to go back to the previous view
        dismiss()
    }
    
}
