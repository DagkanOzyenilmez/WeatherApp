//
//  WeatherModel.swift
//  WeatherVS
//
//  Created by Dagkan on 17.05.2022.
//

import Foundation

struct WeatherModel {
    let conditionID: Int
    let cityName: String
    let temperature: Double
    let description: String
    
    var temperatureString : String {
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String {
        switch conditionID {
        case 200...232 :
            return "cloud.bolt"
        case 300...321 :
            return "cloud.drizlle"
        case 500...531 :
            return "cloud.rain"
        case 600...622 :
            return "cloud.snow"
        case 701...781 :
            return "cloud.fog"
        case 800 :
            return "sun.max"
        case 801...804 :
            return "cloud.sun"
        default:
            return "cloud"
        }
    }
}
