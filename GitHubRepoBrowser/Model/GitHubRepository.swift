//
//  GitHubRepository.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/10.
//

import Foundation

/// GitHubのリポジトリ情報を保持する
struct GitHubRepository {
    let id: Int
    let name: String
    let htmlURL: URL
    let description: String
    let createdAt, updatedAt: Date
}

extension GitHubRepository: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: CodingKeys.id)
        self.name = try container.decode(String.self, forKey: CodingKeys.name)
        self.description = try container.decode(String?.self, forKey: CodingKeys.description) ?? ""
        let htmlURLString = try container.decode(String.self, forKey: CodingKeys.htmlURL)
        guard
            let htmlURL = URL(string: htmlURLString)
        else {
            throw DecodingError.typeMismatch(URL.self, DecodingError.Context(codingPath: [CodingKeys.htmlURL],
                                                                             debugDescription: "URLが不正です",
                                                                             underlyingError: nil))
        }
        self.htmlURL = htmlURL
        self.createdAt = try container.decode(Date.self, forKey: CodingKeys.createdAt)
        self.updatedAt = try container.decode(Date.self, forKey: CodingKeys.updatedAt)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case fullName = "full_name"
        case htmlURL = "html_url"
        case description
        case url
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension GitHubRepository: Identifiable { }
