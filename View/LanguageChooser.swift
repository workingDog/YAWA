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
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(cityProvider.langArr.filter{self.searchFor($0)}.sorted(by: { $0 < $1 }), id: \.self) { lang in
                            Button(action: {
                                self.cityProvider.lang = lang
                                self.searchQuery = lang
                            }) {
                                Text(lang).padding(10)
                                    .font(self.cityProvider.lang == lang ? .headline : .body)
                                    .foregroundColor(self.cityProvider.lang == lang ? Color.red : Color.primary)
                                    .frame(width: 200)
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
                }
                Spacer()
            }
        }
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }
    
    func onDone() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
