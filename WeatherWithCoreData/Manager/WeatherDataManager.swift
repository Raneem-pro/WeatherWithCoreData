//
//  WeatherDataManager.swift
//  WeatherWithCoreData
//
//  Created by رنيم القرني on 14/10/1445 AH.
//

import Foundation


struct WeatherData{
    let location : String
    let tempo : Double
    let dec : String
    let icons : String
}
// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let name: String
    let weather: [Weather]
    let main: Main
}

// MARK: - Main
struct Main: Codable {
    let temp : Double
}

// MARK: - Weather
struct Weather: Codable {
  let description : String
    let icon : String
}


