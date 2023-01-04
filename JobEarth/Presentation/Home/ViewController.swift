//
//  ViewController.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/02.
//

import UIKit
import RxSwift
import RxCocoa
import Swinject

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let container: Container? = {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        return appDelegate?.container
    }()
    private var viewModel: ViewModel!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        bindView()
        bindViewModel()
    }
    
    private func bindView() {

        selectCategoryView.getCategory().drive { category in
            print(category)

        }

        
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 3000))
        view.backgroundColor = .red
        contentView.addSubview(view)
        
        
    }
    
    private func bindViewModel() {
        viewModel.getRecruits()
    }

}

