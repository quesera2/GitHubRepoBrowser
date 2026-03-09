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

    let action: (GitHubRepository) -> Void

    var body: some View {
        Button {
            self.action(item)
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                Text(item.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !item.description.isEmpty {
                    Text(item.description)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                HStack(spacing: 16) {
                    if let language = item.language {
                        Label(language, systemImage: "chevron.left.forwardslash.chevron.right")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }

                    Label {
                        Text(item.stargazersCount, format: .number)
                            .font(.caption)
                    } icon: {
                        Image(systemName: "star.fill")
                            .foregroundStyle(.yellow)
                            .font(.caption)
                    }
                    .foregroundStyle(.secondary)

                    Spacer()

                    Text(item.updatedAt, format: .relative(presentation: .named))
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.vertical, 4)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    List {
        GitHubRepositoryView(
            item: GitHubRepository(id: 1,
                                   name: "swift-composable-architecture",
                                   htmlURL: URL(string: "http://example.com")!,
                                   description: "A library for building applications in a consistent and understandable way.",
                                   stargazersCount: 12300,
                                   language: "Swift",
                                   createdAt: Date(),
                                   updatedAt: Date().addingTimeInterval(-86400)),
            action: { _ in }
        )
        GitHubRepositoryView(
            item: GitHubRepository(id: 2,
                                   name: "my-project",
                                   htmlURL: URL(string: "http://example.com")!,
                                   description: "",
                                   stargazersCount: 0,
                                   createdAt: Date(),
                                   updatedAt: Date()),
            action: { _ in }
        )
    }
}
