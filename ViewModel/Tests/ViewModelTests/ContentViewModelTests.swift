import XCTest
import Model
@testable import ViewModel

@MainActor
final class ContentViewModelTests: XCTestCase {
    
    func testNormal() async throws {
        let apiClient = MockAPIClient(expectResult: Array(dummyRepositoryData[...0]))
        let viewModel = ContentViewModel(apiClient: apiClient)
        
        // 初期状態（エラー、ロード表示なし）
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        try await Task.sleep(nanoseconds: 1)
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertTrue(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを止めて結果を返す
        apiClient.returnResult()
        await result
        XCTAssertEqual(viewModel.repositories.count, 1)
        XCTAssertEqual(viewModel.repositories.first!.name, "テストデータ1")
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
    }
    
    func testFailure() async throws {
        let apiClient = MockAPIClient(expectError: .connectionError)
        let viewModel = ContentViewModel(apiClient: apiClient)
        
        // 初期状態（エラー、ロード表示なし）
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertFalse(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを実行中
        async let result: () = viewModel.fetchRepository()
        try await Task.sleep(nanoseconds: 1)
        XCTAssertEqual(viewModel.repositories, [])
        XCTAssertTrue(viewModel.showProgress)
        XCTAssertFalse(viewModel.needShowError)
        XCTAssertNil(viewModel.occursError)
        
        // ロードを止めて結果を返す
        apiClient.returnResult()
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
    
    func returnResult() {
        switch (expectResult, expectError) {
        case (let expectResult?, nil): continuation.resume(returning: expectResult)
        case (nil, let expectError?): continuation.resume(throwing: expectError)
        default: fatalError()
        }
    }
}
