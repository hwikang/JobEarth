//
//  HireNetwork.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/03.
//

import Foundation
import RxSwift

protocol RecruitNetworInterface {
    func getRecruit() -> Observable<RecruitData>
}

final class RecruitNetwork: RecruitNetworInterface {
    private let network : Network<RecruitData>
    init(network: Network<RecruitData>){
        self.network = network
    }
    
    func getRecruit() -> Observable<RecruitData>{
        return network.getItem("test_data_recruit_items.json")
    }
}
