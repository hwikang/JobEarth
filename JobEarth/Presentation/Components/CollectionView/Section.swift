//
//  Section.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/05.
//

import Foundation

//struct Section: Hashable {
//    let id : String
//}

enum Section {
    case recruit
    case cellCompany
    case cellHorizontal
}

enum Item: Hashable {
    case double(RecruitItem)
    case big
    case carousel
}



