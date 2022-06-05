//
//  WeatherManager.swift
//  WeatherVS
//
//  Created by Dagkan on 16.05.2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=34d8e5338f9a913b02089dc5ad8ef23e&units=metric"
    
    var delegate : WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName.lowercased())"
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees , longitute: CLLocationDegrees ) {
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitute)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        
        //1. Create a URL
        if let url = URL(string: urlString) {
            
            
            //2.Create a URL session
            let session = URLSession(configuration: .default)
            
            //3.Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        //self.delegate?.didFailWithError(error: error!)
                    }
                }
            }
            
            //4.Start the task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            let description = decodedData.weather[0].description
            
            let weather = WeatherModel(conditionID: id, cityName: name, temperature: temp, description: description)
            
            return weather
            
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
            
        
    }
    
    
    
}
