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
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section,Item>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        configCollectionView()
        
        bindViewModel()
    }
    
    private func configCollectionView() {
        collectionView.register(RecruitCollectionViewCell.self, forCellWithReuseIdentifier: RecruitCollectionViewCell.id)
        
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        setDatasource()
    }
    
    private func bindView() {
    }
    
    
    
    private func bindViewModel() {
        let input = ViewModel.Input(triger: selectCategoryView.getCategory())
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive{[unowned self] items in
                let sectionItems = items.map { Item.double($0) }
                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
                snapshot.appendSections([Section.recruit])
                snapshot.appendItems(sectionItems, toSection: Section.recruit)
                self.dataSource?.apply(snapshot)
            }
            .disposed(by: disposeBag)
        output.error.drive { error in
            print("Error @@ \(error)")
        }.disposed(by: disposeBag)
        
    }

}

extension ViewController {
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
       let config = UICollectionViewCompositionalLayoutConfiguration()
      
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, env in
          
            let currentFrame = self.collectionView.frame
            let selectCategoryHeight = self.selectCategoryView.frame.height
            let moveRange = currentFrame.origin.y - selectCategoryHeight

            switch sectionIndex {
            case 0:
                let section = self.createDoubleSection()
                section.visibleItemsInvalidationHandler = {   visibleItems, point, environment in
                    if point.y > 5 {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                            self.collectionView.frame = CGRect(x: 0, y: moveRange, width: currentFrame.width, height: currentFrame.height)
                        }
                    }else {
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                            self.collectionView.frame = CGRect(x: 0, y: currentFrame.origin.y, width: currentFrame.width, height: currentFrame.height)

                        }

                    }
                }
                return section
            default:
                return self.createDoubleSection()

            }
        }, configuration: config)
    }
    
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            switch itemIdentifier {
            case .double(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.id, for: indexPath) as? RecruitCollectionViewCell
                cell?.configCell(item: item)
                return cell
            default:
                
                return UICollectionViewCell()

            }
            
        })
    }
    
    private func createDoubleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.426), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(246))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(15)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)
        return section
        
    }
    
   
    
    
}
