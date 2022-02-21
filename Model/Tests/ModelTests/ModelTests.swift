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
    
    func testExample() throws {        
        XCTAssertEqual("Wow", "Hello, World!")
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
