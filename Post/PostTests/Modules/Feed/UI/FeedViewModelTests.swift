//
//  FeedViewModelTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import XCTest
@testable import Post

class FeedViewModelTests: XCTestCase {
    
    func test_on_init_does_not_message_loader() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCount, 0)
    }
    
    func test_on_load_dispatches_load_feed_request() {
        let (sut, loader) = makeSUT()
        XCTAssertEqual(loader.loadFeedCount, 0)
        sut.load()
        XCTAssertEqual(loader.loadFeedCount, 1)
    }
}

private extension FeedViewModelTests {
    
    private func makeSUT() -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel(loader: loader.loadFeed(completion:))
        return (sut, loader)
    }
    
    private class LoaderSpy {
        
        private var request: [FeedLoaderCompletion] = []
        
        var loadFeedCount: Int {
            return request.count
        }
        
        func loadFeed(completion: @escaping FeedLoaderCompletion) {
            request.append(completion)
        }
    }
}
