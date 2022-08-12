//
//  MainViewController.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/09.
//

import UIKit

import Kingfisher

/*
 awakeFornib - 셀 UI 초기화, 재사용 매커니즘에 의해 일정 횟수 이상 호출되지 않음.
 cellforitemat
 - 재사용 될때마다, 사용자에게 보일 때마다 항상 실행
 - 화면과 데이터는 별개, 모든 indexpath.item에 대한 조건이 없다면 재사용 시 오류가 발생할 수 있ㅇ므.
 prepareforreuse
 - 셀이 재사용될때 초기화하고자 하는 값을 넣으면 오류를 해결할 수 있음. 즉, cellforrowat에서 모든 indexpath.item에 대한 조건을 작성하지않아도됨.
 Collectionview in Tableview
 - 하나의 컬렉션뷰나 테이블뷰라면 문제가 없음
 - 복합적인 구조라면, 테이블뷰도 재사용되어야하고 컬렉션셀도 재사용이 되어야함
 */

class MainViewController: UIViewController {

    //컬렉션뷰도 delegate datasource필요 => 메인뷰컨트롤러가 위임
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    let color: [UIColor] = [.red, .systemPink, .purple, .systemTeal, .yellow]
    
    let numberList: [[Int]] = [
        [Int](100...110),
        [Int](10...30),
        [Int](200...300),
        [Int](400...500),
        [Int](1000...1200),
        [Int](2000...3000),
        [Int](4000...5000)

    ]
    
    var episodeList: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        TMDBAPIManager.shared.requestImage { value in
            //dump(value)
            //1. 네트워크 통신 2. 배열 생성 3. 배열 담기 4. 뷰 등에 표현 5. 뷰 갱신
            self.episodeList = value
            self.tableView.reloadData()
        }
        
        bannerCollectionView.delegate = self
        bannerCollectionView.dataSource = self
        bannerCollectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        bannerCollectionView.collectionViewLayout = collectionViewLayout()
        bannerCollectionView.isPagingEnabled = true // 셀 크기만큼이 아니라 디바이스 너비만큼 움직이는거라 셀의 너비가 디바이스의 너비랑 같을때만 잘 되는 것처럼 보임
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }

}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //섹션이 하나기때문에 컬렉션뷰별로 설정해준 태그이용
        return collectionView == bannerCollectionView ? color.count : episodeList[collectionView.tag].count
    }
    
    //여기선 내부매개변수에 두 가지 컬렉션뷰가 들어올 수가 있음.
    //내부 매개변수가 아닌 명확한 아웃렛을 사용할 경우, 셀이 재사용되면 특정 컬렉션뷰 셀을 재사용하게 될 수도 있음.
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as? CardCollectionViewCell else { return UICollectionViewCell() }
        print("MainViewConttoller", #function, indexPath)
        
        if collectionView == bannerCollectionView {
            cell.cardVIew.posterImageView.backgroundColor = color[indexPath.item]
        } else {
            
//            if indexPath.item < 2 {
//                cell.cardVIew.contentLabel.text = "\(numberList[collectionView.tag][indexPath.item])"
//            }
//            else {
//                cell.cardVIew.contentLabel.text = "dfasd"
//
//            }
            let url = URL(string: "\(TMDBAPIManager.shared.imageURL)\(episodeList[collectionView.tag][indexPath.item])")
            cell.cardVIew.posterImageView.kf.setImage(with: url)
            cell.cardVIew.contentLabel.text = ""
            cell.cardVIew.posterImageView.contentMode = .scaleAspectFill
        }

        
        
        return cell
    }
    
    func collectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: bannerCollectionView.frame.height)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return layout
        
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return episodeList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    // 내부 매개변수 tableView를 통해 테이블뷰를 특정
    //테이블뷰 객체가 하나일 경우에는 내부 매개변수를 활용하지않아도 문제가 생기지않는디ㅏ.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath) as? MainTableViewCell else { return UITableViewCell()}
        
        print("MainViewController", #function, indexPath)
        
        cell.backgroundColor = .yellow
        cell.titleLabel.text = TMDBAPIManager.shared.tvList[indexPath.section].0
        cell.collectionView.backgroundColor = .green
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section // 셀이 한개이므로 섹션으로 구분지음
        cell.collectionView.register(UINib(nibName: "CardCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CardCollectionViewCell")
        
        cell.collectionView.reloadData() // index오류 해결
        // 위의 코드가 없어도 셀이 재사용되지않을정도록 셀이 적다면 오류 없음.
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 240
    }
}
