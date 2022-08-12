//
//  CardView.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/09.
//

import UIKit

/*
Xml Interface Builder
 셀파일 제외한 나머지는 안되게 규정을 해두었음.
 그럼에도 불구하고 기능을 활용해서 사용할 수 있음.
 권장하진않지만 재사용성때문에 사용
 */

/*
 1. UIView Custom Class => 여러가지 뷰를 하나의 파일에서 작성 가능
 2. File's owner => 이 방법이 자유도가 좀 더 넢음. 하나의 파일에서 여러 뷰 사용을 하는데엔 제약이 있음
 */

/*
 View: 인터페이스 빌더 UI 초기화 구문 <-> 코드 UI 초기화 구문
 서로 다름
 인터페이스 빌더 UI 초기화 구문은 required init임
    - 프로토콜 초기화 구문: required > 초기화 구문이 프로토콜로 명세되어있음
    -> 즉, required붙어있으면 프로토콜에서 온거
 코드는 override init
 */

class CardView: UIView {


    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var contentLabel: UILabel!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
        
        let view = UINib(nibName: "CardView", bundle: nil).instantiate(withOwner: self).first as! UIView
        view.frame = bounds
        view.backgroundColor = .clear
        self.addSubview(view)
        //카드뷰를 인터페이스 빌더 기반으로 만들고, 레이아웃도 설정했는데 false가 나와야되는데 true가나옴
        //초기화구문에서 let을 통해서 뷰를 설정하는 것 자체가 코드로 설정해주는거임(addsubview)
        //인터페이스 기반으로 레이아웃을 잡아도 내부적으로 코드로 추가한것.
        //그래서 true로나오는건데, 오토레이아웃이 적용이 되는 관점보다 오토리사이징이 내부적으로 constraints처리가 된거임.
        print(view.translatesAutoresizingMaskIntoConstraints)
    }
    
}
