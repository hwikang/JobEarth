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
    private let recruitTrigger = PublishRelay<Void>()
    private let companyTrigger = PublishRelay<Void>()
    
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section,Item>?
    private var cellTypes: [CellItemType] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        configCollectionView()
        bindViewModel()

    }
    
    private func configCollectionView() {
        collectionView.register(RecruitCollectionViewCell.self, forCellWithReuseIdentifier: RecruitCollectionViewCell.id)
        collectionView.register(CompanyCollectionViewCell.self, forCellWithReuseIdentifier: CompanyCollectionViewCell.id)

        setDatasource()
    }
    
   
    
    private func bindViewModel() {
        let input = ViewModel.Input(recruitTriger: recruitTrigger.asDriver(onErrorJustReturn: ()), cellTriger: companyTrigger.asDriver(onErrorJustReturn: ()))
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive{[unowned self] items in
                collectionView.setCollectionViewLayout(createRecruitLayout(), animated: true)

                let sectionItems = items.map { Item.recruit($0) }
                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
                snapshot.appendSections([Section.recruit])
                snapshot.appendItems(sectionItems, toSection: Section.recruit)
                self.dataSource?.apply(snapshot)
                

            }
            .disposed(by: disposeBag)
        output.error.drive { error in
            print("Error @@ \(error)")
        }.disposed(by: disposeBag)
        
        output.cellItems
            .drive{[unowned self] items in
                collectionView.setCollectionViewLayout(createCompanyLayout(), animated: true)

                var snapshot = NSDiffableDataSourceSnapshot<Section,Item>()
                
                items.forEach { item in
                    cellTypes.append(item.cellType)
                    switch item.cellType {
                    case .company:
                        if let name = item.name {
                            let sectionItem = Item.cellCompany(item)

                            snapshot.appendSections([Section.cellCompany(name)])

                            snapshot.appendItems([sectionItem], toSection: Section.cellCompany(name))
                        }
                    case .horizontalTheme:
                        print("Horizontal")
                    }
                }
                print("Apply")
                self.dataSource?.apply(snapshot)

            }
            .disposed(by: disposeBag)
        output.error.drive { error in
            print("Error @@ \(error)")
        }.disposed(by: disposeBag)
        
        
        
        bindView()

    }
    
    private func bindView() {
        selectCategoryView.getCategory().drive{ [weak self] type in
            switch type {
            case .recruit:
                self?.recruitTrigger.accept(())
            case .company:
                self?.companyTrigger.accept(())
            }
        }.disposed(by: disposeBag)
    }
    
    
}

extension ViewController {
   
    
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section,Item>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            print("Cell Provider \(itemIdentifier)")
            switch itemIdentifier {
            case .recruit(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.id, for: indexPath) as? RecruitCollectionViewCell
                cell?.configCell(item: item)
                return cell
            case .cellCompany(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.id, for: indexPath) as? CompanyCollectionViewCell
                cell?.configCell(item: item)
                return cell
            default:
                
                return UICollectionViewCell()

            }
            
        })
    }
    private func createCompanyLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20.0
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, env in
            print("Call sectionProvider \(cellTypes)")
            if !cellTypes.isEmpty {
                let cell = cellTypes[sectionIndex]
                switch cell {
                case .company:
                       let section = self.createCellCompanySection()
                       return section
                case .horizontalTheme:
                       let section = self.createCellCompanySection()
                       return section
                    
                }
            }
            return self.createCellCompanySection()
//
//
        },configuration: config)
    }
                                                   
   private func createCellCompanySection() -> NSCollectionLayoutSection {
       let hightDimension = NSCollectionLayoutDimension.estimated(400)
       let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: hightDimension)
       let item = NSCollectionLayoutItem(layoutSize: itemSize)
       let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: hightDimension)

       let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
       let section = NSCollectionLayoutSection(group: group)
       
       return section
   }
   
  
    private func createRecruitLayout() -> UICollectionViewCompositionalLayout {
       let config = UICollectionViewCompositionalLayoutConfiguration()
      
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, env in
          print("Call Section Provider \(sectionIndex)")
            let currentFrame = self.collectionView.frame
            let selectCategoryHeight = self.selectCategoryView.frame.height
            let moveRange = currentFrame.origin.y - selectCategoryHeight

            let section = self.createRecruitSection()
            section.visibleItemsInvalidationHandler = {   visibleItems, point, environment in
                if point.y > 5 {
                    UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseIn) {
                        self.collectionView.frame = CGRect(x: 0, y: moveRange, width: currentFrame.width, height: currentFrame.height)
                    }
                }else {
                    self.collectionView.frame = CGRect(x: 0, y: currentFrame.origin.y, width: currentFrame.width, height: currentFrame.height)

                }
            }
            return section
            
        }, configuration: config)
    }
    
    private func createRecruitSection() -> NSCollectionLayoutSection {
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
