//
//  ImageLoaderProvider.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 14/11/22.
//

import Foundation
import Combine

class ImageLoaderProvider: ObservableObject {
    private var loader: (_ imageURL: URL) -> AnyPublisher<Data, Error>
    
    init(_ loader: @escaping (_ imageURL: URL) -> AnyPublisher<Data, Error>) {
        self.loader = loader
    }
    
    func make() -> (_ imageURL: URL) -> AnyPublisher<Data, Error> {
        return loader
    }
}
