//
//  RemoteLoaderTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 10/10/22.
//

import XCTest
@testable import Post

class RemoteLoaderTests: XCTestCase {
    func test_init_does_not_request_data_from_url() {
        let (_, client) = makeSUT()
        XCTAssertEqual(client.requestedURL.count, 0)
    }
    
    func test_load_requests_data_from_url() {
        let url = makeURL()
        let (sut, client) = makeSUT(requestURL: url)
        sut.execute { _ in }
        XCTAssertEqual(client.requestedURL, [url])
    }
    
    func test_load_twice_requests_data_from_url_twice() {
        let url = makeURL()
        let (sut, client) = makeSUT(requestURL: url)
        sut.execute { _ in }
        sut.execute { _ in }
        XCTAssertEqual(client.requestedURL, [url, url])
    }
    
    func test_load_delivers_error_on_client_error() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivity), when: {
          let clientError = makeError()
            client.complete(with: clientError)
        })
    }
    
    func test_load_delivers_error_on_mapper_error() {
        let error = makeError()
        let (sut, client) = makeSUT(requestURL: makeURL()) { _, _ in
            throw error
        }
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            client.complete(withStatusCode: 200, data: makeData())
        })
    }
    
    func test_load_delivers_mapped_resource(){
        let resource = "resource"
        
        let (sut, client) = makeSUT(requestURL: makeURL()) { data, _ in
            String(data: data, encoding: .utf8)!
        }
        
        expect(sut, toCompleteWith: .success(resource), when: {
            client.complete(withStatusCode: 200, data: Data(resource.utf8))
        })
    }
    
    
}

private extension RemoteLoaderTests {
    private func makeSUT(
        requestURL: URL? = nil,
        mapper: @escaping RemoteLoader<String>.Mapper = {_, _ in "Any"},
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(requestURL ?? makeURL(), client: client, mapper: mapper)
        checkForMemoryLeak(client, file: file, line: line)
        checkForMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
    
    func failure(_ error: RemoteLoader<String>.Error) -> RemoteLoader<String>.Result {
        .failure(error)
    }
    
    func expect(_ sut: RemoteLoader<String>, toCompleteWith expectedResult: RemoteLoader<String>.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "wait for completion")
        
        sut.execute { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteLoader<String>.Error), .failure(expectedError as RemoteLoader<String>.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
}
