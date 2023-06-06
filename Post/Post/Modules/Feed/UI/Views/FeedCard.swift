//
//  FeedCard.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 01/12/22.
//

import SwiftUI

struct FeedCard: View {

    private let item: Feed
    private let avatarView: (Feed) -> AvatarView
    private let asyncImageView: (Feed) -> AsyncImageView
    
    init(item: Feed,
         avatarView: @escaping (Feed) -> AvatarView,
         asyncImageView: @escaping (Feed) -> AsyncImageView) {
        self.item = item
        self.avatarView = avatarView
        self.asyncImageView = asyncImageView
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            avatarView(item)
                .frame(width: 48, height: 48)
                .padding(.leading)
                .padding(.bottom)
                .zIndex(1)
            
            VStack(spacing: 0) {
                asyncImageView(item)
                    .frame(height: 500)
                
                FeedCardFooterView(name: item.user.name, likes: item.likeCount)
                    .background(Color(.secondarySystemBackground))
            }
        }
    }
}


