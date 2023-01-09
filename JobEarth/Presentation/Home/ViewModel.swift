//
//  ViewModel.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/03.
//

import Foundation
import RxCocoa
import RxSwift

class ViewModel {
    private let recruitNetwork: RecruitNetworInterface
    private let cellNetwork: CellNetworkInterface
    private let disposebag = DisposeBag()
    private let errorMessage = PublishRelay<String>()
    init(recruitNetwork:RecruitNetworInterface, cellNetwork:CellNetworkInterface) {
        self.recruitNetwork = recruitNetwork
        self.cellNetwork = cellNetwork
        
    }
    
    struct Input {
        var recruitTriger: Driver<String>
        var cellTriger: Driver<String>

    }
    
    struct Output {
        var recruitItems: Driver<[RecruitItem]>
        var cellItems: Driver<[CellItem]>
        var error: Driver<String>
    }
    
    func transform(input:Input) ->Output {
        let recruitItems = input.recruitTriger.flatMapLatest { searchText -> Driver<[RecruitItem]>  in
            return self.getRecruits()
                .map({ items in
                    if searchText.isEmpty { return items }
                    let filtered =  items.filter { item in
                        return item.title.lowercased().contains(searchText.lowercased())
                   }
                    return filtered
                })
                .asDriver(onErrorJustReturn: [])
        }
        
        let cellItems = input.cellTriger.flatMapLatest {[unowned self] searchText -> Driver<[CellItem]>  in
            let searchText = searchText.lowercased()
            return self.getCells()
                .map({ items in
                    if searchText.isEmpty { return items }
                    let filtered = self.filterData(items: items, searchText: searchText)
                   
                    return filtered
                })
                .asDriver(onErrorJustReturn: [])
        }
        
        return Output(recruitItems: recruitItems, cellItems: cellItems, error: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    private func getRecruits() -> Observable<[RecruitItem]>{
        return recruitNetwork.getRecruit()
            .catch({[weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                return Observable.just(RecruitData(recruitItems: []))
            })
            .map { $0.recruitItems }
    }
    
    private func getCells() -> Observable<[CellItem]> {
        print("getCells")
        return cellNetwork.getCell()
            .catch({ [weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                return Observable.just(CellData(items: []))
            })
            .map{ $0.items }

    }
    
    private func filterData(items: [CellItem], searchText: String) -> [CellItem] {
        let filtered = items.compactMap { item -> CellItem? in
        switch item{
            case .company(let companyItem):
                 let name = companyItem.name.lowercased()
                if name.contains(searchText) {
                    return item
                }
                return nil
            case .horizontal(let horizontalItem):
                var temp = horizontalItem
                temp.filterRecommendRecruit(text: searchText)
                 let recommendRecruit = temp.recommendRecruit
                if recommendRecruit.isEmpty { return nil }
                let cellItem = CellItem.horizontal(temp)
                return cellItem
                
            default:
                return nil
            }
        }
        return filtered
    }
}
