//
//  RemoteLoader.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 07/10/22.
//

import Foundation

class RemoteLoader<Resource> {
    private let client: HTTPClient
    private let mapper: Mapper
    private let requestURL: URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    typealias Result = Swift.Result<Resource, Swift.Error>
    
    init(_ requestURL: URL, client: HTTPClient, mapper: @escaping Mapper) {
        self.requestURL = requestURL
        self.client = client
        self.mapper = mapper
    }
    
    func execute(completion: @escaping (Result) -> Void) {
        let request = URLRequest(url: requestURL)
        client.dispatch(request) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success((data, response)):
                completion(self.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            return .success(try mapper(data,response))
        } catch {
            return .failure(Error.invalidData)
        }
    }
}
