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
    @Published var feed: [Feed] = []
    @Published var isLoading: Bool = false
    
    
    init(loader: @escaping Loader) {
        self.loader = loader
    }
    
    func loadFeed() {
        isLoading = true
        loader { [weak self] result in
            if let feed = try? result.get() {
                self?.feed = feed
            }
            self?.isLoading = false
        }
    }
}
