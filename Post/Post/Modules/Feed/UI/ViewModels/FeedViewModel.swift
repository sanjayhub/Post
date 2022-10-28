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
    
    @Published var state: ViewState<[Feed]> = .loading
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func loadFeed() {
        state = .loading
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.state = .loaded(feed)
            }
        }
    }
}
