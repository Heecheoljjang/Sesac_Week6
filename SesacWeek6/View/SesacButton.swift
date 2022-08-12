//
//  SesacButton.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/09.
//

import UIKit

/*
 swift attribute -> 얘도 속성이므로 프로퍼티는 속성이라고 부르지않음.
 @IBInspectable, @IBDesignable, @objc, @escaping
 */


//인터페이스 빌더 컴파일 시점 실시간으로 객체 속성 확인할 수있음
@IBDesignable class SesacButton: UIButton {

    //인터페이스 빌더 인스펙터 영역에 show
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor!)
        }
        set {
            layer.borderColor = newValue.cgColor
        }
    }
}
