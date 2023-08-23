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
                .onAppear{
                    DispatchQueue.main.async {
                        let theKey = StoreService.shared.getOWKey() ?? "your key"
                        //   StoreService.shared.setOWKey(key: theKey)
                        cityProvider.weatherProvider = OWProvider(apiKey: theKey)
                        cityProvider.lang = StoreService.shared.getLang() ?? "English"
                    }
                }
        }
    }
    
}
