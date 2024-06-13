import Foundation
import CoreLocation

struct WeatherService {
    static func fetchData(for location: CLLocation?, cityName: String?, completion: @escaping (Result<WeatherData, Error>) -> Void) {
        var urlString: String
        if let location = location {
            urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(location.coordinate.latitude)&lon=\(location.coordinate.longitude)&appid=\(ContentView().retrieveAPI())&units=metric"
        } else if let cityName = cityName {
            urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(ContentView().retrieveAPI())&units=metric"
        } else {
            completion(.failure(NetworkError.invalidRequest))
            return
        }
                    
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherResponse = try decoder.decode(WeatherResponse.self, from: data)
                let weatherData = WeatherData(location: weatherResponse.name, tempo: weatherResponse.main.temp, dec: weatherResponse.weather.first?.description ?? "", icons: weatherResponse.weather.first?.icon ?? "")
                completion(.success(weatherData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case invalidRequest
}
