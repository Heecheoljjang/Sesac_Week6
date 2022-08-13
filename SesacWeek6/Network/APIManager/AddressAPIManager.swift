//
//  AddressAPIManager.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/13.
//

import Foundation

import Alamofire
import SwiftyJSON

class AddressAPIManager {
    
    private init() {}
    
    static let shared = AddressAPIManager()
    
    func getLocationData(lat: Double, lon: Double, completionHandler: @escaping (AddressModel) -> ()) {
        
        let url = Endpoint.kakaoAddress + "x=\(lon)&y=\(lat)&input_coord=WGS84"
        
        let header: HTTPHeaders = [
            "Authorization": "KakaoAK 62c44e9aa0dc53cc2131bef3065b902e"
        ]
        
        AF.request(url, method: .get, headers: header).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                let address = json["documents"].arrayValue[0]["address"]
                
                let first = address["region_1depth_name"].stringValue
                let third = address["region_3depth_name"].stringValue
                
                completionHandler(AddressModel(regionFirst: first, regionThird: third))
                            
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
