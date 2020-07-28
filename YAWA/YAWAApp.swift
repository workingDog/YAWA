//
//  YAWAApp.swift
//  YAWA
//
//  Created by Ringo Wathelet on 2020/07/26.
//

import SwiftUI

@main
struct YAWAApp: App {
    
    var cityProvider = CityProvider()
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(self.cityProvider)
                .onAppear(perform: {
                    self.cityProvider.owkey = StoreService.getOWKey() ?? "your key"
                    self.cityProvider.lang = StoreService.getLang() ?? "English"
                })
        }
    }
    
}
