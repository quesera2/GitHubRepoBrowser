import SwiftUI
import Model
import ViewModel

// MARK: - GitHubAPIClient

private struct GitHubAPIClientKey: EnvironmentKey {
    static let defaultValue: GitHubAPIClientProtocol = GitHubAPIClient()
}

extension EnvironmentValues {
    var apiClient: GitHubAPIClientProtocol {
        get { self[GitHubAPIClientKey.self] }
        set { self[GitHubAPIClientKey.self] = newValue }
    }
}

// MARK: - Navigator

private struct NavigatorKey: EnvironmentKey {
    static let defaultValue: NavigatorProtocol = Navigator()
}

extension EnvironmentValues {
    var navigator: NavigatorProtocol {
        get { self[NavigatorKey.self] }
        set { self[NavigatorKey.self] = newValue }
    }
}
