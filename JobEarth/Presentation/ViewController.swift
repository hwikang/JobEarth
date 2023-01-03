//
//  ViewController.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {

        selectCategoryView.getCategory().drive { category in
            print(category)

        }.disposed(by: disposeBag)

    }
    

}


class TestCollectionView: UICollectionView {
    
}

