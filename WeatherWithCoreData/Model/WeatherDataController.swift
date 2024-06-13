//
//  WeatherDataController.swift
//  WeatherWithCoreData
//
//  Created by رنيم القرني on 14/10/1445 AH.
//

import Foundation
import CoreData

class WeatherDataController:ObservableObject {
    
    let container: NSPersistentContainer
    
     init() {
        container = NSPersistentContainer(name: "CityWeather")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load the data \(error.localizedDescription)")
            }
        }
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            print("Data saved successfully!")
        } catch {
            print("Failed to save data: \(error.localizedDescription)")
        }
    }
    
    func addCity(cityName: String, context: NSManagedObjectContext) {
        let city = CityWeather(context: context)
        city.cityName = cityName
        city.cityId = UUID()
        city.date = Date()
        save(context: context)
    }
}
