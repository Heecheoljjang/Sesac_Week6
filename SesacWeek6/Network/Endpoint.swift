//
//  Endpoint.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/08.
//

import Foundation

enum Endpoint {
    case blog
    case cafe
    
    //저장 프로퍼티를 못쓰는 이유 -> 초기화를 못하기때문
    //연산 프로퍼티는 메서드처럼 사용하기때문에 사용가능.
    var requestURL: String {
        switch self {
        case .blog:
            return URL.makeEndPointString("blog?query=")
        case .cafe:
            return URL.makeEndPointString("cafe?query=")
        }
    }
    
    static let kakaoAddress = "https://dapi.kakao.com/v2/local/geo/coord2regioncode.json?"
    static let weatherURL = "https://api.openweathermap.org/data/2.5/weather?"
}
