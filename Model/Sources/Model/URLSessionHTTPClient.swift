import Foundation

final public class URLSessionHTTPClient: HTTPClient {
    
    private let urlSession: URLSession
    
    public init(_ urlSession: URLSession) {
        self.urlSession = urlSession
    }
    
    public func data(from url: URL) async throws -> (Data, URLResponse) {
        try await self.urlSession.data(from: url)
    }
    
    public func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        try await self.urlSession.data(for: request)
    }
}
