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
        
        
        getCells()
    }
    
    struct Input {
        var triger: Driver<CategoryType>
    }
    
    struct Output {
        var recruitItems: Driver<[RecruitItem]>
        var error: Driver<String>
    }
    
    func transform(input:Input) ->Output {
        
        let recruitItems = input.triger.flatMapLatest { type -> Driver<[RecruitItem]>  in

            return self.getRecruits()
                .asDriver(onErrorJustReturn: [])
        }
        
        return Output(recruitItems: recruitItems, error: errorMessage.asDriver(onErrorJustReturn: ""))
    }
    
    private func getRecruits() -> Observable<[RecruitItem]>{
        return recruitNetwork.getRecruit()
            .catch({[weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                return Observable.just(RecruitData(recruitItems: []))
            })
            .map { $0.recruitItems }
    }
    
    private func getCells()  {
        print("getCells")
        return cellNetwork.getCell()
            .catch({ error in
                print(error)
                return Observable.just(CellData(cellItems: []))
            })
            .bind { data in
            
            print(data)
            }.disposed(by: disposebag)
    }
}
