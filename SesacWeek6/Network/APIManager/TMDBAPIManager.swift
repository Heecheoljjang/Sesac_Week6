//
//  TMDBAPIManager.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/10.
//

import Foundation

import Alamofire
import SwiftyJSON

class TMDBAPIManager {
    
    private init() {}
    
    static let shared = TMDBAPIManager()
    
    let tvList = [
        ("환혼", 135157),
        ("이상한 변호사 우영우", 197067),
        ("인사이더", 135655),
        ("미스터 션사인", 75820),
        ("스카이 캐슬", 84327),
        ("사랑의 불시착", 94796),
        ("이태원 클라스", 96162),
        ("호텔 델루나", 90447)
    ]
    
    let imageURL = "https://image.tmdb.org/t/p/w500"
    
    
    func callRequest(query: Int, completionHandler: @escaping ([String]) -> ()) {
                
        let url = "https://api.themoviedb.org/3/tv/\(query)/season/1?api_key=\(APIKey.tmdb)&language=ko-KR"

        AF.request(url, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print(json)
                var stillArray: [String] = []
                
                stillArray = json["episodes"].arrayValue.map { $0["still_path"].stringValue }
                
                completionHandler(stillArray)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func requestEpisodeImage() {
        
        // 이렇게 작성하면 생기는 문제 ?
        // 1. 순서 보장 x 2. 언제 끝날 지 모름 3. 리밋(짧은 시간내에 많은 응답보내면 막힘)
//        for item in tvList {
//            TMDBAPIManager.shared.callRequest(query: item.1) { stillPath in
//                print(stillPath)
//            }
//        }
        
        
//        let id = tvList[7].1
//
//        TMDBAPIManager.shared.callRequest(query: id) { stillPath in
//            print(stillPath)
//            TMDBAPIManager.shared.callRequest(query: id) { <#[String]#> in
//                <#code#>
//            }
//        }
        
    }
    func requestImage(completionHandler: @escaping ([[String]]) -> ()) {
        
        // 나중에 배울 것: async / await
        var posterList: [[String]] = []
        
        TMDBAPIManager.shared.callRequest(query: tvList[0].1) { value in
            posterList.append(value)

            TMDBAPIManager.shared.callRequest(query: self.tvList[1].1) { value in
                posterList.append(value)

                TMDBAPIManager.shared.callRequest(query: self.tvList[2].1) { value in
                    posterList.append(value)
                   
                    TMDBAPIManager.shared.callRequest(query: self.tvList[3].1) { value in
                        posterList.append(value)
                     
                        TMDBAPIManager.shared.callRequest(query: self.tvList[4].1) { value in
                            posterList.append(value)
                           
                            TMDBAPIManager.shared.callRequest(query: self.tvList[5].1) { value in
                                posterList.append(value)
                                
                                TMDBAPIManager.shared.callRequest(query: self.tvList[6].1) { value in
                                    posterList.append(value)
                                    
                                    TMDBAPIManager.shared.callRequest(query: self.tvList[7].1) { value in
                                        posterList.append(value)
                                        completionHandler(posterList)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
