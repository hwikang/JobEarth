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
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configCell(item: CellItem) {
        setLogoImage(item.logoPath)
        companyName.text = item.name
        setRateAvg(item.rateTotalAvg)
        industry.text = item.industryName
        review.text = item.reviewSummary
        setSalaryAvg(item.salaryAvg)
        interviewQuestion.text = item.interviewQuestion
        setUpdateDate(item.updateDate)
       
    }
    
    private func setLogoImage(_ path: String?) {
        if let logoPath = path {
            let url = URL(string: logoPath)
            logoImage.kf.setImage(with: url, placeholder: UIImage(named:"placeholder"))

        }
    }
    
    private func setRateAvg(_ avg: Float?) {
        if let rateTotalAvg = avg {
            rateAvg.text = "\(round((rateTotalAvg * 10)) / 10)"
        }
    }
    private func setSalaryAvg(_ avg: Int?) {
        if let salaryAvg = avg {
            let format = NumberFormatter()
            format.numberStyle = .decimal
            salartAvg.text =  format.string(for: salaryAvg)
           
        }
    }
    
    private func setUpdateDate(_ date: String?) {
        if let date = date {
            print(date)
            let splited = date.split(separator: "T")
            let replaced = splited[0].replacingOccurrences(of: "-", with: ".")

            print("replaced \(replaced)")
            updateDate.text = replaced
            
        }
    }
    
}
