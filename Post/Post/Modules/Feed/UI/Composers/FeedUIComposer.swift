//
//  FeedUIComposer.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI
import Combine

enum FeedUIComposer {
    static func compose(loader: @escaping () -> AnyPublisher<[Feed], Error>) -> UIHostingController<FeedListView> {
        let viewModel = FeedViewModel(loadFeedPublisher: loader)
        let rootView = FeedListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
