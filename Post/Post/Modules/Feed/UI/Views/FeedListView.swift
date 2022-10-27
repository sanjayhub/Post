//
//  FeedListView.swift
//  Post
//
//  Created by Kumar, Sanjay (623) on 25/10/22.
//

import SwiftUI

struct FeedListView: View {
    
    @ObservedObject private (set) var viewModel: FeedViewModel
    @State private var isLoading = false
    @State private var items: [Feed] = []
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            if isLoading {
                Text("is Loading")
            } else {
                ForEach(items, id: \.id) { feed in
                    Text(feed.id)
                }
            }
        }
        .onAppear(perform: loadFeed)
        .padding()
    }
}

private extension FeedListView {
    func loadFeed() {
        viewModel.onLoadingStateChange = { loadingState in
            isLoading = loadingState
        }
        viewModel.onFeedLoad = { items in
            self.items = items
        }
        viewModel.load()
    }
}

