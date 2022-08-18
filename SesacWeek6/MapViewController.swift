//
//  MapViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/11.
//

import UIKit
import MapKit
//Location 1.임포트
import CoreLocation

/*
 MapView
 - 지도와 위치 권한은 상관없음.
 - 만약 지도에 현재 위치 등을 표현하고 싶은 경우에는 위치권한설정 필요
 - 중심, 범위 지정
 - 범위를 지정하느거랑 핀 지정이랑은 다름(핀을 어노테이션이라고함)
 */

/*
 권한: 반영이 조금씩 느릴 수 있음. 지웠다가 실행해도. 한 번 허용
 */
class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    //Location2. 위치에 대한 대부분을 담당
    let locationManager = CLLocationManager()
    
    var myLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 29.978485, longitude: 31.132462)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //Location3. 프로토콜 연결
        locationManager.delegate = self
        
        //지도 중심 설정: 애플맵 활용해서 좌표 복사
        let center = myLocation
        
        setRegionAndAnnotation(center: center)
        
        //checkUserDeviceLocationServiceAuthorization() 왜 지워도 되는지 이유알기

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showRequestLocationServiceAlert()
    }
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        //29.978485, 31.132462
        
        //지도 중심 기반으로 보여질 범위 설정(최초로 보여지는 맵인 것 같음)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        //어디가 center인지 알 수가 없음.
        //어노테이션추가(하나도 가능하고 여러 개도 가능함)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "피라미드"

        mapView.addAnnotation(annotation)
    }

}
//위치 관련된 User Defined메서드 (프로토콜에 관련된게 아니라서 나뉨)
extension MapViewController {
    
    //Location7. iOS버전에 따른 분기 처리 및 iOS위치 서비스 활성화 여부 확인
    //위치 서비스가 켜져 있다면 권한을 요청하고, 꺼져있다면 커스텀 얼럿으로 상황 알려주기
    //CLAuthorizationStatus
    // - denied: 허용 안함 / 설정에서 추후에 거부 / 위치 서비스 중지 / 비행기모드
    // - restricted: 앱 권한 자체 없는 경우 / 자녀 보호 기능 같은걸로 아예 제한
    func checkUserDeviceLocationServiceAuthorization() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            //인스턴스를 통해 locationManager가 가지고 있는 상태를 가져옴
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        //iOS 위치 서비스 활성화 여부 체크
        if CLLocationManager.locationServicesEnabled() {
            //위치 서비스가 활성화 되어 있으므로, 위치 권한 요청 가능해서 위치 권한 요청함
            checkUserCurrentLocationAuthorization(authorizationStatus)
        } else {
            print("위치 서비스가 꺼져 있어서 위치 권한 요청을 못합니다.")
        }
    }
    //Location8. 사용자의 위치 권한 상태 확인
    //사용자가 위치를 허용했는지, 거부했는지, 아직 선택하지 않았는지 등을 확인(단, 사전에 iOS 위치 서비스 활성화 꼭 확인)
    func checkUserCurrentLocationAuthorization(_ authorizationStatus: CLAuthorizationStatus) {
        
        //자동완성됨
        //authorizedAlways 상태 갖고 싶으면 plist에서 추가해야함.
        switch authorizationStatus {
        case .notDetermined:
            print("Not determined")
            
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization() // 앱을 사용하는 동안에 대한 위치 권한 요청
            //plist에 wheninuse가 등록되어있어야 request메서드를 사용할수있음.

        case .restricted, .denied:
            print("Denied, 아이폰 설정으로 유도")
            
        case .authorizedWhenInUse:
            print("When in use")
            //사용자가 위치를 허용해둔 상태라면, startUpdatingLocation을 통해 didUpdateLocations메서드가 실행
            locationManager.startUpdatingLocation()
        default: print("default")
        }
    }
    func showRequestLocationServiceAlert() {
      let requestLocationServiceAlert = UIAlertController(title: "위치정보 이용", message: "위치 서비스를 사용할 수 없습니다. 기기의 '설정>개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
      let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
          
          //설정페이지로 가는링크
          if let appSetting = URL(string: UIApplication.openSettingsURLString) {
              UIApplication.shared.open(appSetting)
          }
          
      }
      let cancel = UIAlertAction(title: "취소", style: .default)
      requestLocationServiceAlert.addAction(cancel)
      requestLocationServiceAlert.addAction(goSetting)
      
      present(requestLocationServiceAlert, animated: true, completion: nil)
    }
    
}


//Location4. 프로토콜 선언
extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(#function, locations)
        
        if let coordinate = locations.last?.coordinate {
            
            myLocation = coordinate // 데이터 전달을 위해
            print(coordinate)
        }
        
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    //iOS14 이상: 사용자의 권한 상태가 변경이 될 때, 위치 관리자 생성할 때 호출됨, 인스턴스 생성할때 실행됨.
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(#function)
        checkUserDeviceLocationServiceAuthorization()
    }
    //iOS14미만
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    //지도에 커스텀 핀(어노테이션) 추가
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        <#code#>
//    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        locationManager.startUpdatingLocation()
    }
}
