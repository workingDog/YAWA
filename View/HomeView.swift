//
//  HomeView.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/25.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var cityProvider: CityProvider

    @State private var searchQuery: String = ""
    @State var showNewCity: Bool = false
    @State var showLang: Bool = false
    @State var action: Int? = 0
    @State var currentCity = City()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                NavigationLink(destination: WeatherDetails(city: self.currentCity), tag: 1, selection: $action) {
                    EmptyView()
                }
                Divider()
                HStack {
                    Button("Current location", action: {self.action = 1}).padding(5).buttonStyle(GradientButtonStyle())
                    Spacer()
                    TextField("city search", text: $searchQuery).padding(5)
                        .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.blue, lineWidth: 1))
                        .foregroundColor(.blue)
                        .frame(width: 160)
                    Button(action: {self.searchQuery = ""}) {
                        Image(systemName: "xmark.circle").font(.title)
                    }
                }.padding(.horizontal, 5)
                Divider()
                List {
                    ForEach(cityProvider.cities.filter{self.searchFor($0.name)}.sorted(by: { $0.name < $1.name })) { city in
                        CityRow(city: city)
                    }
                    .onDelete(perform: delete)
                  //  .onMove(perform: move)
                }.navigationBarItems(leading: langButton, trailing: addButton)
            }.navigationBarTitle(Text("Weather"))
            .onAppear(perform: loadData)
            
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func loadData() {
        let thisCity = cityProvider.getCurrentCity()
        currentCity = thisCity != nil ? thisCity! : City(name: "Tokyo", country: "Japan",
                                                         code: "jp",
                                                         lat: 35.6834,  lon: 139.7833)
    }
    
    struct GradientButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .foregroundColor(Color.white)
                .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.red, Color.orange]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(15.0)
        }
    }
    
    struct BlueButtonStyle: ButtonStyle {
        func makeBody(configuration: Self.Configuration) -> some View {
            configuration.label
                .foregroundColor(Color.white)
         //       .padding()
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10.0)
        }
    }
    
    private func searchFor(_ txt: String) -> Bool {
        return (txt.lowercased(with: .current).hasPrefix(searchQuery.trim().lowercased(with: .current)) || searchQuery.trim().isEmpty)
    }

    private var addButton: some View {
        Button(action: {self.showNewCity = true}) {
            Image(systemName: "plus.circle.fill").font(.title)
        }.sheet(isPresented: $showNewCity, onDismiss: {self.showNewCity = false}) {
            NewCityView().environmentObject(self.cityProvider)
        }
    }

    private var langButton: some View {
        Button(action: {self.showLang = true}) {
            Text(self.cityProvider.lang).font(.body).frame(width: 180, height: 35)
        }.buttonStyle(BlueButtonStyle())
        .sheet(isPresented: $showLang, onDismiss: {self.showLang = false}) {
            LanguageListView().environmentObject(self.cityProvider)
        }
    }
    
    private func delete(with indexSet: IndexSet) {
        // must sort the list as in the body
        let sortedList = cityProvider.cities.filter{self.searchFor($0.name)}.sorted(by: { $0.name < $1.name })
        // get the city from the sorted list
        let theCity = sortedList[indexSet.first!]
        // get the index of the city from the cityProvider, and remove it
        if let ndx = cityProvider.cities.firstIndex(of: theCity) {
            cityProvider.cities.remove(at: ndx)
        }
    }
    
    private func move(from source: IndexSet, to destination: Int) {
        var removeCities: [City] = []
        for index in source {
            removeCities.append(cityProvider.cities[index])
            cityProvider.cities.remove(at: index)
        }
        cityProvider.cities.insert(contentsOf: removeCities, at: destination)
    }
  
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
