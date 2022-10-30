//
//  AsyncImageViewModelTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 30/10/22.
//

import XCTest
@testable import Post

class AsyncImageViewModelTests: XCTestCase {
    func test_on_init_does_not_message_loader() {
        let (_, loader) = makeSUT()
        XCTAssertEqual(loader.loadImageCount, 0)
    }
    
    func test_on_load_dispatches_load_image_requests() {
        let imageURL = makeURL("https://image.com")
        let (sut, loader) = makeSUT(imageURL: imageURL)
        XCTAssertTrue(loader.requestedURL.isEmpty)
        sut.loadImage()
        XCTAssertEqual(loader.requestedURL, [imageURL])
    }
    
    func test_on_load_image_success_delivers_successfully_mapped_image() {
        let (sut, loader) = makeSUT(imageTransformer: { _ in
            "mapped image"
        })
        sut.loadImage()
        loader.loadImageCompletes(with: .success(makeData()))
        
        XCTAssertEqual(sut.state, .loaded("mapped image"))
    }
    
    func test_on_load_image_notifies_clients_of_loading_state_change() {
        let (sut, loader) = makeSUT()
        sut.loadImage()
        XCTAssertEqual(sut.state, .loading)
        loader.loadImageCompletes(with: .success(makeData()))
        XCTAssertEqual(sut.state, .loaded("any"))
    }
    
    func test_on_cancel_pending_image_request_notifies_handler() {
        let imageURL = makeURL("https://www.image.com")
        let (sut, loader) = makeSUT(imageURL: imageURL)
        sut.loadImage()
        XCTAssertEqual(sut.state, .loading)
        XCTAssertTrue(loader.cancelledRequests.isEmpty)
        sut.cancel()
        XCTAssertEqual(loader.cancelledRequests, [imageURL])
    }
    
}

private extension AsyncImageViewModelTests {
    private func makeSUT(
        imageURL: URL? = nil,
        imageTransformer: @escaping (Data) -> String? = { _ in "any"}
    ) -> (sut:AsyncImageViewModel<String>, loader: LoaderSpy ) {
      let loader = LoaderSpy()
        let sut = AsyncImageViewModel(imageURL: imageURL ?? makeURL(), loader: loader.loadImage, imageTransformer: imageTransformer)
        return (sut, loader)
    }
    
    class LoaderSpy {
        typealias ImageLoaderResult = AsyncImageViewModel<String>.LoaderResult
        typealias ImageLoaderCompletion = AsyncImageViewModel<String>.LoaderCompletion
        
        
        var requests: [(url: URL, completion: ImageLoaderCompletion)] = []
        
        var loadImageCount: Int {
            requests.count
        }
        
        var requestedURL: [URL] {
            requests.map(\.url)
        }
        
        private (set) var cancelledRequests: [URL] = []
        
        func loadImage(_ url: URL, completion: @escaping ImageLoaderCompletion) -> HTTPClientTask {
            requests.append((url, completion))
            return NullTask { [weak self] in self?.cancelledRequests.append(url) }
        }
        
        func loadImageCompletes(with result: ImageLoaderResult, at index: Int = 0) {
            requests[index].completion(result)
        }
        
        private struct NullTask: HTTPClientTask {
            var callback: () -> Void
            func cancel() {
                callback()
            }
        }
    }
}
