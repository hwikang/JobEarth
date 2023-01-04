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
    private let network: RecruitNetworInterface
    private let disposebag = DisposeBag()
    init(network:RecruitNetworInterface) {
        self.network = network
    }
    
    struct Input {
        var triger: Driver<CategoryType>
    }
    
    struct Output {
        var recruitItems: Driver<[RecruitItem]>
    }
    
    func transform(input:Input) ->Output {
        
        let recruitItems = input.triger.flatMapLatest { type -> Driver<[RecruitItem]>  in
            return self.getRecruits()
                .asDriver(onErrorJustReturn: [])
        }
        
        return Output(recruitItems: recruitItems)
    }
    
    private func getRecruits() -> Observable<[RecruitItem]>{
        return network.getRecruit().map { data in
            data.recruitItems
        }
    }
}
