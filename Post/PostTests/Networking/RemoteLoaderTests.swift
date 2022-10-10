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
        let (sut, client) = makeSUT()
        sut.execute(.init(url: url)) { _ in }
        XCTAssertEqual(client.requestedURL, [url])
    }
    
    func test_load_twice_requests_data_from_url_twice() {
        let url = makeURL()
        let (sut, client) = makeSUT()
        sut.execute(.init(url: url)) { _ in }
        sut.execute(.init(url: url)) { _ in }
        XCTAssertEqual(client.requestedURL, [url, url])
    }
}

private extension RemoteLoaderTests {
    private func makeSUT(
        mapper: @escaping RemoteLoader<String>.Mapper = {_, _ in "Any"},
        file: StaticString = #file,
        line: UInt = #line
    ) -> (sut: RemoteLoader<String>, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteLoader<String>(client: client, mapper: mapper)
        checkForMemoryLeak(client, file: file, line: line)
        checkForMemoryLeak(sut, file: file, line: line)
        return (sut, client)
    }
}
