//
//  HTTPClient.swift
//

import Foundation

public protocol HTTPClientTask {
    func cancel()
}

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>
    
    typealias DispatchCompletion = (Result) -> Void
    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate threads, if needed.
    @discardableResult
    func dispatch(_ request: URLRequest, completion: @escaping DispatchCompletion) -> HTTPClientTask
}
