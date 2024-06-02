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
    
    @Environment(CityProvider.self) var cityProvider
    
    @State private var theKey = ""
    
    @State private var searchQuery: String = ""
    @State private var startLang: String?
    @State private var prompt = "default language"
    @FocusState var focusValue: Bool
    
    
    var body: some View {
        VStack (spacing: 10) {
#if targetEnvironment(macCatalyst)
            Button(action: {dismiss()}) {
                HStack {
                    Text("Done").foregroundColor(.blue)
                    Spacer()
                }
            }.padding(20)
#endif
            Text("Settings").padding(10)
            TextField("openweather key", text: $theKey)
                .foregroundColor(.blue)
                .textFieldStyle(CustomTextFieldStyle())
                .padding(10)
            
            Button(action: {onSaveKey()}) {
                Text("Save key").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                    .foregroundColor(.green))
                .padding(20)
            
            Divider().frame(height: 6).background(.blue)
            
            Spacer()
            
            HStack {
                Spacer()
                TextField(prompt, text: $searchQuery)
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
            }.padding(.top, 30)
            
            ScrollViewReader { scroller in
                ScrollView (.horizontal) {
                    HStack(spacing: 10) {
                        ForEach(cityProvider.langArr.filter{searchFor($0)}.sorted(by: { $0 < $1 }), id: \.self) { lang in
                            Button(action: {
                                searchQuery = lang
                            }) {
                                Text(lang).padding(10)
                                    .font(cityProvider.lang == lang ? .body : .caption)
                                    .foregroundColor(cityProvider.lang == lang ? Color.blue : Color.primary)
                                    .frame(width: 120)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                        .stroke(lineWidth: 1)
                                        .foregroundColor(cityProvider.lang == lang ? Color.blue : Color.primary)
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
            }.padding(20)

            Button(action: {onSaveLang()}) {
                Text("Save language").padding(30).foregroundColor(Color.primary)
            }.cornerRadius(40)
                .overlay(RoundedRectangle(cornerRadius: 40).stroke(lineWidth: 2)
                    .foregroundColor(.green))
                .padding(.top, 20)
            
            Spacer()
        }
        .onAppear {
            startLang = cityProvider.lang
            if let lang = startLang {
                prompt = lang
            }
        }
        .frame(minWidth: 300, idealWidth: 400, maxWidth: .infinity)
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }
    
    func onSaveLang() {
        // todo validate lang
        StoreService.shared.setLang(str: cityProvider.lang)
        dismiss()
    }
    
    func onSaveKey() {
        if !theKey.isEmpty {
            cityProvider.weatherProvider = OWProvider(apiKey: theKey)
            StoreService.shared.setOWKey(key: theKey)
        }
        dismiss()
    }
    
}
