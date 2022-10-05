//
//  FeedMapper.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 05/10/22.
//

import Foundation

enum FeedMapper {
    enum Error: Swift.Error {
        case invalidData
    }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Feed] {
        let decoder = JSONDecoder()
        guard isOK(response), let root = try? decoder.decode(Root.self, from: data) else {
            throw Error.invalidData
        }
        return root.data.asFeedDTO
    }
}

private extension FeedMapper {
    static var OK_200: Int { 200 }
    
    static func isOK(_ response: HTTPURLResponse) -> Bool {
        response.statusCode == OK_200
    }
    
    struct Root: Decodable {
        let data: [Feed]
        
        struct Feed: Decodable {
            let id: String
            let image: URL
            let likes: Int
            let owner: User
            
            struct User: Decodable {
                let id: String
                let picture: URL
                let firstName: String
                let lastName: String
            }
        }
    }
}

private extension Array where Element == FeedMapper.Root.Feed {
    var asFeedDTO: [Feed] {
        return map { item in
            Feed(
                id: item.id,
                imageURL: item.image,
                likeCount: item.likes,
                user: Feed.User(
                    id: item.owner.id,
                    name: "\(item.owner.firstName) \(item.owner.lastName)" ,
                    imageURL: item.owner.picture
                 )
            )
        }
    }
}
