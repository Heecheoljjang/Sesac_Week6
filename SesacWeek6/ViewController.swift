//
//  ViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/08.
//

import UIKit

//import Alamofire
import SwiftyJSON

/*
 1. html tag <> </> 기능 활용
 2. 문자열 대체 메서드
 */

/*
 TableView automaticDimension
 조건
 -> numberoflines가 0이어야함
 -> 테이블뷰의 높이를 automaticdimension으로 설정
 -> 레이아웃을 잘 잡아야함
 */

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var blogList: [String] = []
    private var cafeList: [String] = []
    
    private var isExpanded = false // false면 2줄, true면 0
    
    var user = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        
        searchBlog()
                

    }
    private func searchBlog() {
        KakaoAPIManager.shared.callRequest(type: .blog, query: "희철") { json in
            print(json)
            
            self.blogList = json["documents"].arrayValue.map { String(htmlEncodedString: $0["contents"].stringValue)! }
            
            self.searchCafe()
        }
    }
    
    private func searchCafe() {
        KakaoAPIManager.shared.callRequest(type: .cafe, query: "희철") { json in
            print(json)
            
            self.cafeList = json["documents"].arrayValue.map { String(htmlEncodedString: $0["contents"].stringValue)! }

            self.tableView.reloadData()
        }
    }
    @IBAction func expandCell(_ sender: UIBarButtonItem) {
        
        isExpanded = !isExpanded
        tableView.reloadData()
        
    }
    
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return section == 0 ? blogList.count : cafeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "KakaoCell", for: indexPath) as? KakaoCell else { return UITableViewCell() }
        
        cell.testLabel.numberOfLines = isExpanded ? 0: 2
        cell.testLabel.text = indexPath.section == 0 ? blogList[indexPath.row] : cafeList[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "블로그 검색결과" : "카페 검색결과"
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? 100 : UITableView.automaticDimension
    }
}


class KakaoCell: UITableViewCell {
    @IBOutlet weak var testLabel: UILabel!
}
