//
//  Endpoints.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 27/10/22.
//

import Foundation

extension Endpoint {
    static var PAGE_SIZE: Int { 25 }
    static func feed(page: Int = 0, size: Int = PAGE_SIZE) -> Self {
        return .init(host: "dummyapi.io", path: ["data", "v1", "post"], queryItems: ["limit": "\(size)"])
    }
}
