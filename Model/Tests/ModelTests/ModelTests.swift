import Testing
import Foundation
@testable import Model

struct GitHubAPIClientTests {
    
    private func makeClient(
        handler: @escaping (@Sendable (URLRequest) async throws -> (Data, HTTPURLResponse))
    ) -> GitHubAPIClient {
        return GitHubAPIClient(httpClient: MockHTTPClient(handler: handler))
    }
    
    @Test("正常系：通信に成功してデータを返す")
    func success() async throws {
        let client = makeClient { request in
            (testData.data(using: .utf8)!, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!)
        }
        let result = try await client.fetchRepositories(userName: "test")
        #expect(result.count == 1)
        #expect(result.first?.name == "RxSwift")
    }
    
    @Test("通信エラーの場合")
    func failureConnection() async throws {
        let client = makeClient { _ in
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil)
        }
        await #expect(throws: GitHubAPIError.connectionError) {
            try await client.fetchRepositories(userName: "test")
        }
    }
    
    @Test("JSONが不正な場合")
    func brokenJson() async throws {
        let client = makeClient { request in
            ("]invalid json[".data(using: .utf8)!, HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!)
        }
        await #expect(throws: GitHubAPIError.jsonParseError) {
            try await client.fetchRepositories(userName: "test")
        }
    }
}

private actor MockURLProtocolStorage {
    var handler: (@Sendable (URLRequest) async throws -> (HTTPURLResponse, Data))?
}

// 通信テスト用のモック
private final class MockHTTPClient: HTTPClient {
    
    let handler: (@Sendable (URLRequest) async throws -> (Data, HTTPURLResponse))
    
    init(handler: @Sendable @escaping (URLRequest) async throws -> (Data, HTTPURLResponse)) {
        self.handler = handler
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await self.handler(URLRequest(url: url))
    }
    
    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.handler(request)
    }
}


