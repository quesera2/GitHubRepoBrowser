//
//  ContentViewModel.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/14.
//

import Foundation
import Model

@MainActor
public class ContentViewModel: ObservableObject {

    @Published private var state: ContentViewModelState = .idle

    /// 読込中表示
    public var showProgress: Bool {
        switch self.state {
        case .loading: return true
        case .idle, .loaded, .failed: return false
        }
    }

    /// 読み込んだリポジトリ
    public var repositories: [GitHubRepository] {
        switch self.state {
        case .idle, .loading, .failed: return []
        case .loaded(let newData): return newData
        }
    }

    /// エラーアラートを表示するかどうか
    public var needShowError: Bool {
        get {
            switch self.state {
            case .idle, .loading, .loaded: return false
            case .failed:  return true
            }
        }
        set {
            // システムがfalseを返却したらエラー表示を終了して待機に戻す
            if !newValue {
                self.state = .idle
            }
        }
    }

    /// 発生したエラー
    public var occursError: ContentViewModelError? {
        switch self.state {
        case .idle, .loading, .loaded: return nil
        case .failed(let error):  return error
        }
    }

    private let apiClient: GitHubAPIClientProtocol

    public init(apiClient: GitHubAPIClientProtocol = GitHubAPIClient()) {
        self.apiClient = apiClient
    }

    public func fetchRepository() async {
        self.state = .loading
        do {
            let result = try await apiClient.fetchRepositories(userName: "quesera2")
            self.state = .loaded(result)
        } catch let error as GitHubAPIError {
            switch error {
            case .invalidURL:
                self.state = .failed(.requestError)
            case .connectionError, .jsonParseError:
                self.state = .failed(.responseError)
            }
        } catch {
            fatalError("unknown error")
        }
    }
}
