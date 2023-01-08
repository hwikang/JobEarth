//
//  SearchTextView.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/08.
//

import UIKit
final class SearchTextView: UIView {
    
    @IBOutlet weak var textField: UITextField!
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
    }
    
    private func customInit() {
       if let view = Bundle.main.loadNibNamed("SearchTextView", owner: self, options: nil)?.first as? UIView {
           addSubview(view)
           view.translatesAutoresizingMaskIntoConstraints = false
           NSLayoutConstraint.activate([
               view.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0),
               view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0.0),
               view.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0.0),
               view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0.0),
               ])
       }
        
        setUI()
    }
    
    private func setUI() {
    
        let image = UIImageView(image: UIImage(named: "img_logo_search"))
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: textField.frame.height))
        view.addSubview(image)
        textField.leftView = view
        textField.leftViewMode = .always
        textField.placeholder = "기업, 채용공고 검색"
        
    }
    

}
