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
    
    var cityProvider = CityProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(self.cityProvider)
                .onAppear(perform: {
                    let theKey = StoreService.getOWKey() ?? "your key"
                 //   StoreService.setOWKey(key: theKey)
                    self.cityProvider.weatherProvider = OWProvider(apiKey: theKey)
                    self.cityProvider.lang = StoreService.getLang() ?? "English"
                })
        }
    }
    
}
