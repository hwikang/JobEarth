//
//  Network.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/03.
//

import Foundation
import RxSwift
import RxAlamofire

final class Network<T:Decodable> {
    private let endPoint: String = "https://jpassets.jobplanet.co.kr/mobile-config"
   
    func getItem(_ path: String) -> Observable<T> {
        let absolutePath = "\(endPoint)/\(path)"
        return RxAlamofire
            .data(.get, absolutePath)
            .debug()
            .observe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .map { data -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
