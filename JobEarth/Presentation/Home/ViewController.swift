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
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
    private var selectCategoryHeader: SelectCategoryHeader? {
        didSet {
            bindView()
            bindViewModel()

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        configCollectionView()
        

    }
    
    private func configCollectionView() {
        collectionView.register(SelectCategoryHeader.self, forSupplementaryViewOfKind: SelectCategoryHeader.id, withReuseIdentifier: SelectCategoryHeader.id)
        collectionView.register(RecruitCollectionViewCell.self, forCellWithReuseIdentifier: RecruitCollectionViewCell.id)
        
        self.snapshot.appendSections([Section(id:"Double")])
        collectionView.setCollectionViewLayout(createLayout(), animated: true)
        
        setDatasource()
        dataSource?.apply(snapshot)
    }
    
    private func bindView() {
        selectCategoryHeader?.getCategory().drive { category in
            print(category)
        }.disposed(by: disposeBag)

        
    }
    
    private func bindViewModel() {
        guard let header = selectCategoryHeader else { return }
        let input = ViewModel.Input(triger: header.getCategory())
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive{[unowned self] items in
                let sectionItems = items.map { Item.double($0) }
                self.snapshot.appendItems(sectionItems, toSection: Section(id: "Double"))
                self.dataSource?.apply(self.snapshot)
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
        return UICollectionViewCompositionalLayout(sectionProvider: { [weak self] sectionIndex, env in
            switch sectionIndex {
            case 0:
                let section = self?.createDoubleSection()
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(62))

                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: SelectCategoryHeader.id, alignment: .topLeading)
                section?.boundarySupplementaryItems = [header]
                return section
            default:
                return self?.createDoubleSection()

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
        dataSource?.supplementaryViewProvider = {[weak self] ( collectionView, kind, indexPath) -> UICollectionReusableView? in
            print("supplementaryViewProvider")
            if indexPath.section != 0 { return nil }
            self?.selectCategoryHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SelectCategoryHeader.id, for: indexPath) as? SelectCategoryHeader
            
            return self?.selectCategoryHeader
            
        }
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



struct Section: Hashable {
    let id : String
}

enum Item: Hashable {
    case double(RecruitItem)
    case big
    case carousel
}



