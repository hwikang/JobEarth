//
//  Company.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/05.
//


import Foundation

struct CellData:Decodable {
    let items: [CellItem]
    
    enum CodingKeys: String, CodingKey {
        case items = "cell_items"
    }
}

enum CellItem: Decodable , Hashable{
    case company(Company)
    case horizontal(Horizontal)
    case none
    
    enum CodingKeys: String, CodingKey {
        case type = "cell_type"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        guard let type = try? container.decode(CellType.self, forKey: .type) else {
            self = .none
            return
        }
        print("type \(type)")

        switch type {
           case .company:
               self = try .company(Company(from: decoder))
           case .horizontal:
               self = try .horizontal(Horizontal(from: decoder))
            
           }
    }
    
    
    enum CellType: String, Codable {
          case company = "CELL_TYPE_COMPANY"
          case horizontal = "CELL_TYPE_HORIZONTAL_THEME"
      }
    
    struct Company: Decodable, Hashable{
        var cellType: CellType
        var name: String
        let logoPath: String
        let industryName: String
        let rateTotalAvg: Float
        let reviewSummary: String
        let interviewQuestion: String
        let salaryAvg: Int
        let updateDate: String
        
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
       }
        
        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            cellType = try container.decode(CellType.self, forKey: .cellType)

            logoPath = try container.decode(String.self, forKey: .logoPath)
            name = try container.decode(String.self, forKey: .name)
            industryName = try container.decode(String.self, forKey: .industryName)
            rateTotalAvg = try container.decode(Float.self, forKey: .rateTotalAvg)
            reviewSummary = try container.decode(String.self, forKey: .reviewSummary)
            interviewQuestion = try container.decode(String.self, forKey: .interviewQuestion)
            salaryAvg = try container.decode(Int.self, forKey: .salaryAvg)
            updateDate = try container.decode(String.self, forKey: .updateDate)
        }
        
    }
    struct Horizontal: Decodable , Hashable{
        
        var cellType: CellType
        var sectionTitle: String
        let count: Int
        var recommendRecruit: [RecruitItem]
        private enum CodingKeys: String, CodingKey {
            case cellType = "cell_type"
           case count
           case sectionTitle = "section_title"
           case recommendRecruit = "recommend_recruit"
       }
        
        public init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
    
            cellType = try container.decode(CellType.self, forKey: .cellType)

                count = try container.decode(Int.self, forKey: .count)
                sectionTitle = try container.decode(String.self, forKey: .sectionTitle)
                recommendRecruit = try container.decode([RecruitItem].self, forKey: .recommendRecruit)
         }
        mutating func filterRecommendRecruit(text: String) {
            let filtered = recommendRecruit.filter({ item in
                item.title.lowercased().contains(text)
            })
    
            recommendRecruit = filtered
        }
    }
    
    static func == (lhs: CellItem, rhs: CellItem) -> Bool {

          return false
    }
}
