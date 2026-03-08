//
//  GitHubAPIClientProtocol.swift
//  
//
//  Created by quesera2 on 2022/02/15.
//

import Foundation

public protocol GitHubAPIClientProtocol: Sendable {

    func fetchRepositories(userName: String) async throws -> [GitHubRepository]
}
