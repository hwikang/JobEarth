//
//  File.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/06.
//

import UIKit
class HorizontalHeader: UICollectionReusableView {
    static let id = "HorizontalHeader"
    @IBOutlet weak var sectionTitle: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(title:String){
        sectionTitle.text = title
      }
    
    
  
}
