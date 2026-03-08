//
//  ContentView.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/09.
//

import SwiftUI
import ViewModel

struct ContentView: View {
    @State private var viewModel = ContentViewModel(
        navigator: Navigator()
    )
    
    var body: some View {
        @Bindable var viewModel = viewModel
        
        NavigationStack {
            List {
                ForEach(viewModel.repositories) { item in
                    GitHubRepositoryView(item: item) {
                        viewModel.openBrowser(item: $0)
                    }
                }
            }
            .navigationTitle("リポジトリ一覧")
            .refreshable {
                await viewModel.fetchRepository()
            }
            .overlay {
                if viewModel.showProgress {
                    ProgressView()
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
        .modifier(RepositorySearch(
            query: $viewModel.query,
            action: {
                await viewModel.fetchRepository()
            })
        )
    }
}

private struct RepositorySearch: ViewModifier {
    
    @Binding var query: String
    let action: () async -> Void
    
    func body(content: Content) -> some View {
        content.searchable(
            text: $query,
            prompt: "ユーザー名を入力してください")
            .keyboardType(.alphabet)
            .disableAutocorrection(true)
            .textInputAutocapitalization(.never)
            .onSubmit(of: .search) {
                Task {
                    await self.action()
                }
            }
    }
    
}

#Preview {
    ContentView()
}
