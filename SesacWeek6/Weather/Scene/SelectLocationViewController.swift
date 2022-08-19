//
//  SelectLocationViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/19.
//

import UIKit
import SnapKit
import MapKit
import CoreLocation

class SelectLocationViewController: UIViewController {

    let mapView = MKMapView()
    
    let saveButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "날씨 알아보기"
        configuration.baseForegroundColor = .white
        configuration.baseBackgroundColor = .systemTeal
        configuration.cornerStyle = .large
        
        button.configuration = configuration
        return button
    }()
    
    var myLocation: CLLocationCoordinate2D?
    
    var locationHandler: ((CLLocationCoordinate2D) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white

        addViews()
        
        setUpLayout()
        
        mapView.delegate = self
        
        if let myLocation = myLocation {
            setRegionAndAnnotation(center: myLocation)
        }
        
        saveButton.addTarget(self, action: #selector(sendLocationData), for: .touchUpInside)
        
    }
    
    @objc func sendLocationData() {
        if let myLocation = myLocation {
            locationHandler?(myLocation)
            dismiss(animated: true)
        }
    }
    
    func addViews() {
        [mapView, saveButton].forEach {
            view.addSubview($0)
        }
    }
    
    func setUpLayout() {
        mapView.snp.makeConstraints { make in
            make.trailing.leading.equalTo(view)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.frame.size.height * 0.7)
        }
        
        saveButton.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(60)
            make.bottom.equalTo(mapView.snp.top).offset(-60)
            make.width.equalTo(view.frame.size.width / 3)
        }
    }
    
    func setRegionAndAnnotation(center: CLLocationCoordinate2D) {
        
        //지도 중심 기반으로 보여질 범위 설정(최초로 보여지는 맵인 것 같음)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)

        //어노테이션추가(하나도 가능하고 여러 개도 가능함)
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "현재 위치"

        mapView.addAnnotation(annotation)
    }
    
}

extension SelectLocationViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        print(mapView.centerCoordinate)
        //데이터 전달
        myLocation = mapView.centerCoordinate
        
        //어노테이션
        mapView.removeAnnotations(mapView.annotations)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        annotation.title = "현재 위치"

        mapView.addAnnotation(annotation)
    }

}
