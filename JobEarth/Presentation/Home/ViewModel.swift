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
        var recruitTriger: Driver<Void>
        var cellTriger: Driver<Void>

    }
    
    struct Output {
        var recruitItems: Driver<[RecruitItem]>
        var cellItems: Driver<[CellItem]>
        var error: Driver<String>
    }
    
    func transform(input:Input) ->Output {
        let recruitItems = input.recruitTriger.flatMapLatest { _ -> Driver<[RecruitItem]>  in
            return self.getRecruits()
                .asDriver(onErrorJustReturn: [])
        }
        
        let cellItems = input.cellTriger.flatMapLatest { _ -> Driver<[CellItem]>  in
            return self.getCells()
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