private let testData = """
[
{
"id": 131836719,
"node_id": "MDEwOlJlcG9zaXRvcnkxMzE4MzY3MTk=",
"name": "RxSwift",
"full_name": "quesera2/RxSwift",
"private": false,
"owner": {
  "login": "quesera2",
  "id": 2074276,
  "node_id": "MDQ6VXNlcjIwNzQyNzY=",
  "avatar_url": "https://avatars.githubusercontent.com/u/2074276?v=4",
  "gravatar_id": "",
  "url": "https://api.github.com/users/quesera2",
  "html_url": "https://github.com/quesera2",
  "followers_url": "https://api.github.com/users/quesera2/followers",
  "following_url": "https://api.github.com/users/quesera2/following{/other_user}",
  "gists_url": "https://api.github.com/users/quesera2/gists{/gist_id}",
  "starred_url": "https://api.github.com/users/quesera2/starred{/owner}{/repo}",
  "subscriptions_url": "https://api.github.com/users/quesera2/subscriptions",
  "organizations_url": "https://api.github.com/users/quesera2/orgs",
  "repos_url": "https://api.github.com/users/quesera2/repos",
  "events_url": "https://api.github.com/users/quesera2/events{/privacy}",
  "received_events_url": "https://api.github.com/users/quesera2/received_events",
  "type": "User",
  "site_admin": false
},
"html_url": "https://github.com/quesera2/RxSwift",
"description": "Reactive Programming in Swift",
"fork": true,
"url": "https://api.github.com/repos/quesera2/RxSwift",
"forks_url": "https://api.github.com/repos/quesera2/RxSwift/forks",
"keys_url": "https://api.github.com/repos/quesera2/RxSwift/keys{/key_id}",
"collaborators_url": "https://api.github.com/repos/quesera2/RxSwift/collaborators{/collaborator}",
"teams_url": "https://api.github.com/repos/quesera2/RxSwift/teams",
"hooks_url": "https://api.github.com/repos/quesera2/RxSwift/hooks",
"issue_events_url": "https://api.github.com/repos/quesera2/RxSwift/issues/events{/number}",
"events_url": "https://api.github.com/repos/quesera2/RxSwift/events",
"assignees_url": "https://api.github.com/repos/quesera2/RxSwift/assignees{/user}",
"branches_url": "https://api.github.com/repos/quesera2/RxSwift/branches{/branch}",
"tags_url": "https://api.github.com/repos/quesera2/RxSwift/tags",
"blobs_url": "https://api.github.com/repos/quesera2/RxSwift/git/blobs{/sha}",
"git_tags_url": "https://api.github.com/repos/quesera2/RxSwift/git/tags{/sha}",
"git_refs_url": "https://api.github.com/repos/quesera2/RxSwift/git/refs{/sha}",
"trees_url": "https://api.github.com/repos/quesera2/RxSwift/git/trees{/sha}",
"statuses_url": "https://api.github.com/repos/quesera2/RxSwift/statuses/{sha}",
"languages_url": "https://api.github.com/repos/quesera2/RxSwift/languages",
"stargazers_url": "https://api.github.com/repos/quesera2/RxSwift/stargazers",
"contributors_url": "https://api.github.com/repos/quesera2/RxSwift/contributors",
"subscribers_url": "https://api.github.com/repos/quesera2/RxSwift/subscribers",
"subscription_url": "https://api.github.com/repos/quesera2/RxSwift/subscription",
"commits_url": "https://api.github.com/repos/quesera2/RxSwift/commits{/sha}",
"git_commits_url": "https://api.github.com/repos/quesera2/RxSwift/git/commits{/sha}",
"comments_url": "https://api.github.com/repos/quesera2/RxSwift/comments{/number}",
"issue_comment_url": "https://api.github.com/repos/quesera2/RxSwift/issues/comments{/number}",
"contents_url": "https://api.github.com/repos/quesera2/RxSwift/contents/{+path}",
"compare_url": "https://api.github.com/repos/quesera2/RxSwift/compare/{base}...{head}",
"merges_url": "https://api.github.com/repos/quesera2/RxSwift/merges",
"archive_url": "https://api.github.com/repos/quesera2/RxSwift/{archive_format}{/ref}",
"downloads_url": "https://api.github.com/repos/quesera2/RxSwift/downloads",
"issues_url": "https://api.github.com/repos/quesera2/RxSwift/issues{/number}",
"pulls_url": "https://api.github.com/repos/quesera2/RxSwift/pulls{/number}",
"milestones_url": "https://api.github.com/repos/quesera2/RxSwift/milestones{/number}",
"notifications_url": "https://api.github.com/repos/quesera2/RxSwift/notifications{?since,all,participating}",
"labels_url": "https://api.github.com/repos/quesera2/RxSwift/labels{/name}",
"releases_url": "https://api.github.com/repos/quesera2/RxSwift/releases{/id}",
"deployments_url": "https://api.github.com/repos/quesera2/RxSwift/deployments",
"created_at": "2018-05-02T10:43:32Z",
"updated_at": "2018-05-02T10:43:36Z",
"pushed_at": "2018-05-03T09:11:06Z",
"git_url": "git://github.com/quesera2/RxSwift.git",
"ssh_url": "git@github.com:quesera2/RxSwift.git",
"clone_url": "https://github.com/quesera2/RxSwift.git",
"svn_url": "https://github.com/quesera2/RxSwift",
"homepage": "",
"size": 12267,
"stargazers_count": 0,
"watchers_count": 0,
"language": "Swift",
"has_issues": false,
"has_projects": true,
"has_downloads": true,
"has_wiki": true,
"has_pages": false,
"forks_count": 0,
"mirror_url": null,
"archived": false,
"disabled": false,
"open_issues_count": 0,
"license": {
  "key": "other",
  "name": "Other",
  "spdx_id": "NOASSERTION",
  "url": null,
  "node_id": "MDc6TGljZW5zZTA="
},
"allow_forking": true,
"is_template": false,
"topics": [

],
"visibility": "public",
"forks": 0,
"open_issues": 0,
"watchers": 0,
"default_branch": "master"
}
]
"""
