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
                print(json)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
