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
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }
    
    private func bindView() {

        selectCategoryView.getCategory().drive { category in
            print(category)

        }

        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 3000))
        view.backgroundColor = .red
        contentView.addSubview(view)
        
        
        let network = RecruitNetwork(network: Network<RecruitData>())
        network.getRecruit().bind { list in
            print(list)
        }
    }

}

