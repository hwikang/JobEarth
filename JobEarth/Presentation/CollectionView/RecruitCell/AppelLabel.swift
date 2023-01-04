//
//  AppelLabel.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/04.
//

import Foundation
import UIKit

final class AppealLabel: UILabel {
    
//    init() {
//        super.init(frame: .zero)
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        comminInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        comminInit()
    }
    
    private func comminInit() {
        self.layer.cornerRadius = 4
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.init(hexString: "#E5E6E9").cgColor

        textColor = UIColor.init(hexString: "#686A6D")
        font = UIFont(name: "AppleSDGothicNeo-Regular", size: 11)
    }
}
