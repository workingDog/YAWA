//
//  YAWAApp.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/26.
//

import SwiftUI
import OWOneCall


@main
struct YAWAApp: App {
    
    @State var cityProvider = CityProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environment(cityProvider)
                .onAppear{
                    DispatchQueue.main.async {
                        let theKey = StoreService.shared.getOWKey() ?? "your key"
                        cityProvider.weatherProvider = OWProvider(apiKey: theKey)
                        cityProvider.lang = StoreService.shared.getLang() ?? "English"
                    }
                }
        }
    }
    
}
