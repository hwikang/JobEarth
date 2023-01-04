//
//  SelectCategoryHeader.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/04.
//

import UIKit
import RxSwift
import RxRelay
import RxCocoa


class SelectCategoryHeader: UICollectionReusableView {
    static let id = "SelectCategoryHeader"
    private let disposeBag = DisposeBag()
    private let category = BehaviorRelay<CategoryType>(value: .recruit)
    @IBOutlet weak var recruitButton: CategoryButton!
    @IBOutlet weak var companyButton: CategoryButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("Init header")
        customInit()
        bindView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        customInit()
        bindView()
    }
    
    func customInit() {
       if let view = Bundle.main.loadNibNamed("SelectCategoryHeader", owner: self, options: nil)?.first as? UIView {
           view.frame = self.bounds
           addSubview(view)
       }
    }
        
    func getCategory() -> Driver<CategoryType> {
        return category.asDriver()
    }
    
    
    private func bindView() {
        recruitButton.rx.tap.bind {[weak self]  in
            self?.category.accept(.recruit)
        }.disposed(by: disposeBag)
        
        companyButton.rx.tap.bind {[weak self]  in
            self?.category.accept(.company)
        }.disposed(by: disposeBag)
        
        category.asDriver().drive {[weak self]  category in
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
