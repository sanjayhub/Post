//
//  AsyncImageView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 03/11/22.
//

import SwiftUI

struct AsyncImageView: View {
    typealias ViewModel = AsyncImageViewModel<UIImage>
    
    @ObservedObject private var viewModel: ViewModel
    private var canRetry: Bool
    
    init(viewModel: ViewModel, canRetry: Bool = true) {
        self.viewModel = viewModel
        self.canRetry = canRetry
    }
    
    var body: some View {
        Group {
            switch viewModel.state {
            case .loading:
                Color(.tertiaryLabel)
                    .onAppear(perform: viewModel.loadImage)
            case let .loaded(image):
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .error where canRetry:
                Text("oops.retry again")
            default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .onDisappear(perform: viewModel.cancel)
    }
}

