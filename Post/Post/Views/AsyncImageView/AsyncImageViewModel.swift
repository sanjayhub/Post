//
//  AsyncImageViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 30/10/22.
//

import Foundation

final class AsyncImageViewModel<Image>: ObservableObject where Image: Equatable {
    typealias LoaderResult = Result<Data, Error>
    typealias LoaderCompletion = (LoaderResult) -> Void
    typealias Loader = (URL, @escaping LoaderCompletion) -> HTTPClientTask
    
    private var imageURL: URL
    private let loader: Loader
    
    private var imageTransformer: (Data) -> Image?
    
    private var task: HTTPClientTask?
    
    @Published var state: ViewState<Image> = .loading
    
    init(imageURL: URL, loader: @escaping Loader, imageTransformer: @escaping (Data) -> Image?) {
        self.imageURL = imageURL
        self.loader = loader
        self.imageTransformer = imageTransformer
    }
    
    func loadImage() {
        task = loader(imageURL) { [weak self] in
            self?.handle($0)
        }
    }
    func cancel() {
        task?.cancel()
        task = nil
    }
    
    private func handle(_ result: LoaderResult) {
        if let image = (try? result.get()).flatMap(imageTransformer) {
            state = .loaded(image)
        } else {
            state = .error(message: "something went wrong")
        }
    }
}
