//
//  FeedViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import Foundation

class FeedViewModel {
    
    typealias LoaderResult = Result<[Feed], Error>
    typealias LoaderCompletion = (LoaderResult) -> Void
    typealias Loader = ((@escaping LoaderCompletion) -> Void)

    private let loader: Loader
    typealias Observer<T> = (T) -> Void
    var onFeedLoad: Observer<[Feed]>?
    var onLoadingStateChange: Observer<Bool>?
    
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func load() {
        onLoadingStateChange?(true)
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
