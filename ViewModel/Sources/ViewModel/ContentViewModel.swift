//
//  ContentViewModel.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/14.
//

import Foundation
import Model

enum ContentViewModelState {
    case Initial
    case Loaded([GitHubRepository])
    case Failed(ContentViewModelError)
}

enum ContentViewModelError: Error {
    case RequestError
    case LoadingError
}

@MainActor
public class ContentViewModel: ObservableObject {
    
    @Published private var state: ContentViewModelState = .Initial
    
    /// 読込中表示
    public var showProgress: Bool {
        switch(self.state) {
        case .Initial: return true
        case .Loaded(_), .Failed(_): return false
        }
    }
    
    /// 読み込んだリポジトリ
    public var repositories: [GitHubRepository] {
        switch(self.state) {
        case .Initial, .Failed(_): return []
        case .Loaded(let newData): return newData
        }
    }
    
    private let apiClient: GitHubAPIClientProtocol
    
    public init(apiClient: GitHubAPIClientProtocol = GitHubAPIClient()) {
        self.apiClient = apiClient
    }
    
    public func fetchRepository() async {
        do {
            let result = try await apiClient.fetchRepositories(userName: "quesera2")
            self.state = .Loaded(result)
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
