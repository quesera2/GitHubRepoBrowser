import XCTest
import Model
@testable import ViewModel

@MainActor
final class ContentViewModelTests: XCTestCase {
    
    func testNormal() async throws {
        // 正常系：通信に成功してデータを返す
        let apiClient = MockAPIClient(expectResult: Array(dummyRepositoryData[...0]))
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)
        
        // 初期状態（エラー、ロード表示なし）
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        await Task.yield()
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertTrue(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを止めて結果を返す
        apiClient.resume()
        await result
        XCTAssertEqual(viewModel.repositories.count, 1)
        XCTAssertEqual(viewModel.repositories.first!.name, "テストデータ1")
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
    }
    
    func testFailure() async throws {
        // 異常系：通信に失敗してアラートを表示する
        let apiClient = MockAPIClient(expectError: .connectionError)
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)
        
        // 初期状態（エラー、ロード表示なし）
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        await Task.yield()
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertTrue(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを止めて結果を返す
        apiClient.resume()
        await result
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertTrue(viewModel.needShowError)
        XCTAssertEqual(viewModel.occursError, .responseError)
        
        // アラートを閉じると初期状態に戻る
        viewModel.needShowError = false
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
    }
    
    func testEmptyInput() async throws {
        // 入力が空のため何も実行しない
        let apiClient = MockAPIClient(expectResult: Array(dummyRepositoryData[...0]))
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)
        
        // 初期状態（エラー、ロード表示なし）
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        XCTAssertFalse(viewModel.isQueryEmpty)
        viewModel.query = ""
        XCTAssertTrue(viewModel.isQueryEmpty)
        
        // ロードを実行
        await viewModel.fetchRepository()
        
        // 初期状態と同じであること
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
    }
    
    func testTransition() {
        // 画面遷移のテスト
        let apiClient = MockAPIClient(expectResult: [])
        let navigator = MockNavigator()
        let viewModel = ContentViewModel(apiClient: apiClient, navigator: navigator)
        
        XCTAssertFalse(navigator.called)
        viewModel.openBrowser(item: dummyRepositoryData[2])
        XCTAssertTrue(navigator.called)
        XCTAssertEqual(navigator.capturedUrl, dummyRepositoryData[2].htmlURL)
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

fileprivate final class MockAPIClient: GitHubAPIClientProtocol {

    private let expectResult: [GitHubRepository]?
    private let expectError: GitHubAPIError?

    private var continuation: CheckedContinuation<[GitHubRepository], Error>!

    init(expectResult: [GitHubRepository]? = nil, expectError: GitHubAPIError? = nil) {
        self.expectResult = expectResult
        self.expectError = expectError
    }

    func fetchRepositories(userName: String) async throws -> [GitHubRepository] {
        return try await withCheckedThrowingContinuation { continuation in
            self.continuation = continuation
        }
    }
    
    func resume() {
        switch (expectResult, expectError) {
        case (let expectResult?, nil): self.continuation.resume(returning: expectResult)
        case (nil, let expectError?): self.continuation.resume(throwing: expectError)
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
