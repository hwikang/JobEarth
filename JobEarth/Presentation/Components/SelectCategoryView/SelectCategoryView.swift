//
//  SelectCategoryView.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/05.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa

class SelectCategoryView: UIView {

    private let disposeBag = DisposeBag()
    private let category = BehaviorRelay<CategoryType>(value: .recruit)
    @IBOutlet weak var recruitButton: CategoryButton!
    @IBOutlet weak var companyButton: CategoryButton!
    public var currentCategory: CategoryType?
    override init(frame: CGRect) {
        super.init(frame: frame)
        customInit()
        bindView()
    }
    
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
        
    func getCategory() -> Driver<CategoryType> {
        return category.asDriver()
    }
    
    private func getCurrentCategory() -> CategoryType {
        return category.value
    }
    
    private func bindView() {
        recruitButton.rx.tap.bind {[weak self]  in
            if self?.getCurrentCategory() == .recruit { return }
            self?.category.accept(.recruit)
        }.disposed(by: disposeBag)
        
        companyButton.rx.tap.bind {[weak self]  in
            if self?.getCurrentCategory() == .company { return }

            self?.category.accept(.company)
        }.disposed(by: disposeBag)
        
        category.asDriver().drive {[weak self]  category in
            self?.currentCategory = category
            switch category {
            case .recruit:
                self?.recruitButton.setSelectedUI()
                self?.companyButton.setUnselectedUI()

            case .company:
                self?.recruitButton.setUnselectedUI()
                self?.companyButton.setSelectedUI()

            }
        }.disposed(by: disposeBag)
        
    }
}
