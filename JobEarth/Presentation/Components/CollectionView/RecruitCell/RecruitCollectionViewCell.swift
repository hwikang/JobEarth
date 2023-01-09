//
//  CollectionViewDoubleCell.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/04.
//

import Foundation
import UIKit
import Kingfisher

class RecruitCollectionViewCell: UICollectionViewCell {
    static let id = "RecruitCollectionViewCell"
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var ratingPoint: UILabel!
    @IBOutlet weak var ratingType: UILabel!
    
    @IBOutlet weak var appealStackView: UIStackView!
    @IBOutlet weak var reward: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configCell(item: RecruitItem) {
        mainImage.layer.cornerRadius = 8
        mainImage.kf.indicatorType = .activity
        mainImage.contentMode = .scaleAspectFill
        
        let url = URL(string: item.imageUrl)
        mainImage.kf.setImage(with: url)
        title.text = item.title
        reward.text = getRewardString(reward: item.reward)
        if let bestRating = getBestRating(ratings: item.company.ratings) {
            ratingType.text = bestRating.type
            ratingPoint.text = "\(bestRating.rating)"
        }
        
        addAppalLabels(appeals: item.appeal)
        
    }
   
    private func getRewardString(reward: Int) -> String {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        if let formated = format.string(for: reward) {
            return "축하금 : \(formated) 원"
        }
        return ""
    }
    
    private func getBestRating(ratings: [Rating]) -> Rating? {
        let sorted = ratings.sorted { $0.rating > $1.rating }
        return sorted.first
    }
    
    // Appeal 내용 없으면 비노출, 내용이 Frame 벗어나면 비노출
    private func addAppalLabels(appeals: [String]) {
        var remainWidth = self.frame.width
        for i in 0..<appeals.count {
            if appeals[i].isEmpty { continue }
            let label = AppealLabel()
            label.text = " \(appeals[i]) "
            label.sizeToFit()

            if !ableToAddLabel(remainWidth: remainWidth, labelWidth: label.frame.width) {
                break
            }
            appealStackView.addArrangedSubview(label)

//            print("\(title.text) \(appeals[i]) \(label.frame.width) \(remainWidth)")
            remainWidth -= label.frame.width
        }

    }
    
    private func ableToAddLabel(remainWidth: CGFloat, labelWidth: CGFloat) -> Bool {
        if remainWidth >= labelWidth {return true}
        return false
        
    }
    
    override func prepareForReuse() {
        appealStackView.subviews.forEach { $0.removeFromSuperview() }
    }
}
