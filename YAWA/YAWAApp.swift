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
    
    let cityProvider = CityProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(cityProvider)
                .onAppear(perform: {
                    let theKey = StoreService.getOWKey() ?? "your key"
                 //   StoreService.setOWKey(key: theKey)
                    cityProvider.weatherProvider = OWProvider(apiKey: theKey)
                    cityProvider.lang = StoreService.getLang() ?? "English"
                })
        }
    }
    
}
