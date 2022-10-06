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
}
private extension FeedViewModelTests {
    

    private func makeSUT() -> (sut: FeedViewModel, loader: LoaderSpy) {
        return (sut: FeedViewModel(), loader: LoaderSpy())
    }
    
    private class LoaderSpy {
        var loadFeedCount: Int {
            return 0
        }
    }
}
