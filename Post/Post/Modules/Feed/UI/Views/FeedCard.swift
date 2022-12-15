//
//  FeedCard.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 01/12/22.
//

import SwiftUI

struct FeedCard: View {
    
    @EnvironmentObject private var imageProvider: ImageLoaderProvider
    private let item: Feed
    
    init(item: Feed) {
        self.item = item
    }
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            AvatarView(imageURL: item.user.imageURL)
                .frame(width: 48, height: 48)
                .padding(.leading)
                .padding(.bottom)
                .zIndex(1)
            
            VStack(spacing: 0) {
                AsyncImageView(
                    viewModel: .init(
                        imageURL: item.imageURL,
                        loadImagePublisher: imageProvider.make(),
                        imageTransformer: UIImage.init
                    )
                ).frame(height: 500)
                
                FeedCardFooterView(name: item.user.name, likes: item.likeCount)
                    .background(Color(.secondarySystemBackground))
            }
        }
    }
}


