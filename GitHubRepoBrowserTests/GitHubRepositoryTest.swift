//
//  GitHubRepositoryTest.swift
//  GitHubRepoBrowserTests
//
//  Created by quesera2 on 2022/02/10.
//

import XCTest
@testable import GitHubRepoBrowser

class GitHubRepositoryTest: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    //JSONデコードに成功すること
    func testDecode() throws {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let result = try decoder.decode([GitHubRepository].self, from: testJson.data(using: .utf8)!)
        XCTAssertEqual(result.count, 2)
        
        let firstItem = result.first!
        XCTAssertEqual(firstItem.id, 445423299)
        XCTAssertEqual(firstItem.name, "Android2022")
        XCTAssertEqual(firstItem.htmlURL, URL(string: "https://github.com/quesera2/Android2022")!)
        XCTAssertEqual(firstItem.description, "2022年のAndroidアプリ構成を模索するリポジトリ")
        let expectDate = DateComponents(calendar: .current,
                                        timeZone: TimeZone(identifier: "UTC"),
                                        year: 2022,
                                        month: 1,
                                        day: 7,
                                        hour: 6,
                                        minute: 35,
                                        second: 52).date
        XCTAssertEqual(firstItem.createdAt, expectDate)
    }
}

fileprivate let testJson = """
[
  {
    "id": 445423299,
    "name": "Android2022",
    "full_name": "quesera2/Android2022",
    "html_url": "https://github.com/quesera2/Android2022",
    "description": "2022年のAndroidアプリ構成を模索するリポジトリ",
    "url": "https://api.github.com/repos/quesera2/Android2022",
    "created_at": "2022-01-07T06:35:52Z",
    "updated_at": "2022-01-07T08:56:33Z",
  },
  {
    "id": 161878474,
    "node_id": "MDEwOlJlcG9zaXRvcnkxNjE4Nzg0NzQ=",
    "name": "camera1",
    "full_name": "quesera2/camera1",
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
    "html_url": "https://github.com/quesera2/camera1",
    "description": "いまさらCamera1",
    "fork": false,
    "url": "https://api.github.com/repos/quesera2/camera1",
    "forks_url": "https://api.github.com/repos/quesera2/camera1/forks",
    "keys_url": "https://api.github.com/repos/quesera2/camera1/keys{/key_id}",
    "collaborators_url": "https://api.github.com/repos/quesera2/camera1/collaborators{/collaborator}",
    "teams_url": "https://api.github.com/repos/quesera2/camera1/teams",
    "hooks_url": "https://api.github.com/repos/quesera2/camera1/hooks",
    "issue_events_url": "https://api.github.com/repos/quesera2/camera1/issues/events{/number}",
    "events_url": "https://api.github.com/repos/quesera2/camera1/events",
    "assignees_url": "https://api.github.com/repos/quesera2/camera1/assignees{/user}",
    "branches_url": "https://api.github.com/repos/quesera2/camera1/branches{/branch}",
    "tags_url": "https://api.github.com/repos/quesera2/camera1/tags",
    "blobs_url": "https://api.github.com/repos/quesera2/camera1/git/blobs{/sha}",
    "git_tags_url": "https://api.github.com/repos/quesera2/camera1/git/tags{/sha}",
    "git_refs_url": "https://api.github.com/repos/quesera2/camera1/git/refs{/sha}",
    "trees_url": "https://api.github.com/repos/quesera2/camera1/git/trees{/sha}",
    "statuses_url": "https://api.github.com/repos/quesera2/camera1/statuses/{sha}",
    "languages_url": "https://api.github.com/repos/quesera2/camera1/languages",
    "stargazers_url": "https://api.github.com/repos/quesera2/camera1/stargazers",
    "contributors_url": "https://api.github.com/repos/quesera2/camera1/contributors",
    "subscribers_url": "https://api.github.com/repos/quesera2/camera1/subscribers",
    "subscription_url": "https://api.github.com/repos/quesera2/camera1/subscription",
    "commits_url": "https://api.github.com/repos/quesera2/camera1/commits{/sha}",
    "git_commits_url": "https://api.github.com/repos/quesera2/camera1/git/commits{/sha}",
    "comments_url": "https://api.github.com/repos/quesera2/camera1/comments{/number}",
    "issue_comment_url": "https://api.github.com/repos/quesera2/camera1/issues/comments{/number}",
    "contents_url": "https://api.github.com/repos/quesera2/camera1/contents/{+path}",
    "compare_url": "https://api.github.com/repos/quesera2/camera1/compare/{base}...{head}",
    "merges_url": "https://api.github.com/repos/quesera2/camera1/merges",
    "archive_url": "https://api.github.com/repos/quesera2/camera1/{archive_format}{/ref}",
    "downloads_url": "https://api.github.com/repos/quesera2/camera1/downloads",
    "issues_url": "https://api.github.com/repos/quesera2/camera1/issues{/number}",
    "pulls_url": "https://api.github.com/repos/quesera2/camera1/pulls{/number}",
    "milestones_url": "https://api.github.com/repos/quesera2/camera1/milestones{/number}",
    "notifications_url": "https://api.github.com/repos/quesera2/camera1/notifications{?since,all,participating}",
    "labels_url": "https://api.github.com/repos/quesera2/camera1/labels{/name}",
    "releases_url": "https://api.github.com/repos/quesera2/camera1/releases{/id}",
    "deployments_url": "https://api.github.com/repos/quesera2/camera1/deployments",
    "created_at": "2018-12-15T06:49:01Z",
    "updated_at": "2018-12-16T11:12:57Z",
    "pushed_at": "2018-12-16T11:12:56Z",
    "git_url": "git://github.com/quesera2/camera1.git",
    "ssh_url": "git@github.com:quesera2/camera1.git",
    "clone_url": "https://github.com/quesera2/camera1.git",
    "svn_url": "https://github.com/quesera2/camera1",
    "homepage": null,
    "size": 163,
    "stargazers_count": 0,
    "watchers_count": 0,
    "language": "Kotlin",
    "has_issues": true,
    "has_projects": true,
    "has_downloads": true,
    "has_wiki": true,
    "has_pages": false,
    "forks_count": 0,
    "mirror_url": null,
    "archived": false,
    "disabled": false,
    "open_issues_count": 0,
    "license": null,
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
