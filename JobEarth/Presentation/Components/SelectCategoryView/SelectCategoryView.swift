//
//  SelectCategoryView.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

enum ListCategory {
    case hire
    case company
}

class SelectCategoryView: UIView {
    private let disposeBag = DisposeBag()
    private let category = BehaviorRelay<ListCategory>(value: .hire)
    @IBOutlet weak var hireButton: CategoryButton!
    @IBOutlet weak var companyButton: CategoryButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        bindView()
    }
    
    func customInit() {
       if let view = Bundle.main.loadNibNamed("SelectCategoryView", owner: self, options: nil)?.first as? UIView {
           view.frame = self.bounds
           addSubview(view)
       }
    }
        
    func getCategory() -> Driver<ListCategory> {
        return category.asDriver()
    }
    
    
    private func bindView() {
        hireButton.rx.tap.bind {[weak self]  in
            self?.category.accept(.hire)
        }.disposed(by: disposeBag)
        
        companyButton.rx.tap.bind {[weak self]  in
            self?.category.accept(.company)
        }.disposed(by: disposeBag)
        
        category.asDriver().drive {[weak self]  category in
            switch category {
            case .hire:
                self?.hireButton.setSelectedUI()
                self?.companyButton.setUnselectedUI()

            case .company:
                self?.hireButton.setUnselectedUI()
                self?.companyButton.setSelectedUI()

            }
        }.disposed(by: disposeBag)
        
    }
}
