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
    
    func test_on_load_feed_success_delivers_successfully_loaded_feed() {
        var (sut, loader) = makeSUT()
        let feed = makeFeed()
        
        let exp = expectation(description: "wait for completion")
        sut.onFeedLoad = { received in
            XCTAssertEqual(received, feed)
            exp.fulfill()
        }
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
        wait(for: [exp], timeout: 1.0)
    }
}

private extension FeedViewModelTests {
    
    private func makeSUT() -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel(loader: loader.loadFeed(completion:))
        return (sut, loader)
    }
    
    func makeFeed(itemCount: Int = 5) -> [Feed] {
        return (0..<itemCount).map { index in
            return Feed(id: UUID().uuidString,
                        imageURL: makeURL("https://image-\(index)"),
                        likeCount: index,
                        user: Feed.User(
                            id: UUID().uuidString,
                            name: "name\(index)",
                            imageURL:makeURL("https://user-image-\(index)") )
            )
        }
    }
    
    private class LoaderSpy {
        
        private var request: [FeedLoaderCompletion] = []
        
        var loadFeedCount: Int {
            return request.count
        }
        
        func loadFeed(completion: @escaping FeedLoaderCompletion) {
            request.append(completion)
        }
        
        func loadFeedCompletes(with result: FeedLoaderResult, at index: Int = 0) {
            request[index](result)
        }
    }
    
}
