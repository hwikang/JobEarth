//
//  CategoryButton.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit

class CategoryButton: UIButton {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        setUnselectedUI()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.cornerRadius = 15
        
    }

    func setSelectedUI() {
        self.backgroundColor = UIColor.init(hexString: "#00C362")
        tintColor = .white
        self.layer.borderWidth = 0
        if let font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15) {
            self.titleLabel?.font = font
        }
    }
    
    func setUnselectedUI() {

        self.backgroundColor = .white
        tintColor = .black
        if let font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15) {
            self.titleLabel?.font = font
        }
        self.layer.borderWidth = 1
    }
    
}

