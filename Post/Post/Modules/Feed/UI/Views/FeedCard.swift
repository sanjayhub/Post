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
                
                HStack {
                    Text(item.user.name)
                        .foregroundColor(Color(.label))
                        .font(.body)
                        .offset(x: 56)
                    Spacer()
                    HStack {
                        Image("heart_icon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(.label))
                            .frame(width: 18, height: 18)
                        Text("\(item.likeCount)")
                            .foregroundColor(Color(.label))
                            .font(.footnote)
                        
                        Image("bookmark_icon")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(Color(.label))
                            .frame(width: 18, height: 18)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
            }
            
        }
        
    }
}


