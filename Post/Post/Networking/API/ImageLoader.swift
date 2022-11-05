//
//  ImageLoader.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 05/11/22.
//

import Foundation

protocol ImageDataLoaderTask {
    func cancel()
}

protocol ImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func load(imageFrom url: URL,completion: @escaping (Result) -> Void) -> ImageDataLoader
}
