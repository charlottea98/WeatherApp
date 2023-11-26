//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Charlotte Andersson on 2023-11-25.
//

import Foundation
import CoreLocation

class WeatherManager {
    func getValue(forKey key: String) -> String? {
        guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
              let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] else {
            return nil
        }

        return dict[key] as? String
    }

    func getCurrentWeather(latitude:CLLocationDegrees, longitude:CLLocationDegrees) async throws -> ResponseBody {
        
        guard let apiToken = getValue(forKey: "OpenWeatherMapApiKey") else {fatalError("Missing API token")}
        
        guard let url = URL(string:"https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(apiToken)&units=metric") else {fatalError("Missing URL")}
        
        let urlRequest = URLRequest(url: url)
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {fatalError("Error fetching weather data")}
        
        let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
        
        return decodedData
    }
}

struct ResponseBody: Decodable {
    var coord: CoordinatesResponse
    var weather: [WeatherResponse]
    var main: MainResponse
    var name: String
    var wind: WindResponse

    struct CoordinatesResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Double
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Double
        var humidity: Double
    }
    
    struct WindResponse: Decodable {
        var speed: Double
        var deg: Double
    }
}

typealias MainToIcon = [String: String]

