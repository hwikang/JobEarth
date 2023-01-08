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
        
        
//        getCells()
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
        
        let cellItems = input.cellTriger.flatMapLatest { searchText -> Driver<[CellItem]>  in
            let searchText = searchText.lowercased()
            return self.getCells()
                .map({ items in
                    if searchText.isEmpty { return items }

                    let filtered = items.compactMap { item -> CellItem? in
                    switch item.cellType{
                        case .company:
                            guard let name = item.name?.lowercased() else {return nil}
                            if name.contains(searchText) {
                                return item
                            }
                            return nil
                        case .horizontalTheme:
                            var temp = item
                            temp.filterRecommendRecruit(text: searchText)
                            guard let recommendRecruit = temp.recommendRecruit else {return nil}
                            if recommendRecruit.isEmpty { return nil }
                            return temp
                            
                        default:
                            return nil
                        }
                    }
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
                return Observable.just(CellData(cellItems: []))
            })
            .map{ $0.cellItems }
    }
}
