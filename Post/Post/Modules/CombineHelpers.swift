//
//  CombineHelpers.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import Foundation
import Combine

// MARK:- FeedViewModel
extension FeedViewModel {
    convenience init(loadFeedPublisher publisher: @escaping () -> AnyPublisher<[Feed], Error> ) {
        self.init(loader: { completion in
            publisher().subscribe(
                Subscribers.Sink(
                    receiveCompletion: { _ in },
                    receiveValue: { result in completion(.success(result)) }
                ))
        })
    }
}
