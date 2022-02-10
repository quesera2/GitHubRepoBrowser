//
//  GitHubAPI.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/10.
//

import Foundation

enum GitHubAPIError: Error {
    case InvalidURL
    case ConnectionError
    case JsonParseError
}

final class GitHubAPI {
    
    func fetchRepositories(userName: String) async throws -> [GitHubRepository] {
        let url = try buildURL(userName: userName)
        let data = try await connection(url: url)
        let result = try parseResult(data: data)
        
        return result
    }
    
    private func buildURL(userName: String) throws -> URL {
        guard
            let userName = userName.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
            let url = URL(string: "https://api.github.com/users/\(userName)/repos")
        else {
            throw GitHubAPIError.InvalidURL
        }
        
        return url
    }
    
    private func connection(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw GitHubAPIError.ConnectionError
        }
    }
    
    private func parseResult(data: Data) throws -> [GitHubRepository] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([GitHubRepository].self, from: data)
        } catch {
            throw GitHubAPIError.JsonParseError
        }
    }
}
