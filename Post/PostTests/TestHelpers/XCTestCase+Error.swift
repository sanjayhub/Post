//
//  XCTestCase+Error.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 13/09/22.
//

import XCTest

extension XCTestCase  {
    func makeError(_ desc: String = "any error") -> NSError {
        XCTestCase.makeError(desc: desc)
    }
    
    static func makeError(desc: String = "any error") -> NSError {
        let userInfo = [NSLocalizedDescriptionKey: desc]
        return NSError(domain: "com.example.error", code: 0, userInfo: userInfo)
    }
}
