//
//  HomeView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import SwiftUI
import MapKit
import CoreLocation


struct HomeView: View {
    
    @EnvironmentObject var cityProvider: CityProvider
    
    @State var searchQuery: String = ""
    @State var showNewCity: Bool = false
    @State var showLang: Bool = false
    @State var actions: [Int] = []
    @State var currentCity = City()
    
    @State var showSettings: Bool = false
    
    @State var region = MKCoordinateRegion()
    
    var body: some View {
        NavigationStack(path: $actions) {
            VStack(spacing: 20) {
                HStack {
                    Button("Current location", action: {actions = [1]})
                        .buttonStyle(TealButtonStyle()).padding(8)
                    Spacer()
                    TextField("city search", text: $searchQuery).padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                        .foregroundColor(.blue)
                        .frame(width: 160)
                    Button(action: {searchQuery = ""}) {
                        Image(systemName: "xmark.circle").font(.title)
                    }
                }.padding(.horizontal, 5).padding(.top, 10)
                Divider()
                List {
                    ForEach(cityProvider.cities.filter{searchFor($0.name)}.sorted(by: { $0.name < $1.name })) { city in
                        CityRow(city: city)
                    }
                    .onDelete(perform: delete)
                }
                .listStyle(.plain)
                .frame(maxWidth: .infinity, alignment: .center)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Weather")
            }.onAppear{ loadData() }
                .navigationDestination(for: Int.self) { val in
                    WeatherDetails(city: currentCity, region: region)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) { langButton.padding(.top, 10) }
                    ToolbarItem(placement: .navigationBarTrailing) { addButton.padding(.top, 10) }
                }
        }
    }
    
    func loadData() {
        currentCity = cityProvider.getCurrentCity()
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: currentCity.lat, longitude: currentCity.lon), span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0))
    }

    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }

    private var addButton: some View {
        HStack {
            Button(action: {showNewCity = true}) {
                Image(systemName: "plus.circle.fill").font(.body)
            }.sheet(isPresented: $showNewCity, onDismiss: {showNewCity = false}) {
                NewCityView().environmentObject(cityProvider)
            }.padding(.horizontal, 40)
            
            Button(action: {showSettings = true}) {
                Image(systemName: "gearshape").font(.body)
            }.sheet(isPresented: $showSettings, onDismiss: {showSettings = false}) {
                SettingsView().environmentObject(cityProvider)
            }
        }
    }

    private var langButton: some View {
        Button(action: {showLang = true}) {
            Text(cityProvider.lang).font(.body).frame(width: 120, height: 25)
        }.buttonStyle(BlueButtonStyle())
        .sheet(isPresented: $showLang, onDismiss: {showLang = false}) {
            LanguageChooser().environmentObject(cityProvider)
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

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
