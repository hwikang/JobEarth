//
//  Company.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/05.
//

import Foundation

import Foundation
struct CellData: Decodable {
    let cellItems: [CellItem]
    
    private enum CodingKeys: String, CodingKey {
        case cellItems = "cell_items"
    }

}


enum CellItemType {
    case company
    case horizontalTheme
    
}

struct CellItem: Decodable, Hashable {

    let cellType: CellItemType
    let logoPath: String?
    let name: String?
    let industryName: String?
    let rateTotalAvg: Float?
    let reviewSummary: String?
    let interviewQuestion: String?
    let salaryAvg: Int?
    let updateDate: String?
    let count: Int?
    let sectionTitle: String?
    let recommendRecruit: [RecruitItem]?

    private enum CodingKeys: String, CodingKey {
        case cellType = "cell_type"
        case logoPath = "logo_path"
        case name
        case industryName = "industry_name"
        case rateTotalAvg = "rate_total_avg"
        case reviewSummary = "review_summary"
        case interviewQuestion = "interview_question"
        case salaryAvg = "salary_avg"
        case updateDate = "update_date"
        case count
        case sectionTitle = "section_title"
        case recommendRecruit = "recommend_recruit"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let cellTypeString = try container.decode(String.self, forKey: .cellType)
        switch cellTypeString {
        case "CELL_TYPE_COMPANY":
            cellType = .company
            
        default:
            cellType = .horizontalTheme
            
        }
        logoPath = try? container.decode(String.self, forKey: .logoPath)
        name = try? container.decode(String.self, forKey: .name)
        industryName = try? container.decode(String.self, forKey: .industryName)
        rateTotalAvg = try? container.decode(Float.self, forKey: .rateTotalAvg)
        reviewSummary = try? container.decode(String.self, forKey: .reviewSummary)
        interviewQuestion = try? container.decode(String.self, forKey: .interviewQuestion)
        salaryAvg = try? container.decode(Int.self, forKey: .salaryAvg)
        updateDate = try? container.decode(String.self, forKey: .updateDate)
        count = try? container.decode(Int.self, forKey: .count)
        sectionTitle = try? container.decode(String.self, forKey: .sectionTitle)
        recommendRecruit = try? container.decode([RecruitItem].self, forKey: .recommendRecruit)
    }

    private func setCellType(type: String) -> CellItemType{
        switch type {
        case "CELL_TYPE_COMPANY":
            return .company
        default:
            return .horizontalTheme
        }
    }

    static func == (lhs: CellItem, rhs: CellItem) -> Bool {
        if lhs.cellType == rhs.cellType {
            switch lhs.cellType {
            case .company:
                return lhs.name == rhs.name
            case .horizontalTheme:
                return lhs.sectionTitle == rhs.sectionTitle
            }
        }
        
        return false
        
        
    }

}


