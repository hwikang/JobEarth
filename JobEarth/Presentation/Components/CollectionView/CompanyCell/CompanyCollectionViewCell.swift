//
//  CompanyCollectionViewCell.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/06.
//

import Foundation
import UIKit
import Kingfisher

class CompanyCollectionViewCell: UICollectionViewCell {
    static let id = "CompanyCollectionViewCell"
    
    @IBOutlet weak var logoImage: UIImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var rateAvg: UILabel!
    @IBOutlet weak var industry: UILabel!
    @IBOutlet weak var updateDate: UILabel!
    @IBOutlet weak var review: UILabel!
    @IBOutlet weak var salartAvg: UILabel!
    @IBOutlet weak var interviewQuestion: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
        if let view = Bundle.main.loadNibNamed("CompanyCollectionViewCell", owner: self, options: nil)?.first as? UICollectionViewCell {
           view.frame = self.bounds
           addSubview(view)
        }
        setUI()
    }
    
    private func setUI() {
       
    }
    
    
    
    func configCell(item: CellItem) {
        if let logoPath = item.logoPath {
            let url = URL(string: logoPath)
            logoImage.kf.setImage(with: url)

        }
        companyName.text = item.name
        if let rateTotalAvg = item.rateTotalAvg {
            rateAvg.text = "\(round((rateTotalAvg * 10)) / 10)"
        }
     
        industry.text = item.industryName
        review.text = item.reviewSummary
        if let salaryAvg = item.salaryAvg {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            salartAvg.text =  format.string(for: salaryAvg)
           
        }
        interviewQuestion.text = item.interviewQuestion
        
        review.sizeToFit()
        interviewQuestion.sizeToFit()
        
        
    }
    
}
