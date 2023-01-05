//
//  CompanyNetwork.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/05.
//

import Foundation
import RxSwift

protocol CellNetworkInterface {
    func getCell() -> Observable<CellData>
}

final class CellNetwork: CellNetworkInterface {
    private let network : Network<CellData>
    init(network: Network<CellData>){
        self.network = network
    }
    
    func getCell() -> Observable<CellData>{
        return network.getItem("test_data_cell_items.json")
    }
}
