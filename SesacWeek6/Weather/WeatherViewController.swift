//
//  weatherViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/12.
//

import UIKit
import CoreLocation

import SkeletonView
import Kingfisher
import JGProgressHUD

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var locationButton: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var buttonStackView: UIStackView!
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var currentTempLabel: UILabel!
    @IBOutlet weak var maxMinTempLabel: UILabel!
    
    @IBOutlet weak var windView: UIView!
    @IBOutlet weak var windLabel: UILabel!
    
    @IBOutlet weak var humidityView: UIView!
    @IBOutlet weak var humidityLabel: UILabel!
    
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var pressureLabel: UILabel!
    
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLabel: UILabel!
    
    let locationManager = CLLocationManager()
    
    let hud = JGProgressHUD()
    
    var lat: Double = 37.517829
    var lon: Double = 126.886270

    override func viewDidLoad() {
        super.viewDidLoad()
        
        allHidden()
        
        hud.show(in: view)
        
        locationManager.delegate = self
        
        setUpSkeletonView()
        
        setUpUI()
                        
        //기본적으로 새싹캠퍼스의 날씨지만, 레이블은 서울만 표시(현대카드 웨더처럼)
        
        AddressAPIManager.shared.getLocationData(lat: lat, lon: lon) { value in
            self.locationLabel.text = "\(value.regionFirst)"
            
            WeatherAPIManager.shared.getWeatherData(lat: self.lat, lon: self.lon) { value in
                //첫번째 뷰
                let imageURL = URL(string: Endpoint.imageURL + "\(value.iconId)@2x.png")
                self.weatherImageView.kf.setImage(with: imageURL!)
                self.currentTempLabel.text = "\(WeatherModel.getWeather(weather: value.weather)) \(value.temp)°"
                self.maxMinTempLabel.text = "\(value.temp_max)° · \(value.temp_min)°"
                
                //두번째 뷰
                self.windLabel.text = "풍속    \(value.wind)m/s"
                
                //세번째 뷰
                self.humidityLabel.text = "습도    \(value.humidity)%"
                
                //네번째 뷰
                self.pressureLabel.text = "기압    \(value.pressure)hPa"
                
                //다섯번째 뷰
                self.messageLabel.text = WeatherModel.getMessage(weather: value.weather)
                
                self.hud.dismiss(animated: true)
                self.allShow()
            }
        }
        
    }
    
    func allHidden() {
        locationView.isHidden = true
        weatherView.isHidden = true
        windView.isHidden = true
        humidityView.isHidden = true
        pressureView.isHidden = true
        messageView.isHidden = true
    }
    
    func allShow() {
        locationView.isHidden = false
        weatherView.isHidden = false
        windView.isHidden = false
        humidityView.isHidden = false
        pressureView.isHidden = false
        messageView.isHidden = false
    }
    
    func setUpSkeletonView() {
        
        view.isSkeletonable = true
        timeLabel.isSkeletonable = true
        locationView.isSkeletonable = true
        locationView.skeletonCornerRadius = 10
        weatherView.isSkeletonable = true
        weatherView.skeletonCornerRadius = 10

        windView.isSkeletonable = true
        windView.skeletonCornerRadius = 10

        humidityView.isSkeletonable = true
        humidityView.skeletonCornerRadius = 10

        pressureView.isSkeletonable = true
        pressureView.skeletonCornerRadius = 10

        messageView.isSkeletonable = true
        messageView.skeletonCornerRadius = 10

        buttonStackView.isSkeletonable = true
        buttonStackView.skeletonCornerRadius = 10

    }
    
    func setUpUI() {
        view.backgroundColor = .systemGray5
        locationButton.image = UIImage(systemName: "location")
        locationLabel.font = UIFont(name: CustomFont.semibold, size: 25)
        currentTempLabel.font = UIFont(name: CustomFont.medium, size: 20)
        weatherView.layer.cornerRadius = 10
        maxMinTempLabel.font = UIFont(name: CustomFont.medium, size: 15)
        maxMinTempLabel.textColor = .lightGray
        windLabel.font = UIFont(name: CustomFont.medium, size: 20)
        windView.layer.cornerRadius = 10
        humidityLabel.font = UIFont(name: CustomFont.medium, size: 20)
        humidityView.layer.cornerRadius = 10
        pressureLabel.font = UIFont(name: CustomFont.medium, size: 20)
        pressureView.layer.cornerRadius = 10
        messageLabel.font = UIFont(name: CustomFont.medium, size: 20)
        messageView.layer.cornerRadius = 10
    }

}

//위치 관련 메서드
extension WeatherViewController {
    
    func checkLocationServiceAuthorizationStatus() {
        
        let authorizationStatus: CLAuthorizationStatus
        
        authorizationStatus = locationManager.authorizationStatus
        
        if CLLocationManager.locationServicesEnabled() {
            checkCurrentLocationAuthorizationStatus(authorizationStatus)
        } else {
            print("위치 권한 확인하세요.")
        }
    }
    
    func checkCurrentLocationAuthorizationStatus(_ authorizationStatus: CLAuthorizationStatus) {
        
        switch authorizationStatus {
        case .notDetermined:
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showRequestLocationServiceAlert()
        case .denied:
            showRequestLocationServiceAlert()
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        default:
            print("항상 허용")
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

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                
        if let coordinate = locations.last?.coordinate {
            lat = coordinate.latitude
            lon = coordinate.longitude
            
            print(lat, lon)
            
            allHidden()
            hud.show(in: view)
            
            AddressAPIManager.shared.getLocationData(lat: lat, lon: lon) { value in
                self.locationLabel.text = "\(value.regionFirst), \(value.regionThird)"
                
                WeatherAPIManager.shared.getWeatherData(lat: self.lat, lon: self.lon) { value in
                    //첫번째 뷰
                    let imageURL = URL(string: Endpoint.imageURL + "\(value.iconId)@2x.png")
                    self.weatherImageView.kf.setImage(with: imageURL!)
                    self.currentTempLabel.text = "\(WeatherModel.getWeather(weather: value.weather)) \(value.temp)°"
                    self.maxMinTempLabel.text = "\(value.temp_max)° · \(value.temp_min)°"
                    
                    //두번째 뷰
                    self.windLabel.text = "풍속    \(value.wind)m/s"
                    
                    //세번째 뷰
                    self.humidityLabel.text = "습도    \(value.humidity)%"
                    
                    //네번째 뷰
                    self.pressureLabel.text = "기압    \(value.pressure)hPa"
                    
                    //다섯번째 뷰
                    self.messageLabel.text = WeatherModel.getMessage(weather: value.weather)
                    
                    //위치 버튼 이미지 채우기
                    self.locationButton.image = UIImage(systemName: "location.fill")
                    
                    self.hud.dismiss(animated: true)
                    self.allShow()
                }
            }
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationServiceAuthorizationStatus()
    }
    
}
