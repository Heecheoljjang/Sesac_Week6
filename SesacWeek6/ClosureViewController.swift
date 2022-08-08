//
//  ClosureViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/08.
//

import UIKit

class ClosureViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
