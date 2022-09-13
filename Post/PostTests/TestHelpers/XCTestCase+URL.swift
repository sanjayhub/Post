//
//  XCTestCase+URL.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 13/09/22.
//

import XCTest

extension XCTestCase {
    func makeURL(_ address: String = "http://any-url.com") -> URL {
        XCTestCase.makeURL(address)
    }
    static func makeURL(_ address: String = "http://any-url.com") -> URL {
        URL(string: address)!
    }
}
