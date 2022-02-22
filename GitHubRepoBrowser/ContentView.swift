//
//  ContentView.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/09.
//

import SwiftUI
import ViewModel

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel(
        navigator: Navigator()
    )
    
    var body: some View {
        NavigationView {
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
        .modifier(
            HandleError(
                needShowError: $viewModel.needShowError,
                occursError: viewModel.occursError
            )
        )
        .task {
            await viewModel.fetchRepository()
        }
        .searchable(text: $viewModel.query, prompt: "ユーザー名を入力してください")
        .onSubmit(of: .search) {
            Task {
                await viewModel.fetchRepository()
            }
        }
    }
}

private struct HandleError: ViewModifier {
    
    let needShowError: Binding<Bool>
    let occursError: ContentViewModelError?
    
    func body(content: Content) -> some View {
        content.alert(
            isPresented: needShowError,
            error: occursError,
            actions: {
                // do nothing.
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
