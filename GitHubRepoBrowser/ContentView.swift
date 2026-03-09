//
//  ContentView.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/09.
//

import SwiftUI
import ViewModel
import Model

struct ContentViewScreen: View {
    @Environment(\.navigator) private var navigator: NavigatorProtocol
    @Environment(\.apiClient) private var apiClient: GitHubAPIClientProtocol
    
    var body: some View {
        ContentView(navigator: navigator, apiClient: apiClient)
    }
}

struct ContentView: View {
        
    @State private var viewModel: ContentViewModel
    @State private var isSearchPresented = false
    
    init(navigator: NavigatorProtocol,
         apiClient: GitHubAPIClientProtocol) {
        self.viewModel = .init(apiClient: apiClient, navigator: navigator)
    }
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            List {
                ForEach(viewModel.repositories) { item in
                    GitHubRepositoryView(item: item) {
                        viewModel.openBrowser(item: $0)
                    }
                    .listRowSeparator(.visible)
                }
            }
            .listStyle(.plain)
            .navigationTitle(viewModel.repositories.isEmpty
                ? "リポジトリ一覧"
                : "リポジトリ一覧（\(viewModel.repositories.count)件）"
            )
            .refreshable {
                await viewModel.fetchRepository()
            }
            .overlay {
                if viewModel.showProgress {
                    ProgressView()
                } else if viewModel.hasLoaded && viewModel.repositories.isEmpty {
                    ContentUnavailableView(
                        "リポジトリが見つかりません",
                        systemImage: "folder",
                        description: Text("このユーザーにはリポジトリがありません")
                    )
                }
            }
            .searchable(
                text: $viewModel.query,
                isPresented: $isSearchPresented,
                prompt: "ユーザー名を入力してください")
            .keyboardType(.alphabet)
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
            .onSubmit(of: .search) {
                Task {
                    await viewModel.fetchRepository()
                    isSearchPresented = false
                }
            }
        }
        .alert(
            isPresented: $viewModel.needShowError,
            error: viewModel.occursError,
            actions: {
                // do nothing.
            }
        )
        .task {
            await viewModel.fetchRepository()
        }
    }
}

#Preview {
    ContentView(
        navigator: Navigator(),
        apiClient: GitHubAPIClient(httpClient: URLSessionHTTPClient(URLSession.shared))
    )
}
