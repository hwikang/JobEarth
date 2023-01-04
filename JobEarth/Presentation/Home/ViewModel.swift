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
    private let errorMessage = PublishRelay<String>()
    init(network:RecruitNetworInterface) {
        self.network = network
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
        return network.getRecruit()
            .catch({[weak self] error in
                self?.errorMessage.accept(error.localizedDescription)
                return Observable.just(RecruitData(recruitItems: []))
            })
            .map { $0.recruitItems }
    }
}
