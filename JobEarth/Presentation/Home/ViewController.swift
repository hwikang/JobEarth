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
    
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    var test: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        configCollectionView()
        bindViewModel()

    }
    
    private func configCollectionView() {
        collectionView.register(RecruitCollectionViewCell.self, forCellWithReuseIdentifier: RecruitCollectionViewCell.id)
        collectionView.register(CompanyCollectionViewCell.self, forCellWithReuseIdentifier: CompanyCollectionViewCell.id)
        collectionView.register(UINib(nibName:"HorizontalHeader", bundle: nil), forSupplementaryViewOfKind: "HorizontalHeader", withReuseIdentifier: HorizontalHeader.id)
        
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
                   
                    switch item.cellType {
                    case .company:
                        if let name = item.name {
                            cellTypes.append(item.cellType)

                            let sectionItem = Item.cellCompany(item)

                            snapshot.appendSections([Section.cellCompany(name)])

                            snapshot.appendItems([sectionItem], toSection: Section.cellCompany(name))
                        }
                    case .horizontalTheme:
                        if let title = item.sectionTitle, let recommendRecruit = item.recommendRecruit {
                            cellTypes.append(item.cellType)

                            let section = Section.cellHorizontal(title)
                            snapshot.appendSections([section])
                            let items = recommendRecruit.map { Item.cellHorizontal($0)}
                            snapshot.appendItems(items, toSection: section)

                        }
                    default:
                        print("None Type")
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
            switch itemIdentifier {
            case .recruit(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.id, for: indexPath) as? RecruitCollectionViewCell
                cell?.configCell(item: item)
                return cell
            case .cellCompany(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.id, for: indexPath) as? CompanyCollectionViewCell
                cell?.configCell(item: item)
                return cell
            case .cellHorizontal(let item):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.id, for: indexPath) as? RecruitCollectionViewCell
                cell?.configCell(item: item)
                return cell
            

            }
            
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] (collectionView, kind, indexPath) -> UICollectionReusableView in
            print("Heder provider \(kind)")
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HorizontalHeader.id, for: indexPath) as? HorizontalHeader else { fatalError()}
            
            let currentSectionData = self?.dataSource?.sectionIdentifier(for: indexPath.section)
            if case let .cellHorizontal(title) = currentSectionData {
                header.configure(title: title)
            }
            return header
        }
    }
    private func createCompanyLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 20.0
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, env in
            var section: NSCollectionLayoutSection = LayoutSectionManager.createCellCompanySection()
            if !cellTypes.isEmpty {
                let cell = cellTypes[sectionIndex]
                
                if cell == .horizontalTheme {
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: "HorizontalHeader", alignment: .topLeading)
                    header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 0)
                    section = LayoutSectionManager.createCellHorizontalSection()
                    section.boundarySupplementaryItems = [header]
                }
            }
            self.addScrollEventToSection(section: section)


            return section
        },configuration: config)
    }
                                                   
    private func createRecruitLayout() -> UICollectionViewCompositionalLayout {
       let config = UICollectionViewCompositionalLayoutConfiguration()
      
        
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, env in
           
            let section = LayoutSectionManager.createRecruitSection()
            self.addScrollEventToSection(section: section)
            return section
            
        }, configuration: config)
    }
    
    private func addScrollEventToSection(section: NSCollectionLayoutSection?) {
        let selectCategoryHeight = self.selectCategoryView.frame.height

        section?.visibleItemsInvalidationHandler = {[weak self]   visibleItems, point, environment in
            if point.y > 5 {
                self?.changeCollectionViewConstraint(offset: -selectCategoryHeight)

            }else {
                self?.changeCollectionViewConstraint(offset: 0)

            }
        }
    }
    
    private func changeCollectionViewConstraint(offset: CGFloat) {
        self.collectionTopConstraint.constant = offset
    }
    
}

