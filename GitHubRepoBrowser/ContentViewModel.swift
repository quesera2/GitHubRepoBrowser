//
//  ContentViewModel.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/14.
//

import Foundation

@MainActor
class ContentViewModel: ObservableObject {
    @Published private(set) var repositories: [GitHubRepository] = []
    
    func fetchRepository() async {
        let api = GitHubAPI()
        do {
            let result = try await api.fetchRepositories(userName: "quesera2")
            repositories = result
        } catch GitHubAPIError.InvalidURL {
            print("error handling invalid url")
        } catch GitHubAPIError.ConnectionError {
            print("error handling connection")
        } catch GitHubAPIError.JsonParseError {
            print("error handling json parse")
        } catch {
            fatalError("unknown error")
        }
    }
}
