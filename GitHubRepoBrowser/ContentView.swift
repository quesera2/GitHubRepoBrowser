//
//  ContentView.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/09.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.repositories) { item in
                    Text(item.name)
                }
            }
            .navigationTitle("リポジトリ一覧")
            .listStyle(.plain)
        }
        .task {
            await viewModel.fetchRepository()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
