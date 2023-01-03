//
//  SearchTextField.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit

class SearchTextField: UITextField {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setUI()
    }
    
    private func setUI() {
        self.backgroundColor = .red
        let image = UIImage(named: "img_logo_search")
        self.leftView = UIImageView(image: image)
        leftViewMode = .always
    }
}
