import Foundation

public protocol HTTPClient: Sendable {
    func data(from url: URL) async throws -> (Data, URLResponse)
    
    func data(for: URLRequest) async throws -> (Data, URLResponse)
}
