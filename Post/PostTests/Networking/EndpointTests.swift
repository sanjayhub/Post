//
//  EndpointTests.swift
//  PostTests
//
//  Created by Kumar, Sanjay (623) on 03/10/22.
//

import XCTest
@testable import Post

class EndpointTests: XCTestCase {
    func test_set_host_for_url() {
        let host = "api.domain.com"
        let sut = Endpoint(host: host)
        
        XCTAssertEqual(host, sut.url.host)
    }
    
    func test_set_path_for_url() {
        let path = ["some", "path"]
        let sut = Endpoint(host: "api.domain.com", path: path)
        XCTAssertEqual(sut.url.path,"/some/path" )
    }
    
    func test_set_query_for_url() {
        let query: KeyValuePairs<String, String> = ["key1": "value1", "key2": "value2"]
        let sut = Endpoint(host: "api.domain.com", queryItems: query)
        XCTAssertEqual(sut.url.query, "key1=value1&key2=value2" )
    }
    
}
