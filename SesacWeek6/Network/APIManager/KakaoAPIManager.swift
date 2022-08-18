//
//  KakaoAPIManager.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/08.
//

import Foundation

import Alamofire
import SwiftyJSON

struct User {
    fileprivate let name = "heecheol" // sturct 자체가 인터널이기때문에 다른 파일에서 인스턴스 생성가능. 하지만 인스턴스르 만든 후에 name에 접근 불가능. 구조체 사용가능. 다른 스위프트 파일은 xw
    let age = 12343 // 같은 스위프트 파일 내에서 같은 타입
}

extension User {
    func example() {
        print(self.name, self.age)
    }
}

struct Person {
    
    func exmaple() {
        let user = User()
        user.name
        user.age
        
    }
}
class KakaoAPIManager {
    private init() {}
    
    static let shared = KakaoAPIManager()
    
    private let header: HTTPHeaders = ["Authorization": "KakaoAK \(APIKey.kakao)"]
    
    func callRequest(type: Endpoint, query: String, completionHandler: @escaping (JSON) -> ()) {
        
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = type.requestURL + query
        
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                completionHandler(json)
            case .failure(let error):
                print(error)
            }
        }
    }
}
