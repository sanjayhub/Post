//
//  ImageDataMapper.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 06/11/22.
//

import Foundation

enum ImageDataMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> Data {
        guard isOK(response), !data.isEmpty else {
            throw Error.invalidData
        }
        return data
    }
}

private extension ImageDataMapper {
    static var OK_200: Int { 200 }
    
    static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == OK_200
    }
}
