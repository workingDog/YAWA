//
//  HomeView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import SwiftUI
import CoreLocation


struct HomeView: View {
    @Environment(CityProvider.self) var cityProvider
    
    @State private var searchQuery: String = ""
    @State private var showNewCity: Bool = false
    @State private var showSettings: Bool = false
    @State private var path = NavigationPath()

    @FocusState var focusValue: Bool
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 20) {
                HStack {
                    Button("Current location", action: { path.append(1) })
                        .buttonStyle(TealButtonStyle()).padding(8)
                    Spacer()
                    TextField("city search", text: $searchQuery).padding(5)
                        .focused($focusValue)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                        .foregroundColor(.blue)
                        .frame(width: 180)
                    Button(action: {
                        searchQuery = ""
                        focusValue = false
                    }) {
                        Image(systemName: "xmark.circle").font(.title)
                    }
                }.padding(5)
                Divider()
                List {
                    ForEach(cityProvider.cities.filter{searchFor($0.name)}
                        .sorted(by: { $0.name < $1.name })) { city in
                        CityRow(city: city)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
                .navigationBarTitleDisplayMode(.inline)
            }
            .navigationDestination(for: Int.self) { _ in
                WeatherDetails(city: cityProvider.getHomeCity())
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    addButton().padding(.top, 10)
                }
            }
        }
    }

    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }

    @ViewBuilder
    func addButton() -> some View {
        HStack {
            Button(action: {showNewCity = true}) {
                Image(systemName: "plus.circle.fill").font(.body)
            }
            .sheet(isPresented: $showNewCity) {
                NewCityView().environment(cityProvider)
            }.padding(.horizontal, 40)
            
            Button(action: {showSettings = true}) {
                Image(systemName: "gearshape").font(.body)
            }
            .sheet(isPresented: $showSettings) {
                SettingsView().environment(cityProvider)
            }
        }
    }

    private func delete(with indexSet: IndexSet) {
        // must sort the list as in the body
        let sortedList = cityProvider.cities.filter{searchFor($0.name)}.sorted(by: { $0.name < $1.name })
        if let first = indexSet.first, sortedList.count > first {
            // get the city from the sorted list
            let theCity = sortedList[first]
            // get the index of the city from the cityProvider, and remove it
            if let ndx = cityProvider.cities.firstIndex(of: theCity) {
                cityProvider.cities.remove(at: ndx)
            }
        }
    }

}
