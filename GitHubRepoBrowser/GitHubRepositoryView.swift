//
//  GitHubRepositoryView.swift
//  GitHubRepoBrowser
//
//  Created by quesera2 on 2022/02/17.
//

import Foundation
import SwiftUI
import Model

struct GitHubRepositoryView: View {
    
    let item: GitHubRepository
    
    let action: (URL) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(item.name)
                .font(.title2)
            if !item.description.isEmpty {
                Text(item.description)
                    .font(.caption)
                    .foregroundColor(Color.gray)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 44,
            alignment: .topLeading
        )
        .padding([.leading, .trailing], 10)
        .padding([.top, .bottom], 5)
        .onTapGesture {
            self.action(item.htmlURL)
        }
    }
}

struct GitHubRepositoryView_Previews: PreviewProvider {
    
    static var previews: some View {
        GitHubRepositoryView(
            item: GitHubRepository(id: 1,
                                   name: "テストデータ",
                                   htmlURL: URL(string: "http://google.com")!,
                                   description: "説明テキスト",
                                   createdAt: Date(),
                                   updatedAt: Date()),
            action: { _ in }
        )
    }
}
