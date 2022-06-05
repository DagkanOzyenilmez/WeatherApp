//
//  ViewController.swift
//  WeatherVS
//
//  Created by Dagkan on 14.05.2022.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var dataLoading: UILabel!
    @IBOutlet weak var locationButton: UIButton!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
        
        
    }
    
    @IBAction func locationPressed(_ sender: UIButton) {
        locationManager.requestLocation()
        dataLoading.text = "Location data preparing ... "
        dataLoading.textColor = UIColor.gray
    }
    
}

//MARK: -UITextFieldDelegate

extension ViewController : UITextFieldDelegate {
    
    
    
    @IBAction func searchPressed(_ sender: UIButton) {
        //Below code trigers after user presses search button.
        
        searchTextField.endEditing(true)
        
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //Below code trigers after user presses go(return) button on keyboard.
        
        searchTextField.endEditing(true)
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //Below code prevent user to leave search area empty.
        if textField.text != "" {
            return true
        } else {
            textField.placeholder = "Type something here !"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //Below code arange search area placeHolder after search.
        
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        searchTextField.text = ""
        textField.placeholder = "Type a city name"
    }
}

//MARK: - WeatherManagerDelegate


extension ViewController : WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager,  weather: WeatherModel) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.cityLabel.text = weather.cityName
            self.conditionLabel.text = weather.description
            self.dataLoading.text = ""
        }
        print(weather.description)
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitute: lon)
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
