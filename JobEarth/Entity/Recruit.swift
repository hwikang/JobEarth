//
//  Recruit.swift
//  JobEarth
//
//  Created by Dumveloper on 2023/01/03.
//

import Foundation
struct RecruitData: Decodable {
    let recruitItems: [RecruitItem]
    
    private enum CodingKeys: String, CodingKey {
        case recruitItems = "recruit_items"
    }

}

struct RecruitItem: Decodable {
    let id: Int
    let title: String
    let reward: Int
    let appeal: [String]
    let imageUrl: String
    let company: Company
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case reward
        case appeal
        case imageUrl = "image_url"
        case company
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        reward = try container.decode(Int.self, forKey: .reward)
        imageUrl = try container.decode(String.self, forKey: .imageUrl)
        company = try container.decode(Company.self, forKey: .company)
        let appealString = try container.decode(String.self, forKey: .appeal)
        appeal = appealString.components(separatedBy: ", ")
        
    }
}

struct Company: Decodable {
    let name: String
    let logoPath: String
    let ratings: [Rating]
    
    private enum CodingKeys: String, CodingKey {
        case name
        case logoPath = "logo_path"
        case ratings
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        logoPath = try container.decode(String.self, forKey: .logoPath)
        ratings = try container.decode([Rating].self, forKey: .ratings)
        
    }
}
    

struct Rating: Decodable {
    let type: String
    let rating: Float
}
