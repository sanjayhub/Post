//
//  Feed.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 03/10/22.
//

import Foundation

struct Feed: Hashable {
    
    let id: String
    let imageURL: URL
    let likeCount: Int
    let user: User
    
    struct User: Hashable {
        let id: String
        let name: String
        let imageURL: URL
    }
}

extension Feed: Identifiable { }
