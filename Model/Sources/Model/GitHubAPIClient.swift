//
//  GitHubAPI.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/10.
//

import Foundation

public enum GitHubAPIError: Error {
    case invalidURL
    case connectionError
    case jsonParseError
}

public final class GitHubAPIClient: GitHubAPIClientProtocol {
    
    private let urlSession: URLSession
    
    public init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func fetchRepositories(userName: String) async throws -> [GitHubRepository] {
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
            throw GitHubAPIError.invalidURL
        }
        
        return url
    }
    
    private func connection(url: URL) async throws -> Data {
        do {
            let (data, _) = try await self.urlSession.data(from: url)
            return data
        } catch {
            throw GitHubAPIError.connectionError
        }
    }
    
    private func parseResult(data: Data) throws -> [GitHubRepository] {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            return try decoder.decode([GitHubRepository].self, from: data)
        } catch {
            throw GitHubAPIError.jsonParseError
        }
    }
}
