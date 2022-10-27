//
//  FeedSnapshotTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 27/10/22.
//

import Foundation
import XCTest
import SwiftUI

@testable import Post

class FeedSnapshotTests: XCTestCase {
    
    func test_feed_with_content() {
        let content = feedWithContent
        let viewModel = FeedViewModel(loader: { $0(.success(content)) })
        let sut = makeSUT(viewModel: viewModel)
        
        viewModel.load()
        
        assert(snapshot: sut.snapshot(for: .iPhone8(style: .light)), named: "FEED_WITH_CONTENT_light")
    }
}

private extension FeedSnapshotTests {
    func makeSUT(viewModel: FeedViewModel) -> UIViewController {
        let rootView = FeedListView(viewModel: viewModel)
        let controller = UIHostingController(rootView: rootView)
        controller.loadViewIfNeeded()
        return controller
    }
    
    
    var feedWithContent: [Feed] {
        return [
            Feed(id: "id 1", imageURL: makeURL(), likeCount: 25, user: .init(id: UUID().uuidString, name: "Some Name", imageURL: makeURL())),
            Feed(id: "id 2", imageURL: makeURL(), likeCount: 34, user: .init(id: UUID().uuidString, name: "Some'Other Name", imageURL: makeURL()))
        ]
    }
}
