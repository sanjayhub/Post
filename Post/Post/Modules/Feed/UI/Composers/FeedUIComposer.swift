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
    
    static func compose(loader: @escaping Loader, imageLoader: @escaping ImageLoader) -> UIViewController {
        
        let imageProvider = ImageLoaderProvider(imageLoader)
        let viewModel = FeedViewModel(loadFeedPublisher: loader)
        
        let rootView = FeedView(viewModel: viewModel, feedCard: { feed in
            
            FeedCard(item: feed, avatarView: { item in
                
                AvatarView(imageURL: item.user.imageURL, asynImageView: {
                    AsyncImageView(viewModel: .init(imageURL: item.user.imageURL,
                                                    loadImagePublisher: imageProvider.make(),
                                                    imageTransformer: UIImage.init
                                                   ),
                                   canRetry: false)
                })
                
            }, asyncImageView: { item in
                AsyncImageView(viewModel: .init(imageURL: item.imageURL,                                                                                         loadImagePublisher:imageProvider.make(),
                                                imageTransformer: UIImage.init))
            })
        })
        
        let viewController = UIHostingController(rootView: rootView)
        viewController.navigationItem.title = "Your Post"
        return viewController
    }
}
