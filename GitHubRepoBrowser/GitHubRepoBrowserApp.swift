//
//  GitHubRepoBrowserApp.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/09.
//

import SwiftUI
import Model

@main
struct GitHubRepoBrowserApp: App {
    var body: some Scene {
        WindowGroup {
            ContentViewScreen()
                .environment(\.apiClient, GitHubAPIClient(httpClient: URLSessionHTTPClient(URLSession.shared)))
                .environment(\.navigator, Navigator())
        }
    }
}
