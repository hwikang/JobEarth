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

enum Section: Hashable {
    case recruit
    case cellCompany(String)
    case cellHorizontal(String)
}




enum Item: Hashable {
    case recruit(RecruitItem)
    case cellCompany(CellItem.Company)
    case cellHorizontal(RecruitItem)
}



