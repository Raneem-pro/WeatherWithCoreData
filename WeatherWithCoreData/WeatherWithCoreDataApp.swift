//
//  WeatherWithCoreDataApp.swift
//  WeatherWithCoreData
//
//  Created by رنيم القرني on 14/10/1445 AH.
//

import SwiftUI

@main
struct WeatherWithCoreDataApp: App {
    @StateObject private var dataController = WeatherDataController()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
