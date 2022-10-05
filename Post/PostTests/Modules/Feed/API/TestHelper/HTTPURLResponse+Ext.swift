//
//  HTTPURLResponse+Ext.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 05/10/22.
//

import Foundation

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: URL(string: "https://any-url.com")!, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}
