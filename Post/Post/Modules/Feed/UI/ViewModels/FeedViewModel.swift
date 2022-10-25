//
//  FeedViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import Foundation

typealias FeedLoaderCompletion = (Result<[Feed], Error>) -> Void
typealias FeedLoader = ((@escaping FeedLoaderCompletion) -> Void)

struct FeedViewModel {
    private let loader: FeedLoader
    
    init(loader: @escaping FeedLoader) {
        self.loader = loader
    }
    
    func load() {
        loader { _ in }
    }
}
