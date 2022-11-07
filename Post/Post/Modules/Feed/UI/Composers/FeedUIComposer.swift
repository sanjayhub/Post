//
//  FeedUIComposer.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI
import Combine

enum FeedUIComposer {
    typealias Loader = () -> AnyPublisher<[Feed], Error>
    typealias ImageLoader = (_ url: URL) -> AnyPublisher<Data, Error>
    
    static func compose(loader: @escaping Loader, imageLoader: @escaping ImageLoader) -> UIHostingController<FeedListView> {
        let viewModel = FeedViewModel(loadFeedPublisher: loader)
        let rootView = FeedListView(viewModel: viewModel)
        let viewController = UIHostingController(rootView: rootView)
        return viewController
    }
}
