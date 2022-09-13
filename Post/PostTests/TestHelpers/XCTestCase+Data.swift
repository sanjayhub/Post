//
//  XCTestCase+Data.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 13/09/22.
//

import XCTest

extension XCTestCase {
    func makeData(_ value: String? = .none) -> Data {
        guard let value = value else { return Data() }
        return Data(value.utf8)
    }
}

