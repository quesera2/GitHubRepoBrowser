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
        .handleError(
            needShowError: $viewModel.needShowError,
            occursError: viewModel.occursError
        )
        .task {
            await viewModel.fetchRepository()
        }
    }
}

fileprivate extension View {
    func handleError(needShowError: Binding<Bool>,
                     occursError: ContentViewModelError?) -> some View {
        return alert(
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
