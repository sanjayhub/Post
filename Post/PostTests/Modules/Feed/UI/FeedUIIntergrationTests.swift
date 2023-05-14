//
//  FeedUIIntergrationTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 14/05/23.
//

import XCTest
import SwiftUI
import Combine

@testable import Post

class FeedUIIntergrationTests: XCTestCase {
    
    func test_renders_view_with_title() {
        let sut = makeSUT()
        XCTAssertEqual(sut.navigationItem.title, "Your Post")
    }
}
private extension FeedUIIntergrationTests {
    
    func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> UIViewController {
        let sut = FeedUIComposer.compose(
            loader: { PassthroughSubject<[Feed], Error>().eraseToAnyPublisher() },
            imageLoader: { _ in PassthroughSubject<Data, Error>().eraseToAnyPublisher() }
        )
        
        checkForMemoryLeak(sut, file: file, line: line)
        return sut
    }
    
}

