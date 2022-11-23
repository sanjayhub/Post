//
//  AvatarView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 23/11/22.
//

import SwiftUI

struct AvatarView: View {
    
    @EnvironmentObject var imageProvider: ImageLoaderProvider
    
    private let imageURL: URL
    
    init(imageURL: URL) {
        self.imageURL = imageURL
    }
    
    var body: some View {
        AsyncImageView(viewModel:
                .init(imageURL: imageURL,
                      loadImagePublisher: imageProvider.make(),
                      imageTransformer: UIImage.init
                     ),
                       canRetry: false
        )
        .clipShape(Circle())
        .overlay(
            Circle().stroke(
                Color(.secondarySystemBackground), lineWidth: 1)
            )
        
    }
}

