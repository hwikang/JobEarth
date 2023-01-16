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
    private let recruitTrigger = PublishRelay<String>()
    private let companyTrigger = PublishRelay<String>()
    
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var searchTextView: SearchTextView!
    @IBOutlet weak var selectCategoryView: SelectCategoryView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>?
    private var snapshot: NSDiffableDataSourceSnapshot<Section, Item>?
//    private var cellTypes: [CellItem.CellType] = []
    
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    var test: NSLayoutConstraint?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = self.container?.resolve(ViewModel.self)
        configCollectionView()
        bindViewModel()

    }
    
    private func configCollectionView() {
        collectionView.register(UINib(nibName: "RecruitCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: RecruitCollectionViewCell.id)
        collectionView.register(UINib(nibName: "CompanyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: CompanyCollectionViewCell.id)
        collectionView.register(UINib(nibName: "HorizontalHeader", bundle: nil), forSupplementaryViewOfKind: HorizontalHeader.id, withReuseIdentifier: HorizontalHeader.id)
        
        setDatasource()
    }
    
    private func bindViewModel() {
        let input = ViewModel.Input(recruitTriger: recruitTrigger.asDriver(onErrorJustReturn: ("")), cellTriger: companyTrigger.asDriver(onErrorJustReturn: ("")))
        let output = viewModel.transform(input: input)
        
        output.recruitItems
            .drive {[unowned self] items in
                self.emptyView.isHidden = items.isEmpty ? false : true
                collectionView.setCollectionViewLayout(createRecruitLayout(), animated: true)
                let snapshot = createRecruitItemSnapshot(items: items)
                self.dataSource?.apply(snapshot)
            }
            .disposed(by: disposeBag)
        output.error.drive { error in
            print("Error @@ \(error)")
        }.disposed(by: disposeBag)
        
        output.cellItems
            .drive {[unowned self] items in
                self.emptyView.isHidden = items.isEmpty ? false : true
                collectionView.setCollectionViewLayout(createCompanyLayout(), animated: true)
                let snapshot = createCellItemSnapshot(items: items)
                self.dataSource?.apply(snapshot)
                scrollToTop()
            }
            .disposed(by: disposeBag)
        output.error.drive { error in
            print("Error @@ \(error)")
        }.disposed(by: disposeBag)
        
        bindView()

    }

    private func createRecruitItemSnapshot(items: [RecruitItem]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        let sectionItems = items.map { Item.recruit($0) }
        snapshot.appendSections([Section.recruit])
        snapshot.appendItems(sectionItems, toSection: Section.recruit)
        return snapshot
    }
    
    private func createCellItemSnapshot(items: [CellItem]) -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        items.forEach { item in
            switch item {
            case .company(let companyItem):
                let sectionItem = Item.cellCompany(companyItem)
                snapshot.appendSections([Section.cellCompany(companyItem.name)])
                snapshot.appendItems([sectionItem], toSection: Section.cellCompany(companyItem.name))
            case .horizontal(let horizontalItem):
                 let title = horizontalItem.sectionTitle
                let recommendRecruit = horizontalItem.recommendRecruit
                let section = Section.cellHorizontal(title)
                snapshot.appendSections([section])
                let items = recommendRecruit.map { Item.cellHorizontal($0)}
                snapshot.appendItems(items, toSection: section)
            default:
               print("None Type")
           }
            
        }
        return snapshot
    }
    
    private func scrollToTop() {
        collectionView.contentOffset.y = 0
        changeCollectionViewConstraint(offset: 0)
    }
    
    private func bindView() {
        selectCategoryView.getCategory().drive { [weak self] type in
            let searchText = self?.searchTextView.textField.text ?? ""
            switch type {
            case .recruit:
                self?.recruitTrigger.accept(searchText)
            case .company:
                self?.companyTrigger.accept(searchText)
            }
        }.disposed(by: disposeBag)
    
        searchTextView.textField.rx.text.bind {[weak self] text in
            guard let category = self?.selectCategoryView.currentCategory, let searchText = text else { return }
            
            switch category {
            case .recruit:
                self?.recruitTrigger.accept(searchText)

            case .company:
                self?.companyTrigger.accept(searchText)

            }
        }.disposed(by: disposeBag)

    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    private func setDatasource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: collectionView, cellProvider: {[weak self] collectionView, indexPath, itemIdentifier -> UICollectionViewCell? in
            switch itemIdentifier {
            case .recruit(let item), .cellHorizontal(let item):
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecruitCollectionViewCell.id, for: indexPath) as? RecruitCollectionViewCell {
                    cell.configCell(item: item)
                    self?.addTapEventToRecruitCell(cell: cell, item: item)
                    return cell
                }
                
            case .cellCompany(let companyItem):
               
                if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompanyCollectionViewCell.id, for: indexPath) as? CompanyCollectionViewCell {
                    cell.configCell(item: companyItem)
                    self?.addTapEventToCompanyCell(cell: cell, item: companyItem)
                    return cell
                }
               
            }
            return UICollectionViewCell()
        })
        
        dataSource?.supplementaryViewProvider = {[weak self] (collectionView, kind, indexPath) -> UICollectionReusableView in
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
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] sectionIndex, _ in
            var section: NSCollectionLayoutSection = LayoutSectionManager.createCellCompanySection()
            if let sectionType = dataSource?.sectionIdentifier(for: sectionIndex) {
                if case Section.cellHorizontal(_) = sectionType {
                    let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50))
                    let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: HorizontalHeader.id, alignment: .topLeading)
                    header.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
                    section = LayoutSectionManager.createCellHorizontalSection()
                    section.boundarySupplementaryItems = [header]
                }

            }
           
            self.addScrollEventToSection(section: section)

            return section
        }, configuration: config)
    }
                                                   
    private func createRecruitLayout() -> UICollectionViewCompositionalLayout {
       let config = UICollectionViewCompositionalLayoutConfiguration()
      
        return UICollectionViewCompositionalLayout(sectionProvider: { [unowned self] _, _ in
           
            let section = LayoutSectionManager.createRecruitSection()
            self.addScrollEventToSection(section: section)
        
            return section
            
        }, configuration: config)
    }
    
    private func addScrollEventToSection(section: NSCollectionLayoutSection?) {
        let selectCategoryHeight = self.selectCategoryView.frame.height

        section?.visibleItemsInvalidationHandler = {[unowned self]   _, point, _ in
            if !self.checkContentSizeBiggerThanDevice() { return }
            if point.y > 1 {
                self.changeCollectionViewConstraint(offset: -selectCategoryHeight)
            } else {
                self.changeCollectionViewConstraint(offset: 0)

            }
        }
    }
    
    private func checkContentSizeBiggerThanDevice() -> Bool {
        let deviceHeight = self.view.safeAreaLayoutGuide.layoutFrame.height
        return collectionView.contentSize.height > deviceHeight - searchTextView.frame.height
    }
    
    private func changeCollectionViewConstraint(offset: CGFloat) {
        if self.collectionTopConstraint.constant == offset { return }
        self.collectionTopConstraint.constant = offset
    }
    
    private func addTapEventToRecruitCell(cell: RecruitCollectionViewCell, item: RecruitItem) {
        cell.gestureRecognizers?.removeAll()
        let tapGesture = UITapGestureRecognizer()
        cell.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind {[weak self] _ in
            let vc = DetailViewController.initiate(title: item.title, imageUrl: item.imageUrl)
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    private func addTapEventToCompanyCell(cell: CompanyCollectionViewCell, item: CellItem.Company) {
        cell.gestureRecognizers?.removeAll()
        let tapGesture = UITapGestureRecognizer()
        cell.addGestureRecognizer(tapGesture)

        tapGesture.rx.event.bind {[weak self] _ in
            let vc = DetailViewController.initiate(title: item.name, imageUrl: item.logoPath)
            self?.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
    }
    
}
