import SwiftUI
import Kingfisher
import CoreData

struct AddCityView: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @Environment(\.dismiss) var dismiss
    var cityName: String
    @State private var weatherData: WeatherData?
    @State private var cityExists: Bool = false
    
    var body: some View {
        NavigationView {
            VStack {
                Text(cityName)
                    .font(.title)
                
                Spacer()
                
                if let weatherData = weatherData {
                    VStack {
                        Text("\(Int(weatherData.tempo))°C")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.gray)
                        Text("\(weatherData.dec)")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.gray)
                        
                        KFImage(URL(string: "https://openweathermap.org/img/wn/\(weatherData.icons)@2x.png"))
                    }
                }
                
                Spacer()
            }
            .padding()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("dismiss", systemImage: "xmark")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    if !cityExists {
                        Button(action: {
                            WeatherDataController().addCity(cityName: cityName, context: managedObjectContext)
                            dismiss()
                        }) {
                            Label("Add city", systemImage: "plus.circle")
                        }
                    }
                }
            }
            .onAppear {
                WeatherService.fetchData(for: nil, cityName: cityName) { result in
                    switch result {
                    case .success(let data):
                        weatherData = data
                        
                        // Check if the city already exists in Core Data
                        cityExists = cityAlreadyExists(cityName: cityName)
                        
                    case .failure(let error):
                        print("Error fetching data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    // Function to check if the city already exists in Core Data
    private func cityAlreadyExists(cityName: String) -> Bool {
        let fetchRequest: NSFetchRequest<CityWeather> = CityWeather.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "cityName == %@", cityName)
        
        do {
            let cities = try managedObjectContext.fetch(fetchRequest)
            return !cities.isEmpty
        } catch {
            print("Error fetching cities: \(error)")
            return false
        }
    }
}

struct AddCityView_Previews: PreviewProvider {
    static var previews: some View {
        AddCityView(cityName: "Jeddah")
    }
}
