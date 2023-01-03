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
        self.backgroundColor = .green
        setTitleColor(.white, for: .normal)
        self.layer.borderWidth = 0

    }
    
    func setUnselectedUI() {
        self.backgroundColor = .white
        setTitleColor(.black, for: .normal)
        self.layer.borderWidth = 1
    }
    
}

