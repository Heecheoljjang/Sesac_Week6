//
//  weatherViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/12.
//

import UIKit
import CoreLocation

//import Kingfisher
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
    
    @IBOutlet var views: [UIView]!
    
    
    let locationManager = CLLocationManager()
    
    let geocoder = CLGeocoder()
    
    let hud = JGProgressHUD()
    
    var timer = Timer()
    
    var hiddenValue = false
    
    //기본 새싹캠퍼스 좌표
    var lat: Double = 37.517829
    var lon: Double = 126.886270
    
    var myLocation = CLLocationCoordinate2D(latitude: 37.517829, longitude: 126.886270)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
            
        setUpUI()
        
        getCurrentTime()
        
        allHidden(isHidden: hiddenValue)
        
    }
    
    //skeleton쓰니까 뷰가 살짝 보이는 오류가 있어서 hidden하기로함. 어차피 객체가 올라와있는건 동일하므로 메모리 낭비 아닐 것 같음.
    func allHidden(isHidden: Bool) {

        hiddenValue = !isHidden
        timeLabel.isHidden = !isHidden
        views.forEach { view in
            view.isHidden = !isHidden
        }
        
        !isHidden ? hud.show(in: view) : hud.dismiss(animated: true)
    }

    //UI 메서드
    func setUpUI() {
        view.backgroundColor = .systemGray5
        timeLabel.font = UIFont(name: CustomFont.medium, size: 16)
        locationButton.image = UIImage(systemName: ImageSelection.empty)
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

    //시간 메서드
    func getCurrentTime() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector:#selector(self.currentTime), userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM. dd(E) HH:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        formatter.locale = Locale(identifier: "ko")
        timeLabel.text = formatter.string(from: Date())
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
    
        let vc = SelectLocationViewController()
        
        vc.modalPresentationStyle = .fullScreen
        
        vc.myLocation = myLocation
        
        vc.locationHandler = { coordinate in
            print(coordinate)
            if self.hiddenValue == false {
                self.allHidden(isHidden: self.hiddenValue)
            }
            //위치 버튼 이미지 채우기
            self.locationButton.image = UIImage(systemName: ImageSelection.fill)
            
            AddressAPIManager.shared.getLocationData(lat: coordinate.latitude, lon: coordinate.longitude) { value in
                self.locationLabel.text = "\(value.regionFirst), \(value.regionThird)"

                WeatherAPIManager.shared.getWeatherData(lat: coordinate.latitude, lon: coordinate.longitude) { value in
                    //첫번째 뷰
                    let imageURL = URL(string: Endpoint.imageURL + "\(value.iconId)@2x.png")
                    self.weatherImageView.kf.setImage(with: imageURL!)
                    self.currentTempLabel.text = value.temperatureText
                    self.maxMinTempLabel.text = value.maxMinText

                    //두번째 뷰
                    self.windLabel.text = value.windText

                    //세번째 뷰
                    self.humidityLabel.text = value.humidityText

                    //네번째 뷰
                    self.pressureLabel.text = value.pressureText

                    //다섯번째 뷰
                    self.messageLabel.text = WeatherModel.getMessage(weather: value.weather)

                    if self.hiddenValue {
                        self.allHidden(isHidden: self.hiddenValue)
                    }
                }
            }

        }
        
        present(vc, animated: true)
    }
    @IBAction func tapCurrentLocationButton(_ sender: UIButton) {
        
        locationManager.startUpdatingLocation()
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
        case .restricted, .denied:
            
            if hiddenValue == false {
                allHidden(isHidden: hiddenValue)
            }
            locationButton.image = UIImage(systemName: ImageSelection.empty)
            AddressAPIManager.shared.getLocationData(lat: lat, lon: lon) { value in
                self.locationLabel.text = "\(value.regionFirst)"
                
                WeatherAPIManager.shared.getWeatherData(lat: self.lat, lon: self.lon) { value in
                    //첫번째 뷰
                    let imageURL = URL(string: Endpoint.imageURL + "\(value.iconId)@2x.png")
                    self.weatherImageView.kf.setImage(with: imageURL!)
                    self.currentTempLabel.text = value.temperatureText
                    self.maxMinTempLabel.text = value.maxMinText
                    
                    //두번째 뷰
                    self.windLabel.text = value.windText
                    
                    //세번째 뷰
                    self.humidityLabel.text = value.humidityText
                    
                    //네번째 뷰
                    self.pressureLabel.text = value.pressureText
                    
                    //다섯번째 뷰
                    self.messageLabel.text = WeatherModel.getMessage(weather: value.weather)

                    if self.hiddenValue {
                        self.allHidden(isHidden: self.hiddenValue)
                    }
                }
            }
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
            
            myLocation = CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
            
            if hiddenValue == false {
                allHidden(isHidden: hiddenValue)
            }
            //위치 버튼 이미지 채우기
            self.locationButton.image = UIImage(systemName: ImageSelection.fill)
            
            AddressAPIManager.shared.getLocationData(lat: lat, lon: lon) { value in
                self.locationLabel.text = "\(value.regionFirst), \(value.regionThird)"

                WeatherAPIManager.shared.getWeatherData(lat: self.lat, lon: self.lon) { value in
                    //첫번째 뷰
                    let imageURL = URL(string: Endpoint.imageURL + "\(value.iconId)@2x.png")
                    self.weatherImageView.kf.setImage(with: imageURL!)
                    self.currentTempLabel.text = value.temperatureText
                    self.maxMinTempLabel.text = value.maxMinText

                    //두번째 뷰
                    self.windLabel.text = value.windText

                    //세번째 뷰
                    self.humidityLabel.text = value.humidityText

                    //네번째 뷰
                    self.pressureLabel.text = value.pressureText

                    //다섯번째 뷰
                    self.messageLabel.text = WeatherModel.getMessage(weather: value.weather)

                    if self.hiddenValue {
                        self.allHidden(isHidden: self.hiddenValue)
                    }
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
