//
//  WeatherModel.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/13.
//

import Foundation

struct WeatherModel {
    
    let temp: Int
    let temp_min: Int
    let temp_max: Int
    let pressure: Int
    let humidity: Int
    let wind: Double
    let iconId: String
    let weather: String
    
    static func getWeather(weather: String) -> String {
        
        switch weather {
        case Weather.thunderStorm:
            return "뇌우"
        case Weather.drizzle:
            return "이슬비"
        case Weather.rain:
            return "비"
        case Weather.snow:
            return "눈"
        case Weather.clear:
            return "맑음"
        case Weather.clouds:
            return "흐림"
        default :
            return "안개"
        }
    }
    
    static func getMessage(weather: String) -> String {
        switch weather {
        case Weather.thunderStorm:
            return "나무 아래에 있지 마세요."
        case Weather.drizzle:
            return "이 정도 비는 맞아도 돼요."
        case Weather.rain:
            return "비가 내리고 음악이 흐르면"
        case Weather.snow:
            return "많이 미끄러우니 조심하세요."
        case Weather.clear:
            return "맑은 날엔 외출이죠."
        case Weather.clouds:
            return "내일 비가 올 수도 있겠어요."
        default :
            return "안개가 있네요. 앞을 조심하세요."
        }
    }
}

enum Weather {
        
    static let thunderStorm = "Thunderstorm"
    static let drizzle = "Drizzle"
    static let rain = "Rain"
    static let snow = "Snow"
    static let clear = "Clear"
    static let clouds = "Clouds"
    
}
