//
//  LanguageChooser.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/27.
//

import SwiftUI

struct LanguageChooser: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State private var searchQuery: String = ""
    @State private var startLang: String?
    
    let columns = [ GridItem(.adaptive(minimum: 150)) ]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            HStack {
                Button(action: onDone) { Text("Done").foregroundColor(.blue)}
                Spacer()
            }.padding(15)
            HStack {
                Spacer()
                TextField("language search", text: $searchQuery).padding(10)
                    .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                    .foregroundColor(.blue)
                    .frame(width: 222)
                Button(action: {self.searchQuery = ""}) {
                    Image(systemName: "xmark.circle").font(.title)
                }
                Spacer()
            }.padding(20)
            Divider()
            HStack {
                Spacer()
                
                ScrollViewReader { scroller in
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(cityProvider.langArr.filter{self.searchFor($0)}.sorted(by: { $0 < $1 }), id: \.self) { lang in
                                Button(action: {
                                    self.cityProvider.lang = lang
                                    self.searchQuery = lang
                                }) {
                                    Text(lang).padding(10)
                                        .font(self.cityProvider.lang == lang ? .body : .caption)
                                        .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                                        .frame(width: 120)
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
                
                Spacer()
            }
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        startLang = cityProvider.lang
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }
    
    func onDone() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
