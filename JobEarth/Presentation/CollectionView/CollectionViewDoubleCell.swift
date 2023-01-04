//
//  CollectionViewDoubleCell.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/04.
//

import Foundation
import UIKit
class CollectionViewDoubleCell: UICollectionViewCell {
    static let id = "CollectionViewDoubleCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    func customInit() {
       if let view = Bundle.main.loadNibNamed("CollectionViewDoubleCell", owner: self, options: nil)?.first as? UICollectionViewCell {
           view.frame = self.bounds
           addSubview(view)
       }
    }
}
