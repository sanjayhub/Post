//
//  FeedViewModelTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import XCTest
import Combine
@testable import Post
import SwiftUI

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
        let (sut, loader) = makeSUT()
        let feed = makeFeed()
        
        sut.onFeedLoad = { received in
            XCTAssertEqual(received, feed)
        }
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
    }
    
    func test_load_does_not_deliver_result_after_instance_has_been_deallocated() {
        let loader = LoaderSpy()
        let feed = makeFeed()
        var sut: FeedViewModel? = FeedViewModel(loadFeedPublisher: loader.loadFeedPublisher)
        var output: [Any] = []
        sut?.onFeedLoad = { output.append($0) }
        sut?.load()
        sut = nil
        loader.loadFeedCompletes(with: .success(feed))
        XCTAssertEqual(output.isEmpty, true)
    }
    
    func test_on_load_notifies_client_of_loading_state_changed() {
        let feed = makeFeed()
        let (sut, loader) = makeSUT()
        var output: [Bool] = []
        sut.onLoadingStateChange = { output.append($0) }
        sut.load()
        loader.loadFeedCompletes(with: .success(feed))
        XCTAssertEqual(output, [true, false])
    }
}

private extension FeedViewModelTests {
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedViewModel, loader: LoaderSpy) {
        let loader = LoaderSpy()
        let sut = FeedViewModel(loadFeedPublisher: loader.loadFeedPublisher)
        checkForMemoryLeak(loader,file: file,line: line)
        checkForMemoryLeak(sut,file: file,line: line)
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
        
        private var request: [PassthroughSubject<[Feed], Error>] = []
        
        var loadFeedCount: Int {
            return request.count
        }
        
        //        func loadFeed(completion: @escaping FeedLoaderCompletion) {
        //            request.append(completion)
        //        }
        
        func loadFeedCompletes(with result: FeedViewModel.LoaderResult, at index: Int = 0) {
            switch result {
            case let .success(feed):
                request[index].send(feed)
            default: break
            }
        }
        
        func loadFeedPublisher() -> AnyPublisher<[Feed], Error> {
            let publisher = PassthroughSubject<[Feed], Error>()
            request.append(publisher)
            return publisher.eraseToAnyPublisher()
        }
    }
    
}
