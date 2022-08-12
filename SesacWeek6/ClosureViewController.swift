//
//  ClosureViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {
    
    @IBOutlet weak var cardView: CardView!
    @IBOutlet weak var myView: UIView!
    
    //Frame Based
    var sampleButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(myView.translatesAutoresizingMaskIntoConstraints)

        /*
         오토리사이징은 오토레이아웃있기전에 있던 것.
         오토리사이징도 대략적으로 고정하는 등의 제약조건이 있음
         오토리사이징을 오토레이아웃 컨스트레인트처럼 설정해주는 기능이 내부적으로 구현되어있음.
         이 기능은 뷰가 코드인지, 인터페이스빌더 기반으로 짜여져있는지에 따라 다름
         디폴트가 true
         하지만 오토레이아웃을 지정해주면 오토리사이징을 안쓰겠다는 의미라서 false로 상태가 변경됨. -> 오토리사이징과 오토레이아웃이 충돌날수있어서
         
         그래서 코드기반 UI에서는 트루, 인터페이스빌더 기반 UI에서는 false
         
         근데 아웃렛을 연결하자마자는 true임 -> 오토레이아웃이 안잡혀있기때문
         */
        //뷰에 등장시키기위해 위치, 크기, 추가의 세가지작업 필요
        print(sampleButton.translatesAutoresizingMaskIntoConstraints)
        print(cardView.translatesAutoresizingMaskIntoConstraints)
        sampleButton.frame = CGRect(x: 100, y: 400, width: 100, height: 100)
        sampleButton.backgroundColor = .red
        view.addSubview(sampleButton)
        
        cardView.posterImageView.backgroundColor = .red
        cardView.likeButton.backgroundColor = .yellow
        cardView.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
    }
    
    @objc func likeButtonClicked() {
        print("버튼 클릭")
    }
    
    
    @IBAction func colorPickerButtonClicked(_ sender: UIButton) {
        showAlert(title: "컬러피커 띄울?", message: "오우오우", okTitle: "확인이야") {
            let picker = UIColorPickerViewController()
            self.present(picker, animated: true)
        }
        
    }
    @IBAction func backgroundColorChanged(_ sender: UIButton) {
        
        showAlert(title: "알림", message: "메세지", okTitle: "오케이") {
            self.view.backgroundColor = .orange
        }
    }
}

extension UIViewController {
    func showAlert(title: String, message: String, okTitle: String, okAction: @escaping() -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: okTitle, style: .default) { action in
            okAction()
        }
        
        alert.addAction(ok)
        alert.addAction(cancel)
        present(alert, animated: true)
    }
}
