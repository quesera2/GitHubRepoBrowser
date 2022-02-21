import XCTest
@testable import Model

final class GitHubAPIClientTest: XCTestCase {
    
    private var client: GitHubAPIClient!
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        let session = URLSession(configuration: config)
        self.client = GitHubAPIClient(urlSession: session)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
    }
    
    func testSuccess() async throws {
        MockURLProtocol.requestHandler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!, testData.data(using: .utf8)!)
        }
        
        let result = try await self.client.fetchRepositories(userName: "test")
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first!.name, "RxSwift")
    }
    
    // 通信エラーの場合
    func testFailureConnection() async throws {
        MockURLProtocol.requestHandler = { request in
            throw NSError(domain: NSURLErrorDomain, code: NSURLErrorCannotConnectToHost, userInfo: nil)
        }
        
        do {
            _ = try await self.client.fetchRepositories(userName: "test")
            XCTFail("例外が発生すること")
        } catch let error as GitHubAPIError {
            XCTAssertEqual(error, GitHubAPIError.connectionError)
        } catch {
            XCTFail("GitHubAPIError型のエラーが発生すること")
        }
    }
    
    // JSONが不正な場合
    func testBrokenJson() async throws {
        MockURLProtocol.requestHandler = { request in
            (HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "2.0", headerFields: nil)!, "]invalid json[".data(using: .utf8)!)
        }
        
        do {
            _ = try await self.client.fetchRepositories(userName: "test")
            XCTFail("例外が発生すること")
        } catch let error as GitHubAPIError {
            XCTAssertEqual(error, GitHubAPIError.jsonParseError)
        } catch {
            XCTFail("GitHubAPIError型のエラーが発生すること")
        }
    }
}

// 通信テスト用のモック
private class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            fatalError()
        }
        
        do {
            let (response, data)  = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // for canceled.
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
