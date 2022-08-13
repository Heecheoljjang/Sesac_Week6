//
//  WeatherAPIManager.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON

class WeatherAPIManager {
    
    private init() {}
    
    static let shared = WeatherAPIManager()
    
    func getWeatherData(lat: Double, lon: Double, completionHandler: @escaping (WeatherModel) -> ()) {
        
        let url = Endpoint.weatherURL + "lat=\(lat)&lon=\(lon)&appid=\(APIKey.openWeather)"
        
        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let main = json["main"]
                
                let temp = Int(round(main["temp"].doubleValue - 273.15))
                let tempMin = Int(round(main["temp_min"].doubleValue - 273.15))
                let tempMax = Int(round(main["temp_max"].doubleValue - 273.15))
                let pressure = main["pressure"].intValue
                let humidity = main["humidity"].intValue
                let wind = round(json["wind"]["speed"].doubleValue * 10) / 10
                let iconId = json["weather"][0]["icon"].intValue
                let weatherId = json["weather"][0]["id"].intValue
                
                let weather = WeatherModel(temp: temp, temp_min: tempMin, temp_max: tempMax, pressure: pressure, humidity: humidity, wind: wind, iconId: iconId, weatherId: weatherId)
                
                completionHandler(weather)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
