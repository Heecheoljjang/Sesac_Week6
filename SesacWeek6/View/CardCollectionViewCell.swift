//
//  CardCollectionViewCell.swift
//  SesacWeek6
//
//  Created by HeecheolYoon on 2022/08/09.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cardVIew: CardView!
    
    //변경되지 않는 UI
    override func awakeFromNib() {
        super.awakeFromNib()
        
        print("CardCollectionViewCell", #function)
        setUpUI()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        cardVIew.contentLabel.text = "A"
        
    }
    
    func setUpUI() {
        cardVIew.backgroundColor = .clear
        cardVIew.posterImageView.backgroundColor = .lightGray
        cardVIew.posterImageView.layer.cornerRadius = 10
        cardVIew.likeButton.tintColor = .systemPink
        
    }

}
