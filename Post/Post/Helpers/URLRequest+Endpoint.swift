//
//  URLRequest+Endpoint.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 27/10/22.
//

import Foundation

extension URLRequest {
    init(endpoint: Endpoint) {
        self.init(url: endpoint.url)
    }
}
