//
//  ContentView.swift
//  WeatherWithCoreData
//
//  Created by رنيم القرني on 14/10/1445 AH.
//

import SwiftUI
import Kingfisher
import CoreData

struct ContentView: View {
    @State private var cityName = ""
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .forward)]) var cities: FetchedResults<CityWeather>
    @StateObject private var locationManager = LocationManager()
    @State private var currentLocationWeatherData: WeatherData?
    @State private var cityWeatherData: [String: WeatherData] = [:]
    @State private var isShowingCityWeather = false
    let columns = [GridItem(.flexible())]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $cityName)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    Button(action:{
                        isShowingCityWeather.toggle()
                    }) {
                        Image(systemName: "magnifyingglass")
                    }.sheet(isPresented: $isShowingCityWeather){
                        AddCityView(cityName: cityName)
                    }
                    .padding()
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 5) {
                        if let currentLocationWeatherData = currentLocationWeatherData {
                            displayCurrentLocationWeather(weatherData: currentLocationWeatherData)
                        }
                        ForEach(cities) { city in
                            displayTasks(for: city)
                                .contextMenu {
                                    Button(action: {
                                        deleteCity(offsets: IndexSet(integer: cities.firstIndex(of: city)!))
                                    }) {
                                        Text("Delete")
                                        Image(systemName: "trash")
                                    }
                                }
                        }
                    }
                }
                .padding()
                .onAppear {
                    locationManager.requestLocation()
                }
                .onReceive(locationManager.$location) { location in
                    if let location = location {
                        WeatherService.fetchData(for: location, cityName: nil) { result in
                            switch result {
                            case .success(let weatherData):
                                self.currentLocationWeatherData = weatherData
                            case .failure(let error):
                                print("Failed to fetch weather data: \(error)")
                            }
                        }
                    }
                }
            }
            .navigationTitle("Weather")
        }
    }

    func displayTasks(for city: CityWeather) -> some View {
        VStack {
            HStack {
                Text("\(city.cityName ?? "")")
                    .font(.title3).bold()
                Spacer()
                if let cityName = city.cityName, let weatherData = cityWeatherData[cityName] {
                    Text("\(Int(weatherData.tempo))°C")
                        .font(.custom("", size: 20))
                        .padding()
                } else {
                    ProgressView()
                }
            }
            Spacer()
            if let cityName = city.cityName, let weatherData = cityWeatherData[cityName] {
                HStack {
                    Text("\(weatherData.dec)")
                        .font(.title3).bold()
                        .padding()
                    Spacer()
                    KFImage(URL(string: "https://openweathermap.org/img/wn/\(weatherData.icons).png")!)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .accentColor(.white)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
        .onAppear {
            if let cityName = city.cityName {
                WeatherService.fetchData(for: nil, cityName: cityName) { result in
                    switch result {
                    case .success(let data):
                        cityWeatherData[cityName] = data
                    case .failure(let error):
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func displayCurrentLocationWeather(weatherData: WeatherData) -> some View {
        VStack {
            HStack {
                Text("My Location")
                    .font(.title3).bold()
                Spacer()
                Text("\(Int(weatherData.tempo))°C")
                    .font(.custom("", size: 20))
                    .padding()
            }
            Spacer()
            HStack {
                Text("\(weatherData.dec)")
                    .font(.title3).bold()
                    .padding()
                Spacer()
                KFImage(URL(string: "https://openweathermap.org/img/wn/\(weatherData.icons).png")!)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .accentColor(.white)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 14.0, style: .continuous))
    }

    public func retrieveAPI() -> String {
        return "abbc7f4639c6cc3b2b93917f59170de3"
    }
    
    func deleteCity(offsets: IndexSet) {
        withAnimation {
            offsets.map { cities[$0] }.forEach { city in
                managedObjectContext.delete(city)
            }
            do {
                try managedObjectContext.save()
            } catch {
                print("Error deleting city: \(error)")
            }
        }
    }

}



#Preview {
    ContentView()
}

