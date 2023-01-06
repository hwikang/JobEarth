//
//  TestCell.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/06.
//

import Foundation
import UIKit

class TestCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    static let id = "TestCell"
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
    
    func config(title:String) {
        label.text = title
    }
}
