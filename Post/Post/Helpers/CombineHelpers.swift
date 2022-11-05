//
//  CombineHelpers.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import Foundation
import Combine

// MARK: - HTTPClient

extension HTTPClient {
    typealias Publisher = AnyPublisher<(Data, HTTPURLResponse), Error>
    
    func dispatchPublisher(for request: URLRequest) -> Publisher {
        var task: HTTPClientTask?
        
        return Deferred {
            return Future { completion in
                task = self.dispatch(request, completion: completion)
            }
            
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

// MARK: - ImageDataLoader

extension ImageDataLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    func loadImagePublisher(from url: URL) -> Publisher {
        var task: ImageDataLoaderTask?
        return Deferred {
            return Future { completion in
                task = self.load(imageFrom: url, completion: completion)
            }
        }
        .handleEvents(receiveCancel: { task?.cancel() })
        .eraseToAnyPublisher()
    }
}

// MARK: - FeedViewModel
extension FeedViewModel {
    typealias Publisher = AnyPublisher<[Feed], Error>
    convenience init(loadFeedPublisher publisher: @escaping () -> Publisher ) {
        self.init(loader: { completion in
            publisher().subscribe(
                Subscribers.Sink(
                    receiveCompletion: { _ in },
                    receiveValue: { result in completion(.success(result)) }
                ))
        })
    }
}

// MARK: - AsyncImageViewModel
extension AsyncImageViewModel {
    typealias Publisher = AnyPublisher<Data, Error>
    convenience init(imageURL: URL, loadImagePublisher publisher: @escaping (URL) -> Publisher, imageTransformer: @escaping (Data) -> Image?) {
        self.init(imageURL: imageURL, loader: { url, completion in
            
            var cancellable: AnyCancellable?
            let task = ImageDataLoaderTaskWrapper(completion)
            
            cancellable = publisher(imageURL)
                .handleEvents(receiveCancel: {})
                .sink { completion in
                    if case let .failure(error) = completion {
                        task.complete(with: .failure(error))
                    }
                    cancellable?.cancel()
                    cancellable = nil
                    task.cancel()
                } receiveValue: { imageData in
                    task.complete(with: .success(imageData))
                }
            
            task.onCancel = cancellable?.cancel
            return task
        }, imageTransformer: imageTransformer)
        
    }
    
    
    private class ImageDataLoaderTaskWrapper: ImageDataLoaderTask {
        var wrapped: ImageDataLoaderTask?
        var onCancel: (() -> Void)?
        
        private var completion: ((ImageDataLoader.Result) -> Void)?
        
        init(_ completion: @escaping (ImageDataLoader.Result) -> Void) {
            self.completion = completion
        }
        
        func complete(with result: ImageDataLoader.Result) {
            completion?(result)
        }
        
        func cancel() {
            preventFurtherCompletions()
            wrapped?.cancel()
            onCancel?()
        }
        
        func preventFurtherCompletions() {
            completion = nil
        }
    }
}

// MARK: - DispatchQueue

extension Publisher {
    func dispatchOnMainQueue() -> AnyPublisher<Output, Failure> {
        receive(on: DispatchQueue.immediateWhenOnMainQueueScheduler).eraseToAnyPublisher()
    }
}

extension DispatchQueue {
    
    static var immediateWhenOnMainQueueScheduler: ImmediateWhenOnMainQueueScheduler {
        ImmediateWhenOnMainQueueScheduler.shared
    }
    
    struct ImmediateWhenOnMainQueueScheduler: Scheduler {
        typealias SchedulerTimeType = DispatchQueue.SchedulerTimeType
        
        typealias SchedulerOptions = DispatchQueue.SchedulerOptions
        
        var now: SchedulerTimeType {
            DispatchQueue.main.now
        }
        
        static let shared = Self()
        
        var minimumTolerance: SchedulerTimeType.Stride {
            DispatchQueue.main.minimumTolerance
        }
        
        private static let key = DispatchSpecificKey<UInt8>()
        private static let value = UInt8.max
        
        private init() {
            DispatchQueue.main.setSpecific(key: Self.key, value: Self.value)
        }
        
        private func isMainQueue() -> Bool {
            
            return DispatchQueue.getSpecific(key: Self.key) == Self.value
        }
        
        func schedule(options: SchedulerOptions?, _ action: @escaping () -> Void) {
            guard isMainQueue() else {
                return DispatchQueue.main.schedule(options: options, action)
            }
            action()
        }
        
        func schedule(after date: SchedulerTimeType, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) {
            DispatchQueue.main.schedule(after: date, tolerance: tolerance, options: options, action)
        }
        
        func schedule(after date: SchedulerTimeType, interval: SchedulerTimeType.Stride, tolerance: SchedulerTimeType.Stride, options: SchedulerOptions?, _ action: @escaping () -> Void) -> Cancellable {
            DispatchQueue.main.schedule(after: date, interval: interval, tolerance: tolerance, action)
        }
        
    }
}
