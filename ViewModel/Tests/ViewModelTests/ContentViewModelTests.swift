import Testing
import Model
import Foundation
@testable import ViewModel

@MainActor
struct ContentViewModelTests {

    @Test("正常系：通信に成功してデータを返す")
    func normal() async throws {
        let apiClient = MockAPIClient(expectResult: Array(dummyRepositoryData[...0]))
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)

        // 初期状態（エラー、ロード表示なし）
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)

        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        await Task.yield()
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == true)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)

        // ロードを止めて結果を返す
        apiClient.resume()
        await result
        #expect(viewModel.repositories.count == 1)
        #expect(viewModel.repositories.first?.name == "テストデータ1")
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)
    }

    @Test("異常系：通信に失敗してアラートを表示する")
    func failure() async throws {
        let apiClient = MockAPIClient(expectError: .connectionError)
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)

        // 初期状態（エラー、ロード表示なし）
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)

        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        await Task.yield()
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == true)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)

        // ロードを止めて結果を返す
        apiClient.resume()
        await result
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == true)
        #expect(viewModel.occursError == .responseError)

        // アラートを閉じると初期状態に戻る
        viewModel.needShowError = false
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)
    }

    @Test("入力が空のため何も実行しない")
    func emptyInput() async throws {
        let apiClient = MockAPIClient(expectResult: Array(dummyRepositoryData[...0]))
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)

        // 初期状態（エラー、ロード表示なし）
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)

        #expect(viewModel.isQueryEmpty == false)
        viewModel.query = ""
        #expect(viewModel.isQueryEmpty == true)

        // ロードを実行
        await viewModel.fetchRepository()

        // 初期状態と同じであること
        #expect(viewModel.repositories == [])
        #expect(viewModel.showProgress == false)
        #expect(viewModel.needShowError == false)
        #expect(viewModel.occursError == nil)
    }

    @Test("画面遷移のテスト")
    func transition() {
        let apiClient = MockAPIClient(expectResult: [])
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)

        #expect(navigator.called == false)
        viewModel.openBrowser(item: dummyRepositoryData[2])
        #expect(navigator.called == true)
        #expect(navigator.capturedUrl == dummyRepositoryData[2].htmlURL)
    }
}

private let dummyRepositoryData: [GitHubRepository] = {
    (1...10).map {
        GitHubRepository(
            id: $0,
            name: "テストデータ\($0)",
            htmlURL: URL(string: "http://example.com/\($0)")!,
            description: "テストデータ説明\($0)",
            createdAt: Date(),
            updatedAt: Date()
        )
    }
}()

fileprivate final class MockAPIClient: GitHubAPIClientProtocol, @unchecked Sendable {

    private let expectResult: [GitHubRepository]?
    private let expectError: GitHubAPIError?

    private var continuation: CheckedContinuation<[GitHubRepository], Error>?
    private let continuationReady = DispatchSemaphore(value: 0)

    init(expectResult: [GitHubRepository]? = nil, expectError: GitHubAPIError? = nil) {
        self.expectResult = expectResult
        self.expectError = expectError
    }

    nonisolated func fetchRepositories(userName: String) async throws -> [GitHubRepository] {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
            self.continuationReady.signal()
        }
    }

    func resume() {
        continuationReady.wait()
        switch (expectResult, expectError) {
        case (let expectResult?, nil): self.continuation!.resume(returning: expectResult)
        case (nil, let expectError?): self.continuation!.resume(throwing: expectError)
        default: fatalError()
        }
    }
}

fileprivate final class MockNavigator: NavigatorProtocol {
    
    fileprivate var capturedUrl: URL!
    fileprivate var called: Bool = false
    
    func openUrl(_ url: URL) {
        called = true
        capturedUrl = url
    }
}

