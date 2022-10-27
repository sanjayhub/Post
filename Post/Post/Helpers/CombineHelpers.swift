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

// MARK: - FeedViewModel
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

// MARK: - DispatchQueue

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