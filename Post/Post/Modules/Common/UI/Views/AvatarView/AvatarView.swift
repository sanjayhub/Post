//
//  AvatarView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 23/11/22.
//

import SwiftUI

struct AvatarView: View {
    
    private let imageURL: URL
    private let asynImageView: () -> AsyncImageView
    
    init(imageURL: URL, asynImageView: @escaping () -> AsyncImageView) {
        self.imageURL = imageURL
        self.asynImageView = asynImageView
    }
    
    var body: some View {
        asynImageView()
            .clipShape(Circle())
            .overlay(
                Circle().stroke(
                    Color(.secondarySystemBackground), lineWidth: 1)
            )
    }
}
