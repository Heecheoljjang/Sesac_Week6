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
    
    func getLocationData(lan: Double, lon: Double, completionHandler: @escaping (AddressModel) -> ()) {
        
        
        
    }
}
