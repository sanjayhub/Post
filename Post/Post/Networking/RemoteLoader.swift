//
//  RemoteLoader.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 07/10/22.
//

import Foundation

class RemoteLoader<Resource> {
    let client: HTTPClient
    let mapper: Mapper
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    typealias Mapper = (Data, HTTPURLResponse) throws -> Resource
    typealias Result = Swift.Result<Resource, Swift.Error>
    
    init(client: HTTPClient, mapper: @escaping Mapper) {
        self.client = client
        self.mapper = mapper
    }
    
    func execute(_ request: URLRequest, completion: @escaping (Result) -> Void) {
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
