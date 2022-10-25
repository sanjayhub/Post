//
//  FeedViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import Foundation

typealias FeedLoaderResult = Result<[Feed], Error>
typealias FeedLoaderCompletion = (FeedLoaderResult) -> Void
typealias FeedLoader = ((@escaping FeedLoaderCompletion) -> Void)

struct FeedViewModel {
    private let loader: FeedLoader
    var onFeedLoad: (([Feed]) -> Void)?
    
    init(loader: @escaping FeedLoader) {
        self.loader = loader
    }
    
    func load() {
        loader { result in
            if let feed = try? result.get() {
                onFeedLoad?(feed)
            }
        }
    }
}
