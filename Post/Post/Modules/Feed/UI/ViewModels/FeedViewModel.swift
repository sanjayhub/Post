//
//  FeedViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 06/10/22.
//

import Foundation

class FeedViewModel: ObservableObject {
    
    typealias LoaderResult = Result<[Feed], Error>
    typealias LoaderCompletion = (LoaderResult) -> Void
    typealias Loader = ((@escaping LoaderCompletion) -> Void)

    private let loader: Loader
    typealias Observer<T> = (T) -> Void
    @Published var onFeedLoad: Observer<[Feed]>?
    @Published var onLoadingStateChange: Observer<Bool>?
    
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func loadFeed() {
        onLoadingStateChange?(true)
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
