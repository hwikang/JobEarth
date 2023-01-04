//
//  ViewModel.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/03.
//

import Foundation


class ViewModel {
    private let network: RecruitNetworInterface
    init(network:RecruitNetworInterface) {
        self.network = network
    }
    
    func getRecruits(){
        network.getRecruit().bind { rd in
            print(rd)
        }
    }
}
