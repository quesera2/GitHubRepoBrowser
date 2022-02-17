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
    
    @Published private var state: ContentViewModelState = .Idle
    
    /// 読込中表示
    public var showProgress: Bool {
        switch self.state {
        case .Loading: return true
        case .Idle, .Loaded(_), .Failed(_): return false
        }
    }
    
    /// 読み込んだリポジトリ
    public var repositories: [GitHubRepository] {
        switch self.state {
        case .Idle, .Loading, .Failed(_): return []
        case .Loaded(let newData): return newData
        }
    }
    
    /// エラーアラートを表示するかどうか
    public var needShowError: Bool {
        get {
            switch self.state {
            case .Idle, .Loading, .Loaded(_): return false
            case .Failed(_):  return true
            }
        }
        set {
            // システムがfalseを返却したらエラー表示を終了して待機に戻す
            if !newValue {
                self.state = .Idle
            }
        }
    }
    
    /// 発生したエラー
    public var occursError: ContentViewModelError? {
        switch self.state {
        case .Idle, .Loading, .Loaded(_): return nil
        case .Failed(let error):  return error
        }
    }
    
    private let apiClient: GitHubAPIClientProtocol
    
    public init(apiClient: GitHubAPIClientProtocol = GitHubAPIClient()) {
        self.apiClient = apiClient
    }
    
    public func fetchRepository() async {
        self.state = .Loading
        do {
            let result = try await apiClient.fetchRepositories(userName: "quesera2")
            self.state = .Loaded(result)
        } catch let error as GitHubAPIError {
            switch error {
            case .InvalidURL:
                self.state = .Failed(.RequestError)
            case .ConnectionError, .JsonParseError:
                self.state = .Failed(.ResponseError)
            }
        } catch {
            fatalError("unknown error")
        }
    }
}
