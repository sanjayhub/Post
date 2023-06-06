//
//  FeedCardViewModel.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/05/23.
//

import SwiftUI

struct FeedCardViewModel: Identifiable, Equatable {
    static func == (lhs: FeedCardViewModel, rhs: FeedCardViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    let id: String
    let username: String
    let likes: Int
    let avatarViewModel: AsyncImageViewModel<UIImage>
    let feedViewModel: AsyncImageViewModel<UIImage>
    
    init(feed: Feed, avatarViewModel: AsyncImageViewModel<UIImage>, feedViewModel: AsyncImageViewModel<UIImage>) {
        self.id = feed.id
        self.username = feed.user.name
        self.likes = feed.likeCount
        self.avatarViewModel = avatarViewModel
        self.feedViewModel = feedViewModel
    }
}
